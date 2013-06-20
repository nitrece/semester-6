org 0h
mov dptr, #150h
mov r0, #50h
mov r1, #0
mov r2, #4
loop:
mov a, r1
movc a, @a+dptr
mov b, #100
div ab
add a, #30h
mov @r0, a
inc r0
mov a, b
mov b, #10
div ab
add a, #30h
mov @r0, a
inc r0
mov a, b
add a, #30h
mov @r0, a
inc r0
inc r1
djnz r2, loop
org 150h
db	10h, 20h, 40h, 0FFh
end
