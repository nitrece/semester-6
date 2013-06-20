function [y, t] = sig_autoregressionfilter(x, Fs, tStart, h)

% Perform required initializations
h_len = length(h);
x_len = length(x);
y_len = x_len + h_len - 1;
x = [x zeros(1, h_len - 1)];
y = zeros(1, y_len);
yd = zeros(1, 1 + h_len);

% Get time scale for signal
Ts = 1 / Fs;
t = tStart : Ts : (tStart + ((y_len - 1) * Ts));

% Do autoregression
for i = 1 : y_len
    y(i) = x(i) + sum( h .* yd(2 : end) );
    yd = [y(i) yd( 1 : h_len )];
end
end