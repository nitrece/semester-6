function y_sig = sig_envelope(x_sig, x_lpf)

% get no. of extra samples due to filter coefficients
y_flt_len2 = floor(length(x_lpf) / 2);

% get absolute of original signal
y_sig = abs(x_sig);

% pass through low pass filter to smoothen it up
y_sig = conv(y_sig, x_lpf);
y_sig = y_sig(1, (y_flt_len2+1) : (y_flt_len2+length(x_sig)));
y_sig = y_sig .* (y_sig >= 0);

% normalize the output
y_sig = y_sig / max(y_sig);
end