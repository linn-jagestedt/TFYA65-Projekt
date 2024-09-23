fs = 48000;

%% Read data

inputData(1) = {audioread("input/guitar.wav")};
refrenceData(1) = {audioread("refrence/guitar_dist.wav")};

inputData(2) = {audioread("input/guitar2.wav")};
refrenceData(2) = {audioread("refrence/guitar2_dist.wav")};

inputData(3) = {audioread("input/sweep.wav")};
refrenceData(3) = {audioread("refrence/sweep_dist.wav")};

%% Find prameters and simulate system

outputData = Hamerstein_Wiener_Model(inputData, refrenceData, [3 1 1], fs);

%% Write output

audiowrite("output/HW_guitar_dist.wav", cell2mat(outputData(1)), fs);
audiowrite("output/HW_guitar2_dist.wav", cell2mat(outputData(2)), fs);
audiowrite("output/HW_sweep_dist.wav", cell2mat(outputData(3)), fs);

%% Find the error of the fourier transform

for i = 1:3 
    REF = fft(cell2mat(refrenceData(i)));
    OUT = fft(cell2mat(outputData(i)));    
    t = (fs/2)/length(REF)*(0:length(REF)-1);
    subplot(3,1,i); plot(t, abs(REF - OUT)); 
    ylabel("error"); xlabel("frequency"); title("Signal " + i + " Error");
end