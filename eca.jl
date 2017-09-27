function center(neigbors, fitness)
    n, d = size(neigbors, 1, 2)
    c = zeros(Float64, d)

    # expermiental
    # h(x, m = minimum(x), M = maximum(x)) = (x - m) / (M - m)
    # fitness = log.(h(1+fitness))

    fitness = 1.1maximum(fitness) - fitness


    for i = 1:n
        c += neigbors[i,:] * fitness[i]
    end

    return c / sum(fitness)
end

function replaceWrost!(population, fitness, H, f_H)
    f_wrost = sort(fitness, rev=true)

    l = 1
    for val in f_wrost[1:length(f_H)]
        j = find(x -> x == val, fitness)
        j = j[1]
        if fitness[j] < f_H[l]
            continue
        end
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

function eca(func, D, N, max_iter = 70, K = 7, η_max = 2.0, limits = (-100., 100.), func_num = 1)
    a, b = limits
    f_real = 100 * func_num

    population = a + (b - a) * rand(N, D)
    fitness = zeros(N)
    func(population, fitness, func_num)

    # population, fitness
    N, D = size(population, 1, 2)
    qq = linspace(a,b, 50)

    tt = 0
    for t = 1:max_iter
        best = minimum(fitness)
       
        if abs(f_real -best) < 1e-9
            break
        end

        H   = []
        f_H = Float64.([])
        
        for i in 1:N
            x = population[i, :]
            η = η_max * rand()
            
            popSample = rand(1:N, K)
            subpopulation = population[popSample, :]
            c = center(subpopulation, fitness[popSample])
            r = population[rand(popSample, 1)[1], :]

            h = x + η * (c - r)
            h = correct(h, limits)

            for k in 1:D
                if rand() < 0.1
                    h[k] = x[k]
                end
            end

            f_h = [0.0]
            func(h, f_h, func_num)
            f_h = f_h[1]

            if f_h < fitness[i]
                push!(H,   h)
                push!(f_H, f_h) 
            end
        end

        tt = t
        # println("hijos = ", length(H))
        replaceWrost!(population, fitness, H, f_H)
    end

    println("=============================")
    println("| Generations = $tt")
    println("| Evals       = ", N*tt)
    println("=============================")
    f_best = minimum(fitness)
    return population[find(x->x == f_best, fitness)[1], :]
end