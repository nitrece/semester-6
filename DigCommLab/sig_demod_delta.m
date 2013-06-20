function y = sig_demod_delta(x, delta, delta_start)

% Perform Delta demodulation
x_old = delta_start;
y = zeros(1, length(x));
for i = 1 : length(x)
    if(x(i) > 0.5)
        x_old = x_old + delta;
    else
        x_old = x_old - delta;
    end
    y(i) = x_old;
end
end