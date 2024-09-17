fs = 48000;

input = audioread("input/guitar.wav");
refrence = audioread("refrence/guitar_rotary.wav");

input2 = audioread("input/guitar2.wav");

%% Create nonlinear system

model = nlhw(iddata(refrence, input, 1/fs), [3 1 1]);

%% Simulate

output2 = sim(model, input2);

audiowrite("output/guitar2_rotary.wav", output2, fs);