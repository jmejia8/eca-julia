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
    D = 100
    K = 7
    limits = (-100.0, 100.0)
    η_max  = 2
    N  = K * div(D, 2)  # K * D
    
    max_iter = div( 1 + 10000D, N)

    approx = eca(testFunc, D, N, max_iter,  K, η_max, limits, func_num)

    ff = [0.0]
    testFunc(approx, ff, func_num)
    # println("x = $approx \n\n")
    @printf "Error: %e \n=============================\n\n" ( ff[1] - func_num*100)
    # println("f = ", ff[1])
end

function main()
    func_num = 1
    for i = 1:30
        println("run $i")
        runn(i)
    end
end


main()