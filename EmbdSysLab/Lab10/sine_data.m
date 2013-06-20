clc;
clear all;
close all;

ang = linspace(0, 2*pi, 256);
val = 128 + 127 * sin(ang);

fout = fopen('sine_data.txt', 'w');
for i = 1 : length(ang)
    fprintf(fout, 'DB %d\r\n', floor(val(i)));
end
fclose(fout);
