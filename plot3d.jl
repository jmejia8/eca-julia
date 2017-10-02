using Plots
pyplot(size=(850, 400))

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



function main()

    x = linspace(-100, 100, 100)
    y = linspace(-100, 100, 100)

    for func_num = 21:30
        println("f = $func_num")
        f(x, y) = begin
            # func_num = i
            v = [0.0, 0.0] 
            testFunc([x, y], v, func_num)
            return v[1]
        end

        p1 = plot(x, y, f, st = [:surface], color=:red)
        p2 = plot(x, y, f, st = [:contourf], color=:red)

        plot(p1, p2, layout=(1, 2))
        savefig("f$func_num.pdf")
    end

end

main()