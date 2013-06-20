function y = sig_peaks(x, min_ht)

x_len = length(x);
y = zeros(1, x_len);
x_old = x(1);
x_pk_lt = 0;
x_pk_lt_ht = 0;
for i = 1 : x_len
	if(x(1, i) > x_old)
		x_pk_lt = i;
		x_pk_lt_ht = x(1, i);
	elseif(x(1, i) < x_old && x_pk_lt > 0)
		x_pk_rt = i - 1;
		x_pk_rt_ht = x(1, i - 1);
		y_pk = floor((x_pk_lt + x_pk_rt) / 2);
		y_pk_ht = (x_pk_lt_ht + x_pk_rt_ht) / 2;
		if(y_pk_ht >= min_ht)
			y(1, y_pk) = y_pk_ht;
		end
		x_pk_lt = 0;
	end
	x_old = x(1, i);
end
end