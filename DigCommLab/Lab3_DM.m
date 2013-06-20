clc;
clear all;
close all;

% Simulation settings
tStart = 0;
tStop = 0.002;
Fs = 48 * 10^3;
delta = 0.3;
SNR = 20;

% Calculate
Ts = 1 / Fs;
t = tStart : Ts : tStop;

% Perform delta modulation and demodulation
xt_sig = awgn(sin(2*pi* 1000 * t) + sin(2*pi* 1500 * t) + sin(2*pi* 2000 * t), 20);
yt_sig = sig_mod_delta(xt_sig, delta, 0);
yr_sig = awgn(yt_sig, SNR);
xr_sig = sig_demod_delta(yr_sig, delta, 0);

% Plot results
subplot(2,2,1);
plot(t, xt_sig, 'b');
ylim([-4 4]);
title('Message signal');
subplot(2, 2, 2);
stairs(t, yt_sig);
ylim([-0.5 1.5]);
title('Delta modulation bits (sent data)');
subplot(2, 2, 3);
stairs(t, yr_sig);
title('Delta modulation bits (recieved data)');
subplot(2, 2, 4);
plot(t, xt_sig, 'b');
hold on;
stairs(t, xr_sig, 'r');
ylim([-4 4]);
title('Delta demodulated signal comparision (delta = 0.3)');

