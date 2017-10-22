using Plots
gr(leg = false, size = (500, 500))

include("diversityMeasures.jl")

function plotPopulation(population, t)
    limits = (-100, 100)
    # ferror = abs.(fitness - f_real)
    p = plot!(  population[:,1], # x
                population[:,2], # y
                seriestype=:scatter,
                xlims = limits,
                ylims = limits,
                title = "Generation $t")

    return p
end