; Constants
LCD_RS8			BIT	P2.2
LCD_RW8			BIT	P2.3
LCD_E8			BIT	P2.4
LCD_LED8		BIT	P2.5
LCD_PORT8		EQU	P0
LCD_RS4			BIT	P2.0
LCD_E4			BIT	P2.1
LCD_PORT4		EQU	P2
lcdWrt			EQU	lcdWrt8
lcdReady		EQU	lcdReady8

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




; lcdWrt8(A = data, B = RS)
; Writes a data to LCD port
lcdWrt8:
mov r7, a
mov LCD_PORT8, a
clr LCD_RW8		; write
mov a, b
jnz	wr8_rs_1
clr LCD_RS8		; command
sjmp wr8_rs
wr8_rs_1:
setb LCD_RS8	; data
wr8_rs:
setb LCD_E8		; hi-lo pulse (latch data)
clr LCD_E8
mov a, r7
ret

; lcdWrt4(A = data, B = RS)
; Writes a data to LCD port
lcdWrt4:
; write high 4bits
mov r7, a
rr a
rr a
anl a, #03Ch
mov LCD_PORT4, a
mov a, b
jnz wr_rs1_1
clr LCD_RS4		; command
sjmp wr_rs1
wr_rs1_1:
setb LCD_RS4	; data
wr_rs1:
setb LCD_E4		; hi-lo pulse (latch data)
clr LCD_E4
; send low 4bits
mov a, r7
rl a
rl a
anl a, #03Ch
mov LCD_PORT4, a
mov a, b
jnz wr_rs2_1
clr LCD_RS4		; command
sjmp wr_rs2
wr_rs2_1:
setb LCD_RS4	; data
wr_rs2:
setb LCD_E4		; hi-lo pulse (latch data)
clr LCD_E4
mov a, r7
ret

; lcdCmd(A = command)
; Sends a command to LCD
lcdCmd:
acall lcdReady
mov b, #0
acall lcdWrt
ret

; lcdData(A = data)
; Sends an 8bit data to LCD
lcdData:	
acall lcdReady
mov b, #1
acall lcdWrt
ret	

; lcdReady8()
; Checks the busy flag & waits
; till LCD is ready to ready 
; for next instruction
lcdReady8:
mov r6, a
mov r5, b
mov a, #0FFh
mov b, #0
acall lcdWrt8
is8_lcd_ready:	
clr LCD_E8
setb LCD_E8
jb LCD_PORT8.7, is8_lcd_ready
clr LCD_E8
mov b, r5
mov a, r6
ret

; lcdReady4()
; Checks the busy flag & waits
; till LCD is ready to ready 
; for next instruction
lcdReady4:
mov r6, a
mov r5, b
mov a, #0FFh
mov b, #0
acall lcdWrt4
is4_lcd_ready:	
clr LCD_E4
setb LCD_E4
jb LCD_PORT4.5, is4_lcd_ready
clr LCD_E4
ret
end
