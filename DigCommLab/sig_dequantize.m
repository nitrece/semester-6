function y = sig_dequantize(x, x_range, qLevels)
y = ( x / ( qLevels - 1 ) ) * ( x_range(2) - x_range(1) ) + x_range(1);
end