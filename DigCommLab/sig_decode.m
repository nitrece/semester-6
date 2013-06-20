function y = sig_decode(x, nBits)
x = double(x > 0.5);
x = char(char(x) + '0');
y = bin2dec(reshape(x, nBits, length(x) / nBits)')';
end