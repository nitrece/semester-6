org 0h
mov dptr, #200h
mov r0, #0
mov r1, #40h
loop:
mov a, r0
movc a, @a+dptr
jz p_end
mov @r1, a
inc r0
inc r1
sjmp loop
p_end:
org 200h
db "Subhajit Sahu", 0
end
