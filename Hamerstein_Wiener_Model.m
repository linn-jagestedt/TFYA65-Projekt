function outputData = HamersteinWienerModel(inputData, refrenceData, orders, inputNonlinearlity, ouputNonlinearlity, fs)
%% Create system

data = iddata(refrenceData(1), inputData(1), 1/fs);
system = nlhw(data, orders, inputNonlinearlity, ouputNonlinearlity);

%% Find model parameters

[num, den] = tfdata(system.LinearModel);

num = cell2mat(num);
den = cell2mat(den);

%% Simulate system
if isa(system.inputNonlinearity, 'idSaturation') && ...
   isa(system.outputNonlinearity, 'idSaturation')    
    for i = 1:length(inputData)
        output = hwimplementation( ...
            cell2mat(inputData(i)), ...
            system.InputNonlinearity, ...
            num, ...
            den, ...
            system.OutputNonlinearity ...
        );
    
        outputData(i) = {output};
    end
else
    outputData = sim(system, inputData);
end

