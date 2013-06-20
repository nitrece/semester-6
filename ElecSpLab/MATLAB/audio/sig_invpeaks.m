function y = sig_invpeaks(x, min_ht)
y = (-1*(x >= min_ht) + (x < min_ht)) .* x;
end