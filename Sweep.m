 %% Generate Chrip

fs = 48000;
fmax = 20000;
fmin = 20;
T = 10;
t = 1/fs:1/fs:T;

sweep = 0.5 * chirp(t, fmin, T, fmax, "linear");
audiowrite("sweep.wav",sweep, fs);

%% Calculate impulse

sweep_inv = fliplr(sweep);
sweep_inv = sweep_inv .* tukeywin(length(sweep_inv), 0.2)';

sweep_dist = audioread("sweep_dist.wav");
sweep_reverb = audioread("sweep_reverb.wav");

plot(sweep_inv);

h_dist = ifft(fft(sweep_dist) .* fft(sweep_inv'));
h_dist = h_dist(1:length(h_dist) / 2);
h_dist = h_dist / max(abs(h_dist));

h_reverb = ifft(fft(sweep_reverb) .* fft(sweep_inv'));
h_reverb = h_reverb(1:length(h_reverb) / 2);
h_reverb = h_reverb / max(abs(h_reverb));

audiowrite("impulse_dist.wav",h_dist, fs);
audiowrite("impulse_reverb.wav",h_reverb, fs);

%subplot(2,1,1);
%plot(h_dist); title("dist impulse");
%subplot(2,1,2);
%plot(h_reverb); title("reverb impulse");

%% Convolve Impulse with test data

guitar = audioread("guitar.wav");

guitar_dist = conv(guitar, h_dist, "full");
guitar_dist = rescale(guitar_dist, -1, 1);

guitar_reverb = conv(guitar, h_reverb, "full");
guitar_reverb  = rescale(guitar_reverb, -1, 1);

audiowrite("guitar_dist.wav",guitar_dist, fs);
audiowrite("guitar_reverb.wav",guitar_reverb, fs);
