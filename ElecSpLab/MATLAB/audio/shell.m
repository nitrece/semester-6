clc;
clear all;
close all;

% get the filter coefficients
h = lpf3k();

framesamples=1000; fs=22050; totalframes=200; 
wave=zeros(framesamples*totalframes,2); 
pointer=1; 
tgrabaudio('start',fs); 
for ii=1:totalframes 
framedata=tgrabaudio(framesamples); 
plot(framedata);
ylim([-1 1]);
wave(pointer:pointer+framesamples-1,:)=framedata; 
pointer=pointer+framesamples; 
drawnow;
end; 
wave = [conv(wave(:, 1)', h)' conv(wave(:, 1)', h)'];
sound(wave,fs);
