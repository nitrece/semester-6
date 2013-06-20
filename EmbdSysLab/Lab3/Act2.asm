org 0h
mov r0, #60h
mov r1, #10
mov r2, #0
mov r3, #0
loop:
mov a, r2
add a, @r0
da a
mov r2, a
mov a, r3
addc a, #0
mov r3, a
inc r0
djnz r1, loop
end
