function y = hwimplementation(u, inputNonlinearity, num, den, outputNonlinearity)    
    if isa(inputNonlinearity, 'idSaturation')
        a = inputNonlinearity.LinearInterval(1);
        b = inputNonlinearity.LinearInterval(2);
        w = saturation(u, a, b);
    else 
        w = u;
    end
    
    x = transfer(w, num, den);
    
    if isa(outputNonlinearity, 'idSaturation')
        a = outputNonlinearity.LinearInterval(1);
        b = outputNonlinearity.LinearInterval(2);
        y = saturation(x, a, b);
    else 
        y = x;
    end
end
