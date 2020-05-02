section .data
	msg: db "File a.txt is opened successfully!!",0x0A
	len: equ $-msg

	msg1: db "File b.txt is opened successfully!!",0x0A
	len1: equ $-msg1

	msg2: db " ",0x0A
	len2: equ $-msg2

	msg3: db "File a.txt not opened successfully!!",0x0A
	len3: equ $-msg3

	msg4: db "File b.txt not opened successfully!!",0x0A
	len4: equ $-msg4

	msg5:db "Contents of a.txt:",0x0A
	len5: equ $-msg5

	msg6:db "Contents of b.txt after copying:",0x0A
	len6: equ $-msg6

	msg7: db "File c.txt deleted!!",0x0A
	len7: equ $-msg7

section .bss
	afdes: resq 2
	bfdes: resq 2
	cfdes: resq 2
	buffer: resb 100
	buffer1: resb 100
	fname1: resq 1
	fname2: resq 1
	fname3: resq 1
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
	cmp byte[rbx],63H      ;c
	je cpy

	cmp byte[rbx],64H      ;d
	je del

	jmp type	

cpy:	pop rbx
	mov rax,0
	mov rsi,fname1
	up:	mov al,byte[rbx]           ;storing file 1 name
		mov byte[rsi],al
		inc rsi
		inc rbx
		cmp byte[rbx],0
	jnz up

	pop rbx
	mov rax,0
	mov rsi,fname2
	up1:	mov al,byte[rbx]            ;storing file 2 name
		mov byte[rsi],al
		inc rsi
		inc rbx
		cmp byte[rbx],0
	jnz up1

	scall 2,fname1,2,0777               ; opening a.txt file
	mov qword[afdes],rax
	bt rax,63
	jc carry
	scall 1,1,msg,len
	scall 0,[afdes],buffer,100          ; read sys call
	scall 1,1,msg5,len5
	scall 1,1,msg2,len2
	scall 1,1,buffer,100
	scall 1,1,msg2,len2

	scall 2,fname2,2,0777               ; opening b.txt file
	mov qword[bfdes],rax
	bt rax,63
	jc carry1
	scall 1,1,msg1,len1	
	scall 1,[bfdes],buffer,100          ; write contents of buffer to b.txt
	scall 1,1,msg6,len6
	scall 1,1,msg2,len2
	scall 0,[bfdes],buffer,100
	scall 1,1,buffer,100
	scall 1,1,msg2,len2
	jmp exit
	

del:	pop rbx
	mov rax,00
	mov rsi,fname3
up3:	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0
	jnz up3
	scall 1,1,msg7,len7
	mov rax,87
	mov rdi,fname3
	syscall
	jmp exit
	

type:	pop rbx
	mov rax,00
	mov rsi,fname1
up2:	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0
	jnz up2

	scall 2,fname1,2,0777 
	mov qword[afdes],rax
	bt rax,63
	jc carry
	scall 1,1,msg,len
	scall 1,1,msg2,len2
	scall 0,[afdes],buffer1,100
	scall 1,1,buffer1,100
	mov rax,3
	mov rsi,fname1
	syscall
	mov rax,3
	mov rsi,fname2
	syscall
	jmp exit


carry: 	scall 1,1,msg3,len3
	scall 1,1,msg2,len2
	jmp exit
carry1: scall 1,1,msg4,len4
	scall 1,1,msg2,len2	
	jmp exit

exit:	mov rax,60
	mov rdi,3
	syscall

;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ nasm -f elf64 main.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ld -o main main.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./main copy a.txt b.txt
;File a.txt is opened successfully!!
;Contents of a.txt:
; 
;Pune Institute
;of Computer
;Technology
; 
;File b.txt is opened successfully!!
;Contents of b.txt after copying:
; 
;Pune Institute
;of Computer
;Technology
; 
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./main type a.txt
;File a.txt is opened successfully!!
; 
;Pune Institute
;of Computer
;Technology
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./main delete c.txt
;File c.txt deleted!!
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ 

