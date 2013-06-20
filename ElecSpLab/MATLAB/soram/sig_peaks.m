function y_sig = sig_peaks(x_sig, x_min_pk_ht)

% initialize
x_len = length(x_sig);
y_sig = zeros(1, x_len);
x_old = x_sig(1);
x_pk_lt = 0;
x_pk_lt_ht = 0;

% loop for peaks
for i = 1 : x_len
	if(x_sig(1, i) > x_old)
		x_pk_lt = i;
		x_pk_lt_ht = x_sig(1, i);
	elseif(x_sig(1, i) < x_old && x_pk_lt > 0)
		x_pk_rt = i - 1;
		x_pk_rt_ht = x_sig(1, i - 1);
		y_pk = floor((x_pk_lt + x_pk_rt) / 2);
		y_pk_ht = (x_pk_lt_ht + x_pk_rt_ht) / 2;
		if(y_pk_ht >= x_min_pk_ht)
			y_sig(1, y_pk) = y_pk_ht;
		end
		x_pk_lt = 0;
	end
	x_old = x_sig(1, i);
end
end