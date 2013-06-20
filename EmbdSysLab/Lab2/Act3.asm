org 0h
mov r0, #40h
mov r2, #4
loop1:
mov b, @r0
mov a, r0
mov r4, a
mov a, r2
mov r3, a
mov a, r0
mov r1, a
inc r1
loop2:
mov a, b
subb a, @r1
jc is_greater
mov b, @r1
mov a, r1
mov r4, a
is_greater:
inc r1
djnz r3, loop2
mov a, r4
mov r1, a
mov a, @r0
mov @r1, a
mov @r0, b
inc r0
djnz r2, loop1
end
