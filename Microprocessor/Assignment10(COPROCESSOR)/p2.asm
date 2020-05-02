section .data
	ff1: db '%lf +i (%lf)',10,0
	ff2: db '%lf -i (%lf)',10,0
	
	formatpi: db '%d',10,0
	formatpf: db '%lf',10,0
	formatsf: db '%lf',0

	four: dq 4
	two: dq 2

	m1: db ' REAL ROOTS ' ,0x0A
	l1: equ $-m1

	m2: db ' IMAGINARY  ROOTS ',0x0A
	l2: equ $-m2

	new_line:db 10

section .bss
	a: resq 1
	b: resq 1
	c: resq 1

	b2: resq 1 
	fac: resq 1 
	delta: resq 1 
	rdelta: resq 1 

	r1: resq 1 
	r2: resq 1	
	ta: resq 1 	

	realn: resq 1 
	img1: resq 1

	%macro myprintf 1
		mov rdi,formatpf
		sub rsp,8
		movsd xmm0,[%1]
		mov rax,1
		call printf
		add rsp,8
	%endmacro

	%macro myscanf 1
		mov rdi,formatsf
		mov rax,0
		sub rsp,8
		mov rsi,rsp
		call scanf
		mov r8,qword[rsp]
		mov qword[%1],r8	
		add rsp,8
	%endmacro

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
	extern scanf
	extern printf
	
	myscanf a
	myscanf b
	myscanf c

;	myprintf a
;	write new_line,1
;	myprintf b
;	write new_line,1
;	myprintf c
;	write new_line,1

;################ CALCULATING CONSTANTS ##################

BSQR:	finit
	fldz
	fld qword[b]                 ;calculating B Square
	fmul qword[b]
	fstp qword[b2]
;	myprintf b2
;	write new_line,1

FOURAC:	fild qword[four]             ; seq should be this essential  {loading constants intially then multiplication}
	fmul qword[a]
	fmul qword[c]
	fstp qword[fac]              ;calculating 4ac
;	myprintf fac
;	write new_line,1

DELTA:	fld qword[b2]
	fsub qword[fac]              ;calculating b2-4ac
	fstp qword[delta]	
;	myprintf delta
;	write new_line,1

TWOA:	fild qword[two]               ;seq should be this essential  {loading constants intially then multiplication}
	fmul qword[a]                 ;;calculating 2a
	fstp qword[ta]

	btr qword[delta],63           ; this must be here {AFTER CALCULATION OF 2A}
	jc img                        ;
;################ REAL ROOTS ##################
	write m1,l1
	fld qword[delta]                        ;must be calculated each time
	fsqrt
	fstp qword[rdelta]                  

	fldz            		      ;(-b+squareroot(delta))/2a   
	fsub qword[b]
	fadd qword[rdelta]
	fdiv qword[ta]
	fstp qword[r1]
	myprintf r1

	fldz                                 ;(-b-squareroot(delta))/2a
	fsub qword[b]
	fsub qword[rdelta]
	fdiv qword[ta]
	fstp qword[r2]
	myprintf r2

	jmp EXIT

;################ IMAGINARY ROOTS ##################
img:	write m2,l2	
	fld qword[delta]	               ;must be calculated each time {RDELTA}
	fsqrt
	fstp qword[rdelta]

	fldz
	fsub qword[b]                            ;real part of root
	fdiv qword[ta]
	fstp qword[realn]

	fld qword[rdelta]                         ;img part of root
	fdiv qword[ta]
	fstp qword[img1]

;******** printing imag roots *************
	mov rdi,ff1
	sub rsp,8
	movsd xmm0,[realn]
	movsd xmm1,[img1]
	mov rax,2
	call printf
	add rsp,8

	mov rdi,ff2
	sub rsp,8
	movsd  xmm0, [realn]
	movsd xmm1, [img1]
	mov rax,2
	call printf
	add rsp,8

jmp EXIT

EXIT:	mov rax,60
	mov rdi,0
	syscall


;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ nasm -f elf64 p2.asm
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ gcc p2.o -no-pie
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ ./a.out
;1
;2
;3
; IMAGINARY  ROOTS 
;-1.000000 +i (1.414214)
;-1.000000 -i (1.414214)
;(base) chat@chat-HP-Laptop-15-da0xxx:~/Desktop$ 
