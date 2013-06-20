; Multiplication using repeated addition
mov r0, #4
mov	r1, #2
mov a, #0
mov r4, #0

loop:
add a, r0
jnc no_carry
inc	r4
no_carry:
djnz loop
mov r3, a
end
