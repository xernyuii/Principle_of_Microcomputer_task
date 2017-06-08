.model tiny
com_addr	equ 0263H
to_addr equ	0260H
t1_addr	equ	0261H
.stack 100
.code
start:
	mov dx,com_addr
	mov al,35H
	out dx,al
	mov dx,to_addr
	mov al,00H
	out dx,al
	mov al,10H
	out dx,al
	mov dx,com_addr
	mov al,77H
	out dx,al
	mov dx,t1_addr
	mov al,00H
	out dx,al
	mov al,10H
	out dx,al
	jmp $
	end start
