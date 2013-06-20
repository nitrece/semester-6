function y = sig_quantize(x, x_range, qLevels)
y = round( ( ( x - x_range(1) ) / ( x_range(2) - x_range(1) ) ) * ( qLevels - 1 ) );
end