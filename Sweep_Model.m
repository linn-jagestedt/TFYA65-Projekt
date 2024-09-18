function [outputData, h] = SweepModel(sweep, sweep_ouput, inputData)
    %% Calculate impulse
    
    sweep_inv = flip(sweep);
    sweep_inv = sweep_inv .* tukeywin(length(sweep_inv), 0.2);
    
    h = ifft(fft(sweep_ouput) .* fft(sweep_inv));
    h = h(1:length(h) / 2);
        
    %% Convolve Impulse with test data
    
    for i = 1:length(inputData)        
        X = fft(cell2mat(inputData(i)));
        H = fft(h, length(X));
        Y = H .* X;
        
        output = real(ifft(Y));
        output = rescale(output, -1, 1);
        outputData(i) = {output};
    end
end