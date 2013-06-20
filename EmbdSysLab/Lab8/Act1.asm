; Fout = 10kHz
; Tclk = 22MHz
; Ttmr = 22 / 12 = 1833.33kHz
; Delay = 1833.33 / 60  = 30555
; Load val = -30555 = 88A5h
org 0h
mov p0, #-2
mov p1, #-3
mov p2, #-5
mov p3, #-9
restart:
mov r0, #1
retime:
mov TMOD, #01h
mov TH0, #088h
mov TL0, #0A5h
clr TF0
setb TR0
wait:
jnb TF0, wait
djnz r0, retime
mov a, p0
rl a
mov p0, a
mov a, p1
rl a
mov p1, a
mov a, p2
rl a
mov p2, a
mov a, p3
rl a
mov p3, a
sjmp restart
end
