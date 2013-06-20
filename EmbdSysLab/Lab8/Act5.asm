; Fout = 60Hz
; Tclk = 11.0592 / 12 = 921.6kHz
; Delay = 921.6/0.12 = 7680
; Load val = -7680 = E200h
org 0h
restart:
mov TL0, #00h
mov TH0, #0E2h
mov TL1, #60
mov TH1, #60
mov TMOD, #61h
clr TF0
clr TF1
setb TR0
setb TR1
wait:
jnb TF0, wait
clr TR0
sjmp restart
display:
mov b, #100
div ab
mov r0, a
mov a, b
mov b, #10
div ab
mov r1, a
mov r2, b
ret
end
