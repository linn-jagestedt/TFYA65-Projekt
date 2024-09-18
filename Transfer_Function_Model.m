function outputData = Transfer_Function_Model(inputData, refrenceData, np, nz, delay, fs)
%% Create system

data = iddata(refrenceData, inputData, 1/fs);
system = tfest(data, np, nz, delay);

%% Find model parameters

[num, den] = tfdata(system);

num = cell2mat(num);
den = cell2mat(den);

outputData = sim(system, inputData);

for i = 1:length(inputData)
    %output = transfer( ...
    %    cell2mat(inputData(i)), ...
    %    num, ...
    %    den ...
    %);
end

