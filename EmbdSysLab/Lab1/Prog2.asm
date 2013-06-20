mov b, 44h
mov r0, #40h
mov r1, #4
loop:
mov @r0, b
inc r0
djnz r1, loop
end
