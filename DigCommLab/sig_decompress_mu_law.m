function y = sig_decompress_mu_law(x, x_range, u)
% Before decompression, the range of signal must be from -1 to 1
y = sgn(x) .* ( ( exp( abs( x * ln(1 + u) ) ) - 1 ) / u );
y = ( (y + 1) / 2 ) * ( x_range(1) - x_range(0));
end