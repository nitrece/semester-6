org 0h
mov a, 40h
mov b, 42h
mul ab
mov 44h, a
mov 45h, b 

mov a, 41h
mov b, 42h
mul ab
add a, 45h
mov 45h, a
mov a, b
addc a, #0
mov 46h, a

mov a, 40h
mov b, 43h
mul ab
add a, 45h
mov 45h, a
mov a, b
addc a, #0
add a, 46h
mov 46h, a
mov a, #0
addc a, #0
mov 47h, a

mov a, 41h
mov b, 43h
mul ab
add a, 46h
mov 46h, a
mov a, b
addc a, #0
add a, 47h
mov 47h, a

end
