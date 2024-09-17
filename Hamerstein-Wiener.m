fs = 48000;

input = audioread("input/guitar.wav");
refrence = audioread("refrence/guitar_dist.wav");

input2 = audioread("input/guitar2.wav");

%% Create nonlinear system

model = nlhw(iddata(refrence, input, 1/fs), [3 1 1]);

%% Simulate

output2 = sim(model, input2);

audiowrite("output/guitar2_dist.wav", output2, fs);