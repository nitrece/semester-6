org 0h
mov r0, #40h
mov r3, #5
mov b, @r0
loop:
mov a, b
subb a, @r0
jnc is_smaller
mov b, @r0
is_smaller:
inc r0
djnz r3, loop
mov p2, b
end
