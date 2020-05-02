section .data
	fname: db 'abc.txt',0          
	m1: db ' FILE IS OPENED ' ,0x0A
	l1: equ $-m1

	m2: db ' FILE IS READ ',0x0A
	l2: equ $-m2
	
	m3: db ' THE NUMBER OF ENTER ARE ',0x0A
	l3: equ $-m3

	m4: db ' THE NUMBER OF SPACE ARE ',0x0A
	l4: equ $-m4

	m5: db ' ENTER THE ELEMENT ',0x0A
	l5: equ $-m5

	m6: db ' THE NUMBER OF OCCURANCE IS ',0x0A
	l6: equ $-m6

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

	global char,buffer,len1
	char resb 50
	fd resb 100
	buffer resb 1000
	len1 resb 100
	len2 resb 100
	len3 resb 100


section .text
global main 
main:
	extern ent,spc,occ
	
	mov rax,00
	mov rbx,00
	mov rcx,00
	mov rdx,00

 	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,0777
	syscall
	mov qword[fd],rax
	
	BT rax,63
	jc exit	

	write m1,l1

	mov rax,00
	mov rbx,00
	mov rcx,00
	mov rdx,00

 	mov rax,0
	mov rdi,[fd]
	mov rsi,buffer
	mov rdx,1000
	syscall
	mov qword[len1],rax
	
	write m2,l2

	write m3,l3
      	call ent

	write m4,l4
      	call spc

	write m5,l5
	read char,2
	write m6,l6
      	call occ

exit:	mov rax,60
	mov rdi,0
	syscall	
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment5$ nasm -f elf64 p1.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment5$ nasm -f elf64 p2.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment5$ ld -o output p1.o p2.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment5$ ./output
; FILE IS OPENED 
; FILE IS READ 
; THE NUMBER OF ENTER ARE 
;05 THE NUMBER OF SPACE ARE 
;03 ENTER THE ELEMENT 
;a
; THE NUMBER OF OCCURANCE IS 
;04(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop/MPL 21418/Assignment5$ 



