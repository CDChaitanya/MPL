section .data
	m1: db ' BEFORE BLOCK TRANSFER ' ,0x0A
	l1: equ $-m1

	m2: db ' AFTER BLOCK TRANSFER ',0x0A
	l2: equ $-m2

	msg1: db ":"
	len1: equ $-msg1

	msg2: db 0x0A
	len2: equ $-msg2

	arr: dq 0x123456789ABCDEF,0x596852478589ABF9,0x9874651233214569,0x456123789ABCDEFC,0xF56123789ABCDEFC,0,0,0,0,0

section .bss
	%macro write 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro

	cnt: resb 5
	cnt2: resb 16
	result: resb 16

section .text
global main
main:
	write m1,l1
	mov rsi,arr
	mov byte[cnt],5
	call print
	
	mov rsi,arr
	mov rdi,arr+40

copy:	mov rbx,qword[rsi]
	mov qword[rdi],rbx                   ; block transfer without string instruction
	add rsi,8
	add rdi,8
	dec byte[cnt]
	jnz copy	

	write m2,l2	                  
	mov rsi,arr
	mov byte[cnt],10
	call print	
	
	mov rax,60
	mov rdi,3
	syscall

htoa:	mov rsi,result
	mov byte[cnt2],16

up2:	rol rdx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09
	jbe next2
	add cl,07
next2:	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[cnt2]
	jnz up2
	
	write result,16	
	ret

print:	mov rdx,rsi
	push rsi
	call htoa

	write msg1,len1           ; COLON (:)

	pop rsi
	mov rdx,qword[rsi]
	push rsi
	call htoa
	
	write msg2,len2            ; NEW LINE

	pop rsi
	add rsi,8
	dec byte[cnt]
	jnz print

	ret

;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ nasm -f elf64 without_string.asm 
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ld -o without_string without_string.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./without_string
; BEFORE BLOCK TRANSFER 
;0000000000600225:0123456789ABCDEF
;000000000060022D:596852478589ABF9
;0000000000600235:9874651233214569
;000000000060023D:456123789ABCDEFC
;0000000000600245:F56123789ABCDEFC
; AFTER BLOCK TRANSFER 
;0000000000600225:0123456789ABCDEF
;000000000060022D:596852478589ABF9
;0000000000600235:9874651233214569
;000000000060023D:456123789ABCDEFC
;0000000000600245:F56123789ABCDEFC
;000000000060024D:0123456789ABCDEF
;0000000000600255:596852478589ABF9
;000000000060025D:9874651233214569
;0000000000600265:456123789ABCDEFC
;000000000060026D:F56123789ABCDEFC
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ 

