; Fout = 4800bps
; Tclk = 11.0592 / 12 = 921.6kHz
; Tser = 921.6 / 32 = 28800Hz
; Delay = 28800 / 4800 = 6
; Load val = -6 = FAh
org 0h
mov dptr, #200h
mov r0, #0
mov a, PCON
setb ACC.7
mov PCON, a
mov TMOD, #20h
mov TH1, #0FFh
mov TL1, #0FFh
mov SCON, #40h
setb TR1
resend:
mov a, r0
movc a, @a+dptr
jnz disp
mov r0, #0
sjmp resend
disp:
mov SBUF, a
inc r0
wait:
jnb TI, wait
clr TI
sjmp resend
org 200h
db	"Hare Krishna Hare Krishna, Krishna Krishna Hare Hare. Hare Rama Hare Rama, Rama Rama Hare Hare.", 0Dh, 0Ah, 0
end
