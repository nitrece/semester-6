org 0h
ljmp main
org 23h
clr TI
mov a, P1
mov SBUF, a
reti
main:
mov TMOD, #20h
mov TH1, #0FAh
mov TL1, #0FAh
mov SCON, #40h
setb TR1
mov IE, #90h
mov a, P1
mov SBUF, a
wait:
mov b, P1
mov P2, b
sjmp wait
end
