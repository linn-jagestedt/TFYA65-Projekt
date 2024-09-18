function y = transfer(x, num, den)
    y = zeros(length(x), 1);
    
    for t = 1:length(x)
        for i = 1:length(num)
            if 0 < t - i 
                y(t) = y(t) + num(i)*x(t-(i-1));
            end
        end
        

        for i = 2:length(den)
            if 0 < t - i 
                y(t) = y(t) - den(i)*y(t-(i-1));
            end
            y(t) = y(t) / den(1);
        end
    end
end