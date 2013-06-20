org 0h
mov a, #0FFh
mov p1, a
loop:
mov a, p1
mov p0, a
mov p2, a
mov r0, a
mov r1, a
mov r2, a
sjmp loop
end
