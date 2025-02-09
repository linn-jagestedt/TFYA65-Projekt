%% Read  training data

filterName = 'OD300_2';
    
input(1) = {audioread("input/sweep.wav")};
refrence(1) = {audioread("refrence/" + filterName +"/sweep.wav")};

input(2) = {audioread("input/keys1.wav")};
refrence(2) = {audioread("refrence/" + filterName +"/keys1.wav")};

input(3) = {audioread("input/keys2.wav")};
refrence(3) = {audioread("refrence/" + filterName +"/keys2.wav")};

input(4) = {audioread("input/guitar1.wav")};
refrence(4) = {audioread("refrence/" + filterName +"/guitar1.wav")};

input(5) = {audioread("input/guitar2.wav")};
refrence(5) = {audioread("refrence/" + filterName +"/guitar2.wav")};

input(6) = {audioread("input/guitar3.wav")};
refrence(6) = {audioread("refrence/" + filterName +"/guitar3.wav")};

%% Create system

fs = 44100;

data = iddata(refrence, input, 1/fs);

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

%% Read test data

testInput = audioread("input/guitar4.wav");
testRefrence = audioread("refrence/" + filterName + "/guitar4.wav");

%% Simulate system with test data

testOutput = sim(system, testInput);

%% Write output

audiowrite("output/" + filterName + "/guitar4.wav", testOutput, fs);

%% Calculate mean square error

% Vi använder detta för att kolla kvalitén av vår output! Mindre är bättre!
error = rms(testRefrence - testOutput);
disp("Root mean square error: " + error);

%% Plot signals in time-domain

n = length(testInput);
t = linspace(0, n * 1/fs, n);

% Input signal
subplot(3,1,1); plot(t, testInput); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Signal Input");
axis([0 1/fs*n -1 1]);

% Reference signal
subplot(3,1,2); plot(t, testRefrence); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Refrence Signal");
axis([0 1/fs*n -1 1]);

% Output signal
subplot(3,1,3); plot(t, testOutput); 
ylabel("Amplitude"); xlabel("Time (s)"); title("Output Signal");
axis([0 1/fs*n -1 1]);