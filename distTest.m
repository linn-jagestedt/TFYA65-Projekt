fs = 48000;

inputData(1) = {audioread("input/guitar.wav")};
refrenceData(1) = {audioread("refrence/guitar_dist.wav")};

inputData(2) = {audioread("input/guitar2.wav")};
refrenceData(2) = {audioread("refrence/guitar2_dist.wav")};

inputData(3) = {audioread("input/sweep.wav")};
refrenceData(3) = {audioread("refrence/sweep_dist.wav")};

outputData = Hamerstein_Wiener_Model(inputData, refrenceData, [3 1 1], 'idSaturation', 'idSaturation', fs);

audiowrite("output/HW_guitar_dist.wav", cell2mat(outputData(1)), fs);
audiowrite("output/HW_guitar2_dist.wav", cell2mat(outputData(2)), fs);
audiowrite("output/HW_sweep_dist.wav", cell2mat(outputData(3)), fs);

error = zeros(3,1);

for i = 1:3 
    error(i) = mean(abs(cell2mat(refrenceData(i)) - cell2mat(outputData(i))));
end

plot(error); ylabel("error"); xlabel("inputData index"); title("Error by input");