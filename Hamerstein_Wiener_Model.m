function outputData = Hamerstein_Wiener_Model(inputData, refrenceData, orders, fs)
%% Create system

data = iddata(refrenceData(1), inputData(1), 1/fs);
system = nlhw(data, orders, 'idSaturation', 'idSaturation');

%% Find model parameters

[num, den] = tfdata(system.LinearModel);

disp("numerator: " + string(cell2mat(num)));
disp("denominator: " + string(cell2mat(den)));

disp("input saturation interval" + string(system.InputNonlinearity.LinearInterval));
disp("output saturation interval" + string(system.OutputNonlinearity.LinearInterval));

%% Simulate system 

outputData = sim(system, inputData);

