org 0h
mov r2, #40h
mov r0, #58h
mov r1, #70h
mov r3, #5
mov b, #0
loop:
mov a, @r0
add a, b
add a, @r1
da a
mov r4, a
mov a, #0
addc a, #0
mov b, a
mov a, r0
mov r5, a
mov a, r2
mov r0, a
mov a, r4
mov @r0, a
mov a, r5
mov r0, a
inc r0
inc r1
inc r2
djnz r3, loop
end
