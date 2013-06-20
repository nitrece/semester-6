org 0h
mov dptr, #150h
mov r0, #40h
mov r1, #58h
mov r2, #0
mov r3, #12
copy_loop:
mov a, r2
movc a, @a+dptr
mov @r0, a
inc r0
inc r2
djnz r3, copy_loop
mov r0, #40h
mov r3, #12
mov a, #0
add_loop:
add a, @r0
inc r0
djnz r3, add_loop
mov b, #12
div ab
mov @r1, a
org 150h
db 7, 7, 7, 7, 7, 7, 9, 9, 9, 9, 9, 9
end
