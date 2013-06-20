function y = sig_derivative(x)

x_pre = 0;
x_len = length(x);
y = zeros(1, x_len);
for i = 1 : x_len
	y(1, i) = x(1, i) - x_pre;
	x_pre = x(1, i);
end
end