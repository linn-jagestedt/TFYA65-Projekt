f1 = 5;      % initial frequency
f2 = 20000;    % final frequency
fs = 44100;  % sampling frequency
T = 10;      % time duration
N = 32;

filter_name = "OD300_2";
test_file = "guitar4";

%% Generate Sweep

[sweep,t,L] = synchronized_swept_sine(f1, f2, T, fs);
sweep = fadeIn_fadeOut(sweep,0.5,0.05,fs);

audiowrite("input/log_sweep.wav", sweep, fs, "BitsPerSample", 32);

%% Read filtered Sweep

filtered_sweep = audioread("refrence/" + filter_name + "/log_sweep.wav");
filtered_sweep = removeTimeShift(sweep, filtered_sweep);
filtered_sweep = filtered_sweep(1:length(sweep));

%% Calculate Harmonic Impulse

[inv_sweep_fft, f] = synchronized_swept_sine_spectra(f1, L, fs, length(filtered_sweep));

filtered_sweep_fft = fft(filtered_sweep) ./ fs;
H = filtered_sweep_fft./inv_sweep_fft; H(1) = 0;  % avoid Inf at DC
h = ifft(H,'symmetric');

len_IR = 2^12;
pre_IR = len_IR / 2;

dt = L.*log(1:N).*fs;

hm = synchronized_swept_sine_IR_separation(h,dt,len_IR,pre_IR,fs);
Hm = fft(hm);

plot(abs(hm));

%% Read test data

input = audioread("input/" + test_file + ".wav");
refrence = audioread("refrence/" + filter_name + "/" + test_file + ".wav");

refrence = removeTimeShift(input, refrence);
refrence = refrence(1:length(input));

%% Apply Impulse to input

A = powersin(N);
Gm = Hm/A;

Nfft = 2^(ceil(log2(length(input)+length(Gm)-1)));

Gm = fft(ifft(Gm), Nfft);
X = fft(input.^(1:N), Nfft);

y = real(ifft(X .* Gm));
plot(y);
y = sum(y, 2);

y = removeTimeShift(refrence, y);
y = y(1:length(input));
y = y / max(abs(y)) * max(abs(refrence));

%% Write output

audiowrite("output/sweep model/" + filter_name + "/" + test_file + ".wav", y, fs);

%% Calculate mean square error

error = rms(refrence - y);
disp("error = " + error);

%% Plot signals in time-domain

close all;
figure();

n = length(input);
t = linspace(0, n * 1/fs, n);

subplot(2,2,1); plot(t, input);
ylabel("Amplitude"); xlabel("Time (s)"); title("Input Signal");
axis([0 1/fs*n -1 1]);

subplot(2,2,2); plot(t, refrence);
ylabel("Amplitude"); xlabel("Time (s)"); title("Refrence Signal");
axis([0 1/fs*n -1 1]);

subplot(2,2,3); plot(t, y);
ylabel("Amplitude"); xlabel("Time (s)"); title("Output Signal");
axis([0 1/fs*n -1 1]);

subplot(2,2,4); plot(t, y - refrence);
ylabel("Amplitude"); xlabel("Time (s)"); title("Diffrence");
axis([0 1/fs*n -1 1]);