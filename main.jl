# using Plots
# gr(leg = false, size = (500, 500))

function center(neigbors, fitness)
    n, d = size(neigbors, 1, 2)
    c = zeros(Float64, d)

    fitness = 1.1maximum(fitness) - fitness

    for i = 1:n
        c += neigbors[i,:] * fitness[i]
    end

    return c / sum(fitness)
end

function evaluate(func, population)
    f = Float64.([])
    for i in 1:size(population, 1)
        push!(f, func(population[i, :]))
    end

    return f
end

function replaceWrost!(population, fitness, H, f_H)
    f_wrost = sort(fitness, rev=true)

    l = 1
    for val in f_wrost[1:length(f_H)]
        j = find(x -> x == val, fitness)
        j = j[1]
        population[j,:] = H[l]
        fitness[j] = f_H[l]
        l += 1
    end 
end

function correct(h, limits)
    a, b = limits
    # l = b - a
    return map(x-> begin 
                while(abs(x) > b)
                    x /= 2.0
                end
                return x
            end , h)
end

# function replaceWrost!(population, fitness, H, f_H)
# end

function eca(func, D, N, max_iter = 500, K = 7, η_max = 2.0, limits = (-100., 100.))
    a, b = limits

    population = a + (b - a) * rand(N, D)
    fitness    = evaluate(func, population)

    # population, fitness
    N, D = size(population, 1, 2)
    qq = linspace(a,b, 50)

    anim = @animate for t = 1:max_iter
        best = minimum(fitness)
       
        f(p, l) = func([p, l])
        plot(qq , qq, f, st = [:contourf], xlims=limits, ylims=limits, title="Generation: $t")
        # plot!(population[:,1], population[:,2], seriestype=:scatter, xlims=limits, ylims=limits)
       
        if abs(best) < 1e-9
            break
        end

        # print("gen: $t \t  best = $best \t")
        H   = []
        f_H = Float64.([])
        
        for i in 1:N
            x = population[i, :]
            η = η_max * rand()
            
            popSample = rand(1:N, K)
            subpopulation = population[popSample, :]
            c = center(subpopulation, fitness[popSample])
            r = population[rand(popSample, 1)[1], :]



            h   = x +  η * (c - r)
            h = correct(h, limits)

            # if i == 1
            #     plot!(subpopulation[:, 1], subpopulation[:, 2], seriestype=:scatter, color=:blue)
            #     plot!([x[1]], [x[2]], seriestype=:scatter, color=:green)
            #     plot!([c[1]], [c[2]], seriestype=:scatter, color=:red)
            #     # plot!([c[1], r[1]], [c[2], r[2]], color=:green)
            # end
            plot!([h[1]], [h[2]], seriestype=:scatter, color=:red)

            f_h = func(h)

            if f_h < fitness[i]
                push!(H,   h)
                push!(f_H, f_h) 
                # plot!([h[1]], [h[2]], seriestype=:scatter, color=:blue)
            else
                # plot!([h[1]], [h[2]], seriestype=:scatter, color=:blue)
            end
        end


        # println("hijos = ", length(H))
        replaceWrost!(population, fitness, H, f_H)
    end every 1

     gif(anim, "tmp.gif", fps = 10)

    f_best = minimum(fitness)
    return population[find(x->x == f_best, fitness)[1], :]
end

function f2(x)
    s = 0.0;
    for i in 1:length(x)
        s += abs(x[i])^(i+1)
    end
    return s
end

function f3(z)
    g(x,y) = 0.5 + (sin(sqrt(x^2 + y^2))^2 - 0.5 ) / (1 + 0.001(x^2 + y^2))^2

    s = 0.0
    d = length(z)
    for i = 1
        s += g(z[i], z[1+(i+1) % d])
    end
    return s
end


function main()
    D = 2
    K = 7
    limits = (-5.0, 5.0)
    η_max = 2.0
    max_iter = 500
    

    N   = 10K * D
    a,b = limits
    sol = a + (b - a) * rand(D)
    # f(x) = sum(x.^2)
    # f(x) = f2(x)
    f(x) = sum(x.^2 - 10cos.(2.0π*x)) + 10D
    # f(x) = 1-prod(cos.(x))*exp(-sum((x - π).^2))
    # f(x) = abs.( prod(sin.(x).*cos.(x)) * exp( -abs(1.0 - π \ sqrt( sum(x.^2) )) ) )
    g(x) = f(x - sol)



    approx = eca(g, D, N, max_iter,  K, η_max, limits)

    println("Real: ", g(sol))
    println(sol, "\n")
    println("aprx: ", g(approx))
    println(approx)
    
end