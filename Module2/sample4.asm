
;display ascii char 
;this is the data section
section .data

;msg db 65,66,67,10		;ascii char ABC
msg db 0x41,0x42,0x43,0x0A ;hex
msglen equ $ - msg 	;calculate the length 

section .text
global _start

;use constant
SYS_EXIT equ 1
SYS_WRITE equ 4
STDOUT equ 1

_start:
	;write system call (sys_write)
	mov eax,SYS_WRITE	;sys_write
	mov ebx,STDOUT		;stdout
	mov ecx,msg 	;pointer to message
	mov edx,msglen	;message length 
	int 0x80		;invoke the syscall

	;exit system call
	mov eax, SYS_EXIT	;sys_exit 
	xor ebx,ebx		;exit status 0
	int 0x80		;invoke the syscall




