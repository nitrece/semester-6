org 0h
restart:
mov TL0, #100
mov TH0, #100
mov TMOD, #06h
clr TF0
setb TR0
wait:
mov a, TL0
acall display
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
