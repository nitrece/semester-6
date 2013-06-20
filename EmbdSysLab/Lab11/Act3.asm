; Fout = 10kHz
; Tclk = 22MHz
; Ttmr = 22 / 12 = 1833.33kHz
; Delay = 1833.33 / 60  = 30555
; Load val = -30555 = 88A5h
org 0h
restart:
mov r0, #60
retime:
mov TMOD, #01h
mov TH0, #088h
mov TL0, #0A5h
clr TF0
setb TR0
wait:
jnb TF0, wait
djnz r0, retime
cpl P1.2
sjmp restart
end
