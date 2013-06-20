org 0h
mov r0, #40h
mov	r1, #60h
mov r3, #5
loop:
mov a, @r0
mov	b, @r1
mov @r0, b
mov @r1, a
inc r0
inc r1
djnz r3, loop
end
