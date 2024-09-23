function outputData = Transfer_Function_Model(inputData, refrenceData, np, nz, delay, fs)
%% Create system

data = iddata(refrenceData, inputData, 1/fs);
system = tfest(data, np, nz, delay);

%% Find model parameters

[num, den] = tfdata(system.LinearModel);

disp("numerator: " + string(cell2mat(num)));
disp("denominator: " + string(cell2mat(den)));

%% Simulate system 

outputData = sim(system, inputData);

