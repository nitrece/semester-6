function y = sig_compress_mu_law(x, x_range, u)
% After compression, the range of signal is from -1 to 1
y = ( ( x - x_range(0) ) / ( x_range(1) - x_range(0) ) ) * 2 - 1;
y = sgn(y) .* ( ln(1 + u*abs(x)) / ln(1 + u) );
end