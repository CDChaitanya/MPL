section .data
	arr: dq -123456789ABCDEF0H,-923456789ABCDE0FH,-823456789ABCD0EFH,-883456789AB0CDEFH,-223456789AB0CDEFH
	pos: db 0
	neeg: db 0
	count: db 5
	m: db 0x0A

	msg1: db 'THE POSITIVE NUMBERS ARE ',0x0A
	len1: equ $-msg1

	msg2: db 'THE NEGATIVE NUMBERS ARE ',0x0A
	len2: equ $-msg2

section .text
global main 
main:
		mov rsi,arr

up:		mov rax,qword[rsi]
		BT rax,63
		JC next 
		inc byte[pos]
		jmp up2

		next:	inc byte[neeg]

		up2:	add rsi,8
			dec byte[count]
			jnz up	

		CMP byte[pos],9H           ;just for precaution
		JBE down
		add byte[pos],37H
		JMP below

		down: 	add byte[pos],30H

		below:	CMP byte[neeg],9H
			JBE dwn
			add byte[neeg],37H
			JMP blw

		dwn: 	add byte[neeg],30H
blw:	
	mov rax,1
	mov rdi,1
	mov rsi,msg1
	mov rdx,len1
	syscall
	
	mov rax,1
	mov rdi,1
	mov rsi,pos
	mov rdx,1
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,m
	mov rdx,1
	syscall
  	
	mov rax,1
	mov rdi,1
	mov rsi,msg2
	mov rdx,len2
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,neeg
	mov rdx,1
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,m
	mov rdx,1
	syscall
 	
	mov rax,60
	mov rdi,0
	syscall


;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment1$ nasm -f elf64 arradd.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment1$ ld -o arradd arradd.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment1$ ./arradd
;THE POSITIVE NUMBERS ARE 
;3
;THE NEGATIVE NUMBERS ARE 
;2



