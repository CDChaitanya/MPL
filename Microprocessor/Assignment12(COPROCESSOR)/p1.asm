section .data
	m1: db ' MEAN ===> ' ,0x0A
	l1: equ $-m1

	m2: db ' VARIANCE===> ',0x0A
	l2: equ $-m2
	
	m3: db ' STANDARD DEVIATION===> ',0x0A
	l3: equ $-m3


	arr: dd 101.11,102.22,103.33,104.44,105.55
	cnt: dw 5
	dec: dw 100
	dot: db '.'
	new_line:db 10

section .bss
	mean: resb 100
	variance: resb 100
	sd: resb 100
	result: resb 100
	buffer: resb 200
	count: resb 20
	cnt1: resb 20
	cnt2: resb 20
	cnt3: resb 20
	
	%macro write 2
		mov rax,1
		mov rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

section .text
global main 
main:


MEAN:	finit
		fldz
		mov rsi,arr
		mov byte[count],5

	up1:	fadd dword[rsi]
			add rsi,4
			dec byte[count]
			jnz up1

	fidiv word[cnt]
	fst dword[mean]
	write m1,l1
	call print
	write new_line,1


VARI:	
	mov rsi,arr
	mov byte[cnt2],5
	fldz
	
	up2:	fldz
			fadd dword[rsi]
			fsub dword[mean]
			fmul st0
			fadd
			add rsi,4
			dec byte[cnt2]
			jnz up2

	fidiv word[cnt]
	fst dword[variance]
	write m2,l2
	call print
	write new_line,1


SD:	fldz
	fld dword[variance]
	fsqrt
	fst dword[sd]
	write m3,l3
	call print
	write new_line,1	

	
EXIT:	mov rax,60
		mov rdi,0
		syscall

print:	fimul word[dec]
		fbstp tword[buffer]
		mov rsi,buffer+9
		mov byte[cnt3],9

		up4:	mov dl,byte[rsi]
				push rsi
				call htoa
				pop rsi
				dec rsi
				dec byte[cnt3]
				jnz up4

	write dot,1
	mov dl,byte[buffer]
	call htoa
	ret
	

htoa:	mov qword[result],00
	mov rsi,result
	mov byte[cnt1],2

	upp:	rol dl,04
		mov cl,dl
		and cl,0FH
		cmp cl,09H
		jbe next2
		add cl,07              ; {ADD} is important
		
		next2:	add cl,30H
			mov byte[rsi],cl
			inc rsi
			dec byte[cnt1]
		jnz upp
	
		write result,2
	ret
	

;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ nasm -f elf64 p1.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ld -o p1 p1.o
;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./p1
; MEAN ===> 
;000000000000000103.33
; VARIANCE===> 
;000000000000000002.46
; STANDARD DEVIATION===> 
;000000000000000001.57
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ 


