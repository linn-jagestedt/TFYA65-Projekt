fs = 48000;

inputData(1) = {audioread("input/guitar.wav")};
refrenceData(1) = {audioread("refrence/guitar_reverb.wav")};

inputData(2) = {audioread("input/guitar2.wav")};
refrenceData(2) = {audioread("refrence/guitar2_reverb.wav")};

inputData(3) = {audioread("input/sweep.wav")};
refrenceData(3) = {audioread("refrence/sweep_reverb.wav")};

[outputData, h] = Sweep_Model(cell2mat(inputData(3)), cell2mat(refrenceData(3)), inputData);

audiowrite("output/Sweep_guitar_reverb.wav", cell2mat(outputData(1)), fs);
audiowrite("output/Sweep_guitar2_reverb.wav", cell2mat(outputData(2)), fs);
audiowrite("output/Sweep_sweep_reverb.wav", cell2mat(outputData(3)), fs);

error = zeros(2,1);

for i = 1:3 
    error(1) = error(1) + mean(abs(cell2mat(refrenceData(i)) - cell2mat(outputData(i))));
end

plot(error); ylabel("error"); xlabel("input index"); title("Error by input");

outputData = Transfer_Function_Model(inputData, refrenceData, 6, 4, NaN, fs);

audiowrite("output/Transfer_Function_guitar_reverb.wav", cell2mat(outputData(1)), fs);
audiowrite("output/Transfer_Function_guitar2_reverb.wav", cell2mat(outputData(2)), fs);
audiowrite("output/Transfer_Function_sweep_reverb.wav", cell2mat(outputData(3)), fs);

for i = 1:3 
    error(2) = error(2) + mean(abs(cell2mat(refrenceData(i)) - cell2mat(outputData(i))));
end

bar(error);