; Fout = 500Hz
; Tclk = 11.0592 / 12 = 921.6kHz
; Delay = 460.8 == 461
; Load val = -461 = FE33h
org 0h
restart:
mov TL1, #033h
mov TH1, #0FEh
mov TMOD, #10h
clr TF1
setb TR1
wait:
jnb TF1, wait
clr TR1
cpl P1.0
sjmp restart
end
