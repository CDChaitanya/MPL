section .data
	msg1: db ' Enter first No : ' ,0x0A
	len1: equ $-msg1

	msg2: db ' Enter Second No : ' ,0x0A
	len2: equ $-msg2

	msg3: db ' Result is : ' 
	len3: equ $-msg3

	m1: db " Enter Your choice: " ,0x0A
	l1: equ $-m1

	m2: db 10,"1.Sucessive Addition",10,"2.Add & Shift",10,"3.EXIT",10
	l2: equ $-m2

section .bss
	%macro write 2
		mov rax,1
		mov rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

	%macro read 2
		mov rax,0
		mov rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

	no1 resb 5
	no2 resb 5
	n1 resb 5
	n2 resb 5
	val1 resb 5
	val2 resb 5
	result resb 5
	ch1 resb 2
	cnt: resb 1

section .text
global main
main:
		mov qword[result],00
		mov rax,00
		mov rbx,00
		mov rcx,00
		mov rdx,00
	
		write msg1,len1
		read no1,3
		mov rsi,no1
		call atoh
		mov byte[val1],bl          ; change
	
	
		write msg2,len2
		read no2,3
		mov rsi,no2
		call atoh
		mov byte[val2],bl

		write m2,l2       ; MENU
		
		write m1,l1        ;NEXT LINE
		read ch1,2
	
		mov al,byte[ch1]
		cmp al,31H
			je succ
		cmp al,32H
			je A_S
		cmp al,33H
			jmp exit	



succ:	mov ax,00
	mov cx,00
	mov al,byte[val1]
	mov cl,byte[val2]

	mov dx,00
up1:	add dx,ax
	dec cl
	jnz up1             ; NOW WE HAVE VALUE DIRECTLY IN DX WHICH IS USED IN HTOA

	call htoa
	
	jmp main 
	ret

A_S :
	mov bx,00
	mov dx,00
	mov bl,byte[val1]
	mov dl,byte[val2]
	mov byte[cnt],08                ;  input is always 06,07 like that
	mov ax,00
	
	up2:
		shr bl,01
		jnc skip
		add ax,dx
		
		skip:
			shl dx,01
			dec byte[cnt]
			jnz up2


	mov dx,ax
	call htoa
	jmp main
	ret

atoh: 	;mov rsi,number       ; THIS IS DONE BEFORE MENU
	mov byte[cnt],2
	mov bx,00

	up:	rol bl,4
		mov dl,byte[rsi]
		cmp dl,39H
		jbe next
		sub dl,07H
		
		next:	sub dl,30H
			add bl,dl
			inc rsi
			dec byte[cnt]
			jnz up
	
	ret


exit:	mov rax,60
	mov rdi,0
	syscall



htoa:	mov qword[result],00
	mov rsi,result
	mov byte[cnt],4

	upp:	rol dx,04
		mov cl,dl
		and cl,0FH
		cmp cl,09H
		jbe next2
		add cl,07              ; {ADD} is important
		
		next2:	add cl,30H
			mov byte[rsi],cl
			inc rsi
			dec byte[cnt]
		jnz upp
	
		write result,4
	ret

;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment4$ nasm -f elf64 multi.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment4$ ld -o multi multi.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment4$ ./multi
 ;Enter first No : 
;5
; Enter Second No : 
;4
;
;1.Sucessive Addition
;2.Add & Shift
;3.EXIT
; Enter Your choice: 
;1
;0444 Enter first No : 
;5
; Enter Second No : 
;4
;
;1.Sucessive Addition
;2.Add & Shift
;3.EXIT
; Enter Your choice: 
;2
;0444 Enter first No : 
;3
; Enter Second No : 
;3

;1.Sucessive Addition
;2.Add & Shift
;3.EXIT
; Enter Your choice: 
;3
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment4$



