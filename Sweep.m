sweep = audioread("input/sweep.wav");
sweep_reverb = audioread("refrence/sweep_reverb.wav");

%% Calculate impulse

sweep_inv = flip(sweep);
sweep_inv = sweep_inv .* tukeywin(length(sweep_inv), 0.2);

h = ifft(fft(sweep_reverb) .* fft(sweep_inv));
h = h(1:length(h) / 2);

audiowrite("output/impulse.wav",h, fs);

%% Convolve Impulse with test data

guitar = audioread("input/guitar.wav");

Y = fft(h, length(guitar)) .* fft(guitar);

guitar_reverb = real(ifft(Y));
guitar_reverb  = rescale(guitar_reverb, -1, 1);

audiowrite("output/guitar_reverb.wav",guitar_reverb, fs);
