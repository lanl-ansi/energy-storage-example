
function slice(mn_data, lookup)
    @assert PowerModels.InfrastructureModels.ismultinetwork(mn_data)
    vals = []
    nw_keys = sort(collect(keys(mn_data["nw"])), by=x->parse(Int, x))
    for n in nw_keys
        comp = mn_data["nw"][n]
        for lookup_val in lookup
            comp = comp[lookup_val]
        end
        push!(vals, comp)
    end
    return vals
end


# from RTS 96 paper
summer_wkdy_hour_scalar = [
    .64, .60, .58, .56, .56, .58, .64, .76, .87, .95, .99, 1.0, .99, 1.0, 1.0,
    .97, .96, .96, .93, .92, .92, .93, .87, .72
]

summer_wkdy_15min_scalar = Float64[]

for i in 2:length(summer_wkdy_hour_scalar)
    fr = summer_wkdy_hour_scalar[i-1]
    to = summer_wkdy_hour_scalar[i]
    delta = (to - fr)/4.0
    for j in 0:3
        push!(summer_wkdy_15min_scalar, fr+j*delta)
    end
end

fr = summer_wkdy_hour_scalar[end]
to = summer_wkdy_hour_scalar[1]
delta = (to - fr)/4.0
for j in 0:3
    push!(summer_wkdy_15min_scalar, fr+j*delta)
end

#println(summer_wkdy_hour_scalar)
#println(summer_wkdy_15min_scalar)
#println(length(summer_wkdy_15min_scalar))

"a toy example of how to model with multi-networks and storage"
function run_mn_opf_strg_nl(file, model_type::Type, optimizer; kwargs...)
    return run_model(file, model_type, optimizer, build_mn_opf_strg_nl; multinetwork=true, kwargs...)
end

""
function build_mn_opf_strg_nl(pm::AbstractPowerModel)
    for (n, network) in nws(pm)
        variable_bus_voltage(pm, nw=n)
        variable_gen_power(pm, nw=n)
        variable_storage_power(pm, nw=n)
        variable_branch_power(pm, nw=n)
        variable_dcline_power(pm, nw=n)

        constraint_model_voltage(pm, nw=n)

        for i in ids(pm, :ref_buses, nw=n)
            constraint_theta_ref(pm, i, nw=n)
        end

        for i in ids(pm, :bus, nw=n)
            constraint_power_balance(pm, i, nw=n)
        end

        for i in ids(pm, :storage, nw=n)
            constraint_storage_complementarity_nl(pm, i, nw=n)
            constraint_storage_losses(pm, i, nw=n)
            constraint_storage_thermal_limit(pm, i, nw=n)
        end

        for i in ids(pm, :branch, nw=n)
            constraint_ohms_yt_from(pm, i, nw=n)
            constraint_ohms_yt_to(pm, i, nw=n)

            constraint_voltage_angle_difference(pm, i, nw=n)

            constraint_thermal_limit_from(pm, i, nw=n)
            constraint_thermal_limit_to(pm, i, nw=n)
        end

        for i in ids(pm, :dcline, nw=n)
            constraint_dcline(pm, i, nw=n)
        end
    end

    network_ids = sort(collect(nw_ids(pm)))

    n_1 = network_ids[1]
    for i in ids(pm, :storage, nw=n_1)
        constraint_storage_state(pm, i, nw=n_1)
    end

    for n_2 in network_ids[2:end]
        for i in ids(pm, :storage, nw=n_2)
            constraint_storage_state(pm, i, n_1, n_2)
        end
        n_1 = n_2
    end

    objective_min_fuel_and_flow_cost(pm)
end
