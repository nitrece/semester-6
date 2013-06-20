org 0h
mov dptr, #300h
mov a, #0
movc a, @a+dptr
mov r0, a
mov a, #1
movc a, @a+dptr
mov r1, a
mov a, #2
movc a, @a+dptr
mov r2, a
org 300h
db  "NIT"
end
