; Constants
LCD_RS8			BIT	P2.2
LCD_RW8			BIT	P2.3
LCD_E8			BIT	P2.4
LCD_LED8		BIT	P2.5
LCD_PORT8		EQU	P0

; Program
org 0h
setb LCD_LED8
mov a, #38h
acall lcdCmd
mov a, #06h
acall lcdCmd
mov a, #0ch
acall lcdCmd
mov a, #01h
acall lcdCmd
mov a, #86h
acall lcdCmd	;1st line 6th character
mov a, #'D'
acall lcdData
mov a, #'N'
acall lcdData
mov a, #'A'
acall lcdData
mov a, #0c3h
acall lcdCmd	;2nd Line 3rd character
mov a, #'T'
acall lcdData
mov a, #'E'
acall lcdData
mov a, #'C'
acall lcdData
mov a, #'H'
acall lcdData
mov a, #'N'
acall lcdData
mov a, #'O'
acall lcdData
mov a, #'L'
acall lcdData
mov a, #'O'
acall lcdData
mov a, #'G'
acall lcdData
mov a, #'Y'
acall lcdData
wait:
sjmp wait



; lcdWrt8(A = data, C = RS)
; Writes a data to LCD port
lcdWrt8:
mov r7, a
mov LCD_PORT8, a
clr LCD_RW8		; write
mov LCD_RS8, C
setb LCD_E8		; hi-lo pulse (latch data)
clr LCD_E8
mov a, r7
ret

; lcdCmd(A = command)
; Sends a command to LCD
lcdCmd:
acall lcdReady
clr C
acall lcdWrt8
;mov LCD_PORT8, a	
;clr LCD_RW8		; write
;clr LCD_RS8		; command
;setb LCD_E8		; hi-lo pulse (latch data)
;clr LCD_E8
ret



; lcdData(A = data)
; Sends an 8bit data to LCD
lcdData:	
acall lcdReady
setb C
acall lcdWrt8
;mov LCD_PORT8, a	
;clr LCD_RW8		; write
;setb LCD_RS8		; data
;setb LCD_E8		; hi-lo pulse (latch data)
;clr LCD_E8
ret	

; lcdReady()
; Checks the busy flag & waits
; till LCD is ready to ready 
; for next instruction
lcdReady:
mov LCD_PORT8, #0FFh
clr LCD_RS8		; command
setb LCD_RW8		; write
is_lcd_ready:	
clr LCD_E8
setb LCD_E8
jb LCD_PORT8.7, is_lcd_ready
clr LCD_E8
ret
end
