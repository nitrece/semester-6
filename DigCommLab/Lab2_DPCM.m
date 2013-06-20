clc;
clear all;
close all;

% Initialize parameters
Fs = 20*10^3;
tStart = 0;
tStep = 0.01;
tStop = tStart + tStep;
fig = figure;

while(ishandle(fig))
    
    % Get the message signal
    [x, tx] = sig_lab2(Fs, tStart, tStop, [0.2 0.3]);
    subplot(2, 1, 1);
    plot(tx, x);
    xlim([tStart, tStop]);
    ylim([-4 4]);
    title('Input signal x(t)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Get the autoregretted signal of input
    [y, ty] = sig_autoregressionfilter(x, Fs, tStart, [0.2 0.3]);
    subplot(2, 1, 2);
    plot(ty, y);
    xlim([tStart tStop]);
    ylim([-4 4]);
    title('Autoregretted signal y(t)');
    
    % Update time
    tStart = tStart + tStep;
    tStop = tStop + tStep;
    drawnow;
end