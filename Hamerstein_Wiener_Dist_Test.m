fs = 44100;

filterName = 'Audacity_dist';
fileName = "keys2";

%% Read  training data
    
train_input = audioread("input/log_sweep.wav");
train_refrence = audioread("refrence/" + filterName +"/log_sweep.wav");

train_refrence = removeTimeShift(train_input, train_refrence);
train_refrence = train_refrence(1:length(train_input));

%% Read test data

input = audioread("input/" + fileName +  ".wav");
refrence = audioread("refrence/" + filterName + "/" + fileName +  ".wav");

refrence = removeTimeShift(input, refrence);
refrence = refrence(1:length(input));

%% Create system

data = iddata(train_refrence, train_input, 1/fs);

opt = nlhwOptions;
opt.Regularization.Lambda = 0;
opt.SearchMethod = 'lm';

nb = 3; % number zeros in the system
nf = 1; % number poles in the system
nk = 0; % time delay in the system

system = nlhw(data, [nb nf nk], 'idSaturation', 'idSaturation', opt);

%% Get model parameters

[num, den] = tfdata(system.LinearModel);

disp("numerator: " + string(cell2mat(num)));
disp("denominator: " + string(cell2mat(den)));

disp("input saturation interval: " + string(system.InputNonlinearity.LinearInterval));
disp("output saturation interval: " + string(system.OutputNonlinearity.LinearInterval));

%% Simulate system with test data

y = sim(system, input);

y = removeTimeShift(refrence, y);
y = y / max(abs(y)) * max(abs(refrence));

%% Write output

audiowrite("output/optimization model/" + filterName + "/" + fileName +  ".wav", y, fs);

%% Calculate mean square error

error = rms(refrence - y);
disp("Root mean square error: " + error);

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