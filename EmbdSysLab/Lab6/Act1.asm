; Fout = 500Hz
; Tclk = 11.0592 / 12 = 921.6kHz
; Delay = 921.6 == 922
; Load val = -922 = FC66h
org 0h
restart:
mov TL0, #066h
mov TH0, #0FCh
mov TMOD, #01h
clr TF0
setb TR0
wait:
jnb TF0, wait
clr TR0
cpl P1.0
sjmp restart
end
