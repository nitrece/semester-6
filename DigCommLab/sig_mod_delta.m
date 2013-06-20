function y = sig_mod_delta(x, delta, delta_start)

% Perform Delta modulation
x_old = delta_start;
y = zeros(1, length(x));
for i = 1 : length(x)
    if(x(i) > x_old)
        x_old = x_old + delta;
        y(i) = 1;
    else
        x_old = x_old - delta;
        y(i) = 0;
    end
end
end