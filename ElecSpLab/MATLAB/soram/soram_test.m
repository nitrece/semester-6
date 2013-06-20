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
snd_vel = 260;

% initialize
snd = sbAudioIO(Fs);
fig = figure;
y_flt = sig_lpf();

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
y_crr = sig_xcorr(y_sig, x_dat);
y_env = sig_envelope(y_crr, y_flt);
y_pks = sig_peaks(y_env, 0.1);
y_ipk = sig_invpeaks(y_pks, 0.9);

% estimate distance
d_len = sum(y_ipk > 0);
d = zeros(1, d_len);
d_ref = 0;
d_j = 1;
for i = 1 : y_len
	if(y_ipk(1, i) < 0)
		d_ref = i;
	elseif(y_ipk(1, i) > 0)
		d(1, d_j) = (t_rec(i) - t_rec(d_ref)) * snd_vel;
		d_j = d_j + 1;
	end
end

% display data
subplot(2, 2, 1);
plot(x_sig);
ylim([-1.2 1.2]);
title('Output Signal');
subplot(2, 2, 2);
plot(t_rec, y_sig);
ylim([-1.2 1.2]);
title('Input Signal');
subplot(2, 2, 3);
plot(t_rec, y_crr, 'y');
ylim([-1.2 1.2]);
hold on;
subplot(2, 2, 3);
plot(t_rec, y_env, 'g');
ylim([-1.2 1.2]);
hold on;
subplot(2, 2, 3);
plot(t_rec, y_pks, 'r');
ylim([-1.2 1.2]);
hold on;
subplot(2, 2, 3);
plot(t_rec, y_ipk, 'b');
ylim([-1.2 1.2]);
title('Processed Signals');
hold off;
subplot(2, 2, 4);
scatter(d, zeros(1, length(d)), 'x');
title('Distance Signal');




