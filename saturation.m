function y = saturation(x, a, b) 
    y = zeros(length(x), 1);

    parfor i = 1:length(x)
        if a <= x(i) && x(i) < b
            y(i) = x(i);
        elseif x(i) < a
            y(i) = a;
        else
            y(i) = b;
        end
    end
end