; Constants
DAC_PORT	EQU		P0

; Program
org 0h
mov r0, #0
reout:
mov DAC_PORT, r0
inc r0
acall delay
sjmp reout

delay:
mov r7, #1
loop1:
mov r6, #1
loop2:
djnz r6, loop2
djnz r7, loop1
ret
end
