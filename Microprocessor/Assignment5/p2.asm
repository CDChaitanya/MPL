%macro write 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .bss
	extern char,buffer,len1
	cnt: resb 10
	cnt1: resb 10
	result: resb 16
	cnt2: resb 16
	length: resb 100

section .text
global main1                  ;'HERE "MAIN1" IS ESSENTIAL'
main1:
	global ent,spc,occ


ent:	mov rax,qword[len1]                  ; directly control comes here
	mov qword[length],rax                ; ESSENTIAL
	mov rsi,buffer
	mov byte[cnt],00
up:	cmp byte[rsi],0x0A
	jne next1        ; JUMP IF EQUAL
	inc byte[cnt]

next1:	inc rsi
	dec qword[length]
	jnz next3
	mov rdx,00
	mov dl,byte[cnt]
	call htoa
	RET	

next3:  jmp up


	mov rax,00
	mov rbx,00
	mov rcx,00
	mov rdx,00
	mov rsi,00

spc:	mov rax,qword[len1]
	mov qword[length],rax	
	mov rax,0
	mov rsi,buffer
	mov byte[cnt1],00
up1:	cmp byte[rsi],0x20
	jne next4        ; JUMP IF EQUAL
	inc byte[cnt1]

next4:	inc rsi
	dec qword[length]
	jnz next5
	mov rdx,00
	mov dl,byte[cnt1]
	call htoa
	RET	

next5:  jmp up1



occ:	mov rax,qword[len1]
	mov qword[length],rax	
	mov rax,0
	mov al,byte[char]                 ; important step
	mov rsi,buffer
	mov byte[cnt1],00
up2:	cmp byte[rsi],al                  ; see change
	jne next6       ; JUMP IF EQUAL
	inc byte[cnt1]

next6:	inc rsi
	dec qword[length]
	jnz next7
	mov rdx,00
	mov dl,byte[cnt1]
	call htoa
	RET	

next7:  jmp up2


htoa:	mov byte[result],00                           
	mov rsi,result
	mov byte[cnt2],2

	upp:	rol dl,04
		mov cl,dl
		and cl,0FH
		cmp cl,09H
		jbe next2
		add cl,07              ; {ADD} is important
		
		next2:	add cl,30H
			mov byte[rsi],cl
			inc rsi
			dec byte[cnt2]
		jnz upp
	
		write result,4
	ret
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



