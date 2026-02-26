%% Synchronized Swept-Sine method for analysis and identification of Nonlinear Systems
%
% The example presented in this code shows the synchronized swept-sine
% method applied on a simple non-linear system. All the steps: signal
% genartion, estimation of Higher Harmonic Frequency Responses, and
% estimation of the filters of Generalized Hammerstein model (Diagonal
% Volterra Kernels) are provided by the external functions.

% [Novak et al. (2015)] 
% A. Novak, P. Lotton & L. Simon (2015), "Synchronized Swept-Sine: Theory, 
%      Application, and Implementation", Journal of the Audio Engineering 
%      Society. Vol. 63(10), pp. 786-798.
%
% Antonin Novak (antonin.novak@univ-lemans.fr), 29/10/2018
% Laboratoire d'Acoustique de l'Université du Mans (LAUM, UMR CNRS 6613), 
% 72085 Le Mans, France
%
% https://ant-novak.com
%
%%

clc; close all; clearvars;

fs = 192000; % sampling frequency

%% -- generation of the swept-sine signal
f1 = 1e3;            % start frequency
f2 = 20e3;           % end frequency
T = 10;              % time duration

[x,t,L] = synchronized_swept_sine(f1,f2,T,fs);
% x = fadeIn_fadeOut(x,0.5,0.05,fs);

%% Nonlinear system
a_coeff = [1.0,-1.9,0.94; 1.0,-1.88,0.92; 1.0,-1.83,0.95];
b_coeff = [0.2,-0.38,0.18; 0.2,-0.38,0.18; 0.04,-0.082,0.04];
NL_system = @(x) filter(b_coeff(1,:),a_coeff(1,:),x) + filter(b_coeff(2,:),a_coeff(2,:),x.^2) + filter(b_coeff(3,:),a_coeff(3,:),x.^3);

y = NL_system(x);

%% Nonlinear (de)convolution
% Nonlinear convolution in frequency domain:
Y = fft(y)./fs;   % FFT of the output signal

% analytical expression of the spectra of the synchronized swept-sine
X = synchronized_swept_sine_spectra(f1,L,fs,length(y));

% Deconvolution
H = Y./X; H(1) = 0;  % avoid Inf at DC

h = ifft(H,'symmetric');     % impulse response

%% -- separation of higher harmonic impulse responses

len_IR = 2^12;
pre_IR = len_IR / 2;

N = 3; % number of harmonics to study
dt = L.*log(1:N).*fs;

hm = synchronized_swept_sine_IR_separation(h,dt,len_IR,pre_IR);

% -- end of the separation of higher harmonic impulse responses
%% Higher Harmonic Frequency Responses (HHFRs)
Hm = fft(hm);


%% -- plot the HHFRs
axe_w = linspace(0,2*pi,len_IR+1).'; axe_w(end) = [];

figure_line_colors = [0.0, 0.0, 1.0; 0.0, 0.5, 0.0; 1.0, 0.0, 0.0];
set(groot,'defaultAxesColorOrder',figure_line_colors);

figure;
semilogx(axe_w*fs/2/pi/1000,20*log10(abs(Hm)),'linewidth',2);
xlim([f1 N*f2]./1000); ylim([-60 0]);
set(gca,'FontSize',18,'FontName','Helvetica');
title('HHFRs','FontSize',16,'FontName','Courier New');
xlabel('Frequency [kHz]','FontSize',16,'FontName','Helvetica');
ylabel('Amplitude [dB]','FontSize',16,'FontName','Helvetica');
legend({'H_1(f)','H_2(f)','H_3(f)'});
set(gca,'XTick',[1 3 5 7 10 20 40 60]);
grid on; box on;

% -- end of plot the HHFRs
%% Estimation of filters Gm of Generalized Hammerstein model (Diagonal Volterra Kernels)
% Coefficients A of the transform between the Hm and Gm
A = powersin(N);
% tranform the HHFR Hm to filters Gm
Gm = Hm/A;

%% -- plot the filters G_m of the Generalized Hammerstein model
% calculate the theoretical FRF of the filters to compare them
G_theo = zeros(size(Hm));
for n=1:N
    G_theo(:,n) = freqz(b_coeff(n,:), a_coeff(n,:), size(Gm,1), 'whole');
end

% and compare with the estimated filters Gm with the theoretical ones
f_ax = linspace(0,fs,length(Gm)+1); f_ax(end) = [];
YLimits = ([-25 0; -25 0; -35 -5]);
for n=1:N
    figure;
    axes;
    semilogx(f_ax/1000,20*log10(abs(Gm(:,n))),'Color',figure_line_colors(n,:),'linewidth',2); hold all;
    semilogx(f_ax/1000,20*log10(abs(G_theo(:,n))),'k--','linewidth',2); hold off;
    xlim([N*f1 n*f2]./1000); ylim(YLimits(n,:))
    title(['Filter G_' num2str(n) '(f)'],'FontSize',14);
    xlabel('Frequency [kHz]','FontSize',14,'FontName','Helvetica');
    ylabel('Amplitude [dB]','FontSize',14,'FontName','Helvetica');
    legend({'estimated','theoretical'});
    set(gca,'XTick',[3 5 7 10 20 40 60]);
    grid on; box on;
    set(gca,'FontSize',14,'FontName','Helvetica');
    set(gca,'OuterPosition',[0 0 1/2 1])
    
    axes;
    semilogx(f_ax/1000,angle(Gm(:,n).*exp(-1i*axe_w*pre_IR)),'Color',figure_line_colors(n,:),'linewidth',2); hold all;
    semilogx(f_ax/1000,angle(G_theo(:,n)),'k--','linewidth',2); hold off;
    xlim([N*f1 n*f2]./1000);
    title(['Filter G_' num2str(n) '(f)'],'FontSize',14);
    xlabel('Frequency [kHz]','FontSize',14,'FontName','Helvetica');
    ylabel('Phase [rad]','FontSize',14,'FontName','Helvetica');
    legend({'estimated','theoretical'});
    set(gca,'XTick',[3 5 7 10 20 40 60]);    
    grid on; box on;
    set(gca,'FontSize',14,'FontName','Helvetica');
    set(gca,'OuterPosition',[1/2 0 1/2 1])
    
end





