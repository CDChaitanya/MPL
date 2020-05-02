section .data
	msg: db "Factorial is 1",0x0A
	len: equ $-msg

	msg1: db " ",0x0A
	len1: equ $-msg1

	msg2: db "Factorial is:"
	len2: equ $-msg2

	count: db 00
section .bss
	num: resq 1
	result: resb 16
	%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .text
global main
main:
	pop rbx
	pop rbx
	pop rbx
	mov [num],rbx
	call AtoH
	cmp bl,00
	je exit
	cmp bl,01
	je exit
	mov rax,00
	mov rax,01
	mul rbx
	call fact
	mov rdx,rax
	call HtoA
	mov rax,60
	mov rdx,3
	syscall


	fact:	dec rbx
		cmp bl,01
		je out
		mul rbx
		call fact


	out:	ret

exit:	scall 1,1,msg,len
	scall 1,1,msg1,len1
	mov rax,60
	mov rdx,3
	syscall

AtoH:
mov rsi,qword[num]
mov rbx,00
mov rdx,00
mov byte[count],02
up:	rol bl,04
	mov dl,byte[rsi]
	cmp dl,39H
	jbe down
	sub dl,07
down:	sub dl,30H
	add bl,dl
	mov dl,00
	inc rsi
	dec byte[count]
	jnz up
	ret

HtoA:
mov rsi,result
mov rcx,00
mov byte[count],25
up1:	rol rdx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe down1
	add cl,07
down1:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[count]
	jnz up1
	scall 1,1,result,16
	scall 1,1,msg1,len1
	ret


;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ nasm -f elf64 factr.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ld -o factr factr.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./factr 09
;0000000000058980 
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./factr 05
;0000000000000078 
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./factr 00
;Factorial is 1
; 
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ 
