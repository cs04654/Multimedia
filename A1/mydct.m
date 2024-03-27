function F = mydct(f)
    N = length(f);
    F = zeros(1, N);
    
    for u = 0:N-1
        w = sqrt(2/N);
        if u == 0
            w = 1 / sqrt(N);
        end
        
        sum_val = 0;
        for x = 0:N-1
            sum_val = sum_val + f(x + 1) * cos((2 * x + 1) * pi * u / (2 * N));
        end
        
        F(u + 1) = w * sum_val;
    end
end

