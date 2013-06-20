function y = sig_conv(x, h)

xlen = length(x);
hlen = length(h);
ylen = xlen + hlen - 1;
y = zeros(1, ylen);
for i = 1 : xlen
    y( i : (i+hlen-1) ) = y( i : (i+hlen-1) ) + x(i) * h;
end
end
