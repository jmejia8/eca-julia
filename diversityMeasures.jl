function DALL(x)
    n = size(x, 1)
    s = 0.0
    for i=1:n-1
        for j = i:n
             s += norm(x[i,:] - x[j,:])
        end
    end

    return (2 / (n*(n-1)))*s 
end