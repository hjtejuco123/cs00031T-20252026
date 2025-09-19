
;display ascii char 
;this is the data section
section .data

msg db 65,66,67		;ascii char ABC
msglen equ $ - msg 	;calculate the length 

section .text
global _start

_start:
	;write system call (sys_write)
	mov eax,4		;sys_write
	mov ebx,1		;stdout
	mov ecx,msg 	;pointer to message
	mov edx,msglen	;message length 
	int 0x80		;invoke the syscall

	;exit system call
	mov eax, 1		;sys_exit 
	xor ebx,ebx		;exit status 0
	int 0x80		;invoke the syscall




