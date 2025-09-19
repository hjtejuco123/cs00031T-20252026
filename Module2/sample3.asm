;text 
msg1 db 'Hello programmers!',0xA,0xD
len1 equ $ - msg1

msg2 db 'I love assembly programming',0xA,0xD
len2 equ $ - msg2

section .text
global _start

_start:

	mov eax,4	;sys_write
	mov ebx,1 	;stdout 
	mov ecx,msg1
	mov edx,len1
	int 0x80

	mov eax,4	;sys_write
	mov ebx,1 	;stdout 
	mov ecx,msg2
	mov edx,len2
	int 0x80

	mov eax,1
	xor ebx,ebx
	int 0x80
