clc;
clear all;
close all;

% settings
Fs = 48000;
Ts = 1 / Fs;
F = 10 * 10^3;
x_dat_tm = 0.001;
x_sil_tm = 0.2;
y_tim = 2;

% initialize
snd = sbAudioIO(Fs);
fig = figure;
y_flt = lpf();

% generate data signals
t_dat = 0 : Ts : x_dat_tm;
x_dat = sin(2*pi* F * t_dat);
x_sil = zeros(1, x_sil_tm * Fs);

% generate output
x_sig = [x_dat x_sil x_dat x_sil x_dat x_sil x_dat x_sil x_dat x_sil];
x_ply = [x_sig; x_sig]';

% play output (with recording)
snd.Start();
snd.SetOut(x_ply);

% wait (record) for 2 seconds
pause(y_tim);

% get recorded data
[y_rec, t_rec] = getdata(snd.Ai, snd.Ai.SamplesAvailable);
snd.Stop();
y_sig = y_rec(:, 1)';

% correct output data
x_len = length(x_sig);
y_len = length(y_sig);
x_sig = [x_sig zeros(1, y_len - x_len)];

% perform processing on recorded data
y_flt_len = length(y_flt);
y_flt_len2 = floor(y_flt_len / 2);
y_crr = xcorr(y_sig, x_dat);
y_crr = y_crr(1, y_len : end);
y_crr = y_crr / max(y_crr);
y_env = conv(abs(y_crr), y_flt);
y_env = y_env(1, (y_flt_len2+1) : (y_flt_len2+y_len));
y_pks = sig_peaks(y_env, 0.05);
y_ipk = sig_invpeaks(y_pks, 0.5);

% display data
subplot(3, 2, 1);
plot(x_sig);
ylim([-1.2 1.2]);
title('Output Signal');
subplot(3, 2, 2);
plot(t_rec, y_sig);
ylim([-1.2 1.2]);
title('Input Signal');
subplot(3, 2, 3);
plot(t_rec, y_crr);
ylim([-1.2 1.2]);
title('Correlated Signal');
subplot(3, 2, 4);
plot(t_rec, y_env);
ylim([-1.2 1.2]);
title('Enveloped Signal');
subplot(3, 2, 5);
plot(t_rec, y_pks);
ylim([-1.2 1.2]);
title('Peaks Signal');
subplot(3, 2, 6);
plot(t_rec, y_ipk);
ylim([-1.2 1.2]);
title('Derivative2 Signal');





