org 0h
mov a, #0FFh
mov p1, a
mov a, p1
mov b, #100
div ab
add a, #'0'
mov 40h, a
mov a, b
mov b, #10
div ab
add a, #'0'
mov 41h, a
add b, #'0'
mov 42h, b
end
