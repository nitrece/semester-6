function y = sig_encode(x, nBits)
y = reshape( dec2bin(x, nBits)', 1, length(x) * nBits );
y = double(y - '0');
end