function [x, X_, L] = logSweep(f1, f2, fs, T)
%   f1 = start frequency
%   f2 = end frequency
%   fs = sample rate
%   T = length in secconds

    L = round(f1/log(f2/f1)*T)/f1;
    T = L*log(f2/f1);
    t = (0:ceil(fs*T)-1)./fs;
    x = 0.6*sin(2*pi*f1*L*(exp(t/L))).';
    
    % fade-in the input signal
    fd1 = 4800;  % number of samlpes
    fade_in = (1-cos((0:fd1-1)/fd1*pi))/2;
    index = 1:fd1;
    x(index) = x(index).*fade_in.';
    
    % fade-out the input signal
    fd2 =  4800;  % number of samlpes
    fade_out = (1-cos((0:fd2-1)/fd2*pi))/2;
    index = (1:fd2)-1;
    x(end-index) = x(end-index).*fade_out.';
    
    len = 2^ceil(log2(length(x)));

    % frequency axis
    f_ax = linspace(0,fs,len+1).';
    f_ax = f_ax(1:end-1);

    % inverse filter in frequency domain
    X_ = 2*sqrt(f_ax/L).*exp(-j*2*pi* ...
    f_ax*L.*(1-log(f_ax/f1)) + j*pi/4);

    X_ = 0.6*X_;

end