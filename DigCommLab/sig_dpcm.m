function [y, t] = sig_dpcm(x, Fs, tStart, h)

% Perform required initializations (Prediction filter)
h_len = length(h);
x_len = length(x);
y_len = x_len + h_len - 1;
y = [x zeros(1, h_len - 1)];
eqd_len = y_len;
eqd = zeros(1, y_len);
xd = zeros(1, 1 + h_len);

% Get time scale for signal (Prediction filter)
Ts = 1 / Fs;
t = tStart : Ts : (tStart + ((eqd_len - 1) * Ts));

% Main loop
for i = 1 : eqd_len
    % Get input to the prediction filter
    u = yc + eq;

    % Execute prediction filter
    xd = [u xd( 1 : h_len )];
    yc = sum( h .* xd(2 : end) );
    
    % Get prediction error
    e = y - yc;
    
    % Execute error quantizer
    eqd(i) = sig_quantize(e, e_range, qLevels);
    eq = sig_dequantize(eq, e_range, qLevels);
end

















end