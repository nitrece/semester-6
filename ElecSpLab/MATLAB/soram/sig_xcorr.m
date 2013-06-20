function y_sig = sig_xcorr(x_sig, x_dat)

% get the cross correlation
y_sig = xcorr(x_sig, x_dat);

% remove the extra samples
y_sig = y_sig(1, length(x_sig) : end);

% normalize the output
y_sig = y_sig / max(y_sig);
end