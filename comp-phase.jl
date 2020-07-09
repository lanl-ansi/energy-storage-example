using PowerModels
import PowerModelsDistribution
using Ipopt
using Gurobi
using Juniper

using CSV
using DataFrames

include("common.jl")

case = parse_file("data/pglib_opf_case14_ieee_mod.m")

#result = run_ac_opf(case, with_optimizer(Ipopt.Optimizer, tol=1e-6))

PowerModelsDistribution.make_multiconductor!(case, 3)
for (i,load) in case["load"]
    load["pd"] = [load["pd"][1]*0.36, load["pd"][2]*0.33, load["pd"][3]*0.31]
    load["qd"] = [load["qd"][1]*0.36, load["qd"][2]*0.33, load["qd"][3]*0.31]
end

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
ac_ns_mn_result = PowerModelsDistribution.run_mn_mc_opf(ns_mn_case, ACPPowerModel, with_optimizer(Ipopt.Optimizer, tol=1e-6))


ac_nl_mn_result = PowerModelsDistribution.run_mn_mc_opf(mn_case, ACPPowerModel, with_optimizer(Ipopt.Optimizer, tol=1e-6))
println(ac_nl_mn_result["termination_status"])


update_data!(mn_case, ac_nl_mn_result["solution"])


nids = Int64[]
time_str = String[]
pg_1 = Float64[]
pg_2 = Float64[]
pg_3 = Float64[]
pd_1 = Float64[]
pd_2 = Float64[]
pd_3 = Float64[]
ps_1 = Float64[]
ps_2 = Float64[]
ps_3 = Float64[]
se = Float64[]

nw_keys = sort(collect(keys(mn_case["nw"])), by=x->parse(Int, x))
for n in nw_keys
    network = mn_case["nw"][n]
    nid = parse(Int, n)

    hour = trunc(Int, (nid-1)/4)
    minute = 15*((nid-1)%4)

    push!(nids, nid)
    push!(time_str, "$(hour):$(minute):00")
    pg_1_total = sum(gen["pg"][1] for (i,gen) in network["gen"]); push!(pg_1, pg_1_total)
    pg_2_total = sum(gen["pg"][2] for (i,gen) in network["gen"]); push!(pg_2, pg_2_total)
    pg_3_total = sum(gen["pg"][3] for (i,gen) in network["gen"]); push!(pg_3, pg_3_total)
    pd_1_total = sum(load["pd"][1] for (i,load) in network["load"]); push!(pd_1, pd_1_total)
    pd_2_total = sum(load["pd"][2] for (i,load) in network["load"]); push!(pd_2, pd_2_total)
    pd_3_total = sum(load["pd"][3] for (i,load) in network["load"]); push!(pd_3, pd_3_total)
    ps_1_total = sum(storage["ps"][1] for (i,storage) in network["storage"]); push!(ps_1, ps_1_total)
    ps_2_total = sum(storage["ps"][2] for (i,storage) in network["storage"]); push!(ps_2, ps_2_total)
    ps_3_total = sum(storage["ps"][3] for (i,storage) in network["storage"]); push!(ps_3, ps_3_total)
    se_total = sum(get(storage, "se", 0.0) for (i,storage) in network["storage"]); push!(se, se_total)
end

df_cont_time = DataFrames.DataFrame(
    ids = nids,
    time = time_str,
    pg_1_total = pg_1,
    pg_2_total = pg_2,
    pg_3_total = pg_3,
    pd_1_total = pd_1,
    pd_2_total = pd_2,
    pd_3_total = pd_3,
    ps_1_total = ps_1,
    ps_2_total = ps_2,
    ps_3_total = ps_3,
    se_total = se
)
CSV.write("ac-3p.csv", df_cont_time)

