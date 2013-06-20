function [x, t] = sig_lab1(F, Fs, SNR, tStart, tStop)

% Generate sample time points
Ts = 1 / Fs;
t = tStart : Ts : tStop;

% Generate the required discrete-time signal
% x = awgn(sin(2*pi*F*t) + sin(4*pi*F*t) + sin(8*pi*F*t), SNR);
x = wgn(1, length(t), 0.01);
end