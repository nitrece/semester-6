function [Xf, F] = sig_freq(x, Fs)

% Get the frequency axis for  x
Fs2 = Fs / 2;
Fn = Fs / length(x);
F = (-Fs2 + Fn) : Fn : Fs2;

% Get the frequency spectrum of x
Xf = fftshift(fft(x));
end