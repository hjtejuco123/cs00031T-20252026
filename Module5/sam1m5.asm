; sam1m5.asm
; Minimal sample showing how to break simple output into procedures. The program
; prints "Hello, World!" by calling two routines that wrap `sys_write`. Comments
; describe the data layout and register/setup used for each call.

section .data
    hello_message db 'Hello, '
    hello_length equ $ - hello_message
    world_message db 'World!', 10  ; include newline character
    world_length equ $ - world_message

section .text
; Procedure to print "Hello, "
print_hello:
    mov ebx, 1            ; stdout file descriptor
    mov ecx, hello_message
    mov edx, hello_length
    mov eax, 4            ; sys_write
    int 0x80
    ret

; Procedure to print "World!\n"
print_world:
    mov ebx, 1            ; stdout file descriptor
    mov ecx, world_message
    mov edx, world_length
    mov eax, 4            ; sys_write
    int 0x80
    ret

; Entry point of the program
global _start
_start:
    call print_hello
    call print_world

    mov ebx, 0            ; exit status 0
    mov eax, 1            ; sys_exit
    int 0x80
