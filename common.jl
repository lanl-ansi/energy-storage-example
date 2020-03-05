
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

