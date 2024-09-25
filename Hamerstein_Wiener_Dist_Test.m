%% Read data

input(1) = {audioread("input/sweep.wav")};
refrence(1) = {audioread("refrence/sweep_dist.wav")};

input(2) = {audioread("input/keys1.wav")};
refrence(2) = {audioread("refrence/keys1_dist.wav")};

input(3) = {audioread("input/keys2.wav")};
refrence(3) = {audioread("refrence/keys2_dist.wav")};

input(4) = {audioread("input/guitar1.wav")};
refrence(4) = {audioread("refrence/guitar1_dist.wav")};

input(5) = {audioread("input/guitar2.wav")};
refrence(5) = {audioread("refrence/guitar2_dist.wav")};

input(6) = {audioread("input/guitar3.wav")};
refrence(6) = {audioread("refrence/guitar3_dist.wav")};

input(7) = {audioread("input/guitar4.wav")};
refrence(7) = {audioread("refrence/guitar4_dist.wav")};

%% Create system

fs = 44100;

% signals 1 - 6 is the training data, 7 is the test data
data = iddata(refrence(1:6), input(1:6), 1/fs);

opt = nlhwOptions;
opt.Regularization.Lambda = 0.1;

np = 4; % number zeros in the system
nz = 1; % number polys in the system
T = NaN; % time delay in the system

system = nlhw(data, [np nz T], 'idSaturation', 'idSaturation', opt);

%% Get model parameters

[num, den] = tfdata(system.LinearModel);

disp("numerator: " + string(cell2mat(num)));
disp("denominator: " + string(cell2mat(den)));

disp("input saturation interval: " + string(system.InputNonlinearity.LinearInterval));
disp("output saturation interval: " + string(system.OutputNonlinearity.LinearInterval));

%% Simulate system 

output = sim(system, input);

%% Write output

audiowrite("output/HW_sweep_dist.wav", cell2mat(output(1)), fs);
audiowrite("output/HW_guitar1_dist.wav", cell2mat(output(2)), fs);
audiowrite("output/HW_guitar2_dist.wav", cell2mat(output(3)), fs);
audiowrite("output/HW_guitar3_dist.wav", cell2mat(output(4)), fs);
audiowrite("output/HW_guitar4_dist.wav", cell2mat(output(5)), fs);
audiowrite("output/HW_keys1_dist.wav", cell2mat(output(6)), fs);
audiowrite("output/HW_keys2_dist.wav", cell2mat(output(7)), fs);

%% Plot signals in time-domain

n = length(cell2mat(input(7)));

t = linspace(0, n * 1/fs, n);

figure;

subplot(4,1,1); plot(t, cell2mat(input(7))); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Signal " + 7 + " Input");
axis([0 1/fs*n -1 1]);

subplot(4,1,2); plot(t, cell2mat(refrence(7))); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Signal " + 7 + " Refrence");
axis([0 1/fs*n -1 1]);

subplot(4,1,3); plot(t, cell2mat(output(7))); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Signal " + 7 + " Output");
axis([0 1/fs*n -1 1]);

subplot(4,1,4); plot(t, cell2mat(refrence(7)) - cell2mat(output(7))); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Signal " + 7 + " Diffrence");
axis([0 1/fs*n -1 1]);

%% Calculate mean square error

rms()