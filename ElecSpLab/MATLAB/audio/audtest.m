clc;
clear all;
close all;

% initialize objects
snd = sbAudioIO(8000);
fig = figure;
h = lpf3k();

snd.Start();
while(ishandle(fig))
    x = snd.GetInp();
    snd.SetOut(x);
    subplot(2, 1, 1);
    plot(x(:, 1));
    ylim([-1 1]);
    title('Input Signal');
    subplot(2, 1, 2);
    plot(x(:, 2));
    ylim([-1 1]);
    title('Input Signal');
    drawnow;
end
snd.Stop();
