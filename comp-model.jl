using PowerModels
using Ipopt
using Gurobi
using Juniper

using CSV
using DataFrames

include("common.jl")

case = parse_file("data/pglib_opf_case14_ieee_mod.m")

#result = run_ac_opf(case, with_optimizer(Ipopt.Optimizer, tol=1e-6))
const GRB_ENV = Gurobi.Env()

mn_case = replicate(case, length(summer_wkdy_15min_scalar))
for (i,scalar) in enumerate(summer_wkdy_15min_scalar)
    network = mn_case["nw"]["$(i)"]
    network["scalar"] = scalar
    for (i,load) in network["load"]
        load["pd"] = scalar*load["pd"]
        load["qd"] = scalar*load["qd"]
    end
end

ns_mn_case = deepcopy(mn_case)
for (n,network) in ns_mn_case["nw"]
    network["storage"] = Dict()
end
ac_ns_mn_result = run_mn_opf(ns_mn_case, ACPPowerModel, with_optimizer(Ipopt.Optimizer, tol=1e-6))

soc_mn_result = run_mn_strg_opf(mn_case, SOCWRPowerModel, with_optimizer(Gurobi.Optimizer, GRB_ENV))
dc_mn_result = run_mn_strg_opf(mn_case, DCPPowerModel, with_optimizer(Gurobi.Optimizer, GRB_ENV))

# seems to work
ac_nl_mn_result = PowerModels._run_mn_mc_strg_opf(mn_case, ACPPowerModel, with_optimizer(Ipopt.Optimizer, tol=1e-4))
println(ac_nl_mn_result["termination_status"])

juniper = with_optimizer(Juniper.Optimizer, nl_solver=with_optimizer(Ipopt.Optimizer, tol=1e-4, print_level=0))
ac_mn_result = run_mn_strg_opf(mn_case, ACPPowerModel, juniper)
#ac_mn_result = ac_nl_mn_result
println(ac_mn_result["termination_status"])

println("AC Base & $(ac_ns_mn_result["objective"]) & $(ac_ns_mn_result["solve_time"])")
println("AC-NL & $(ac_nl_mn_result["objective"]) & $(ac_nl_mn_result["solve_time"])")
println("AC-MI & $(ac_mn_result["objective"]) & $(ac_mn_result["solve_time"])")
println("SOC-MI & $(soc_mn_result["objective"]) & $(soc_mn_result["solve_time"])")
println("DC-MI & $(dc_mn_result["objective"]) & $(dc_mn_result["solve_time"])")

files = [
    ("ac-ns.csv", ac_ns_mn_result),
    ("ac.csv", ac_nl_mn_result),
    ("soc.csv", soc_mn_result),
    ("dc.csv", dc_mn_result),
]

for (file, mn_result) in files
    mn_case_tmp = deepcopy(mn_case)
    update_data!(mn_case_tmp, mn_result["solution"])

    ids = Int64[]
    time_str = String[]
    pg = Float64[]
    pd = Float64[]
    ps = Float64[]
    se = Float64[]

    nw_keys = sort(collect(keys(mn_case_tmp["nw"])), by=x->parse(Int, x))
    for n in nw_keys
        network = mn_case_tmp["nw"][n]
        nid = parse(Int, n)

        hour = trunc(Int, (nid-1)/4)
        minute = 15*((nid-1)%4)

        push!(ids, nid)
        push!(time_str, "$(hour):$(minute):00")
        pg_total = sum(gen["pg"] for (i,gen) in network["gen"]); push!(pg, pg_total)
        pd_total = sum(load["pd"] for (i,load) in network["load"]); push!(pd, pd_total)
        ps_total = sum(storage["ps"] for (i,storage) in network["storage"]); push!(ps, ps_total)
        se_total = sum(get(storage, "se", 0.0) for (i,storage) in network["storage"]); push!(se, se_total)
    end

    df_cont_time = DataFrames.DataFrame(
        ids = ids,
        time = time_str,
        pg_total = pg,
        pd_total = pd,
        ps_total = ps,
        se_total = se
    )
    CSV.write(file, df_cont_time)
end
