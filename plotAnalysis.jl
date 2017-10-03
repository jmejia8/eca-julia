using Plots
gr(leg = false, size = (500, 500))

include("diversityMeasures.jl")

function plotPopulation(population)
    limits = (-100, 100)
    # ferror = abs.(fitness - f_real)
    p = plot(population[:,1], population[:,2], seriestype=:scatter, xlims=limits, ylims=limits)

    return p
end