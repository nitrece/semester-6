function [x, t] = sig_lab2(Fs, tStart, tStop, h)

% Get required number of time steps
n = 1 + floor((tStop - tStart) * Fs);

% Get the message signal
x = randn(1, n);
% Get the autoregretted signal of input
[x, t] = sig_autoregressionfilter(x, Fs, tStart, h);
end