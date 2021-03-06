include("eca.jl")

function testFunc(x, f, func_num)
    lib = "./cfunctions.so"

    N, D = size(x, 1, 2)

    if D == 1
        D = N
        N = 1
        xx = x
    else
        xx = collect(Cdouble, vec(x'))
    end

    ccall((:func, lib), Void, (Ptr{Cdouble},
                               Ptr{Cdouble},
                               Int32, Int32, Int32),
                               xx,
                               f, D, N, func_num)
end

function runn(func_num)
    D = 2
    K = 7
    limits = (-100.0, 100.0)
    η_max  = 2
    N  = K * 10# D
    
    max_evals = 10000D

    approx = eca(testFunc, D, N, max_evals,  K, η_max, limits, func_num)

    ff = [0.0]
    testFunc(approx, ff, func_num)
    # println("x = $approx \n\n")
    @printf "Error: %e \n=============================\n\n" ( ff[1] - func_num*100)
    # println("f = ", ff[1])
end

function main()
    func_num = 3
    for i = 21:28
        println("run $i")
        runn(i)
    end
end


main()