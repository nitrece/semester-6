function y = sig_derivative(x)

% initilize
x_pre = 0;
x_len = length(x);
y = zeros(1, x_len);

% get the difference between the current and previous element
for i = 1 : x_len
	y(1, i) = x(1, i) - x_pre;
	x_pre = x(1, i);
end
end