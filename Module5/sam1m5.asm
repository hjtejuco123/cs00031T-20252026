section .data
    hello_message db 'Hello, '
    hello_length equ $ - hello_message
    world_message db 'World!',0xA ; with newline character
    world_length equ $ - world_message
section .text
; Procedure to print "Hello, "
print_hello:
    ; Load the file descriptor (stdout) into ebx
    mov ebx, 1
    ; Load the address of hello_message into ecx
    mov ecx, hello_message
    ; Load the length of the message into edx
    mov edx, hello_length
    ; sys_write system call
    mov eax, 4
    int 0x80
    ret
; Procedure to print "World!"
print_world:
    ; Load the file descriptor (stdout) into ebx
    mov ebx, 1
    ; Load the address of world_message into ecx
    mov ecx, world_message
    ; Load the length of the message into edx
    mov edx, world_length
    ; sys_write system call
    mov eax, 4
    int 0x80
    ret
; Entry point of the program
global _start
_start:
    ; Call the procedures
    call print_hello
    call print_world
    ; Terminate the program using sys_exit
    ; Load the exit status into ebx (0 for success)
    mov ebx, 0
    ; sys_exit system call
    mov eax, 1
    int 0x80
