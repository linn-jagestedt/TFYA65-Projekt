function y = fadeIn_fadeOut(x,T1,T2,fs)
% FADEIN_FADEOUT with raised cosine.
% Add a rasied cosine at the beginning and at the end of the signal.
%
% Syntax:  y = fadeIn_fadeOut(x,fdIn,fdOut)
%
% Inputs:
%    x  - input signal (column vector)
%    T1 - fade-in length [seconds]
%    T2 - fade-out length [seconds]
%    fs - sampling frequency
%
% Outputs:
%    y - output signal (column vector)
%

% Author: Antonin NOVAK
% Laboratoire d'Acoustique de l'Universite du Mans (LAUM) - UMR CNRS n.6613
% email address: antonin.novak@univ-lemans.fr  
% Website: https://ant-novak.com
% July 2016; Last revision: 29-Oct-2018

%------------- BEGIN CODE --------------

y = x;

% fade-in the signal 
fdIn = round(T1*fs);
fade_in = (1-cos((0:fdIn-1)'/fdIn*pi))/2;
index = 1:fdIn;
y(index) = y(index).*fade_in;

% fade-out the signal
fdOut = round(T2*fs);
fade_out = (1-cos((0:fdOut-1)'/fdOut*pi))/2;
index = (1:fdOut)-1;
y(end-index) = y(end-index).*fade_out;

%------------- END OF CODE -------------
