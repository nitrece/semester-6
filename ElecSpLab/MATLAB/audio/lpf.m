function b = lpf
%LPF Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 06-Feb-2013 19:09:12
%

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in kHz.
Fs = 48;  % Sampling Frequency

Fpass = 4.8;             % Passband Frequency
Fstop = 5.2;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
end

% [EOF]
