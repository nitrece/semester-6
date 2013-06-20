org 0h
mov dptr, #150h
mov r0, #40h
mov r1, #58h
mov r2, #0
mov r3, #7
copy_loop:
mov a, r2
movc a, @a+dptr
subb a, #30h
mov @r0, a
inc r0
inc r2
djnz r3, copy_loop
mov r0, #40h
mov r3, #7
mov a, #0
add_loop:
add a, @r0
inc r0
djnz r3, add_loop
mov b, #7
div ab
add a, #30h
mov @r1, a
org 150h
db '1','2','3','4','5','6','7'
end
