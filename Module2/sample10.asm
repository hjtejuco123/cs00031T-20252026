section .data

msg1 db 'Hello, Assembly!', 0xa   ; message to display
msg1_len equ $ - msg1       ; length of the message

prompt db 'Enter your name: ', 0    ; prompt message
prompt_len equ $ - prompt     ; length of the prompt

greeting db 'Hello, ', 0       ; greeting message
greeting_len equ $ - greeting          ; length of the greeting

greet_end db '! Welcome to Assembly Programming.', 0xa

greet_end_len equ $ - greet_end        ; length of the end message



section .bss
name resb 32          ; reserve 32 bytes for the name


section .text

    global _start

_start:

    ; Display "Hello, Assembly!"
    mov edx, msg1_len
    mov ecx, msg1
    mov ebx, 1
    mov eax, 4
    int 0x80


    ; Display "Enter your name: "
    mov edx, prompt_len
    mov ecx, prompt
    mov ebx, 1
    mov eax, 4
    int 0x80


    ; Read user input
    mov edx, 32           ; number of bytes to read
    mov ecx, name         ; buffer to store input
    mov ebx, 0            ; file descriptor (stdin)
    mov eax, 3            ; system call number (sys_read)
    int 0x80

    ; Display greeting "Hello, [name]! Welcome to Assembly Programming."

    ; Part 1: Display "Hello, "
    mov edx, greeting_len
    mov ecx, greeting
    mov ebx, 1
    mov eax, 4
    int 0x80


    ; Part 2: Display user input (name)
    ; Reusing the previous read buffer

    mov edx, eax          ; number of bytes read from the previous sys_read

    mov ecx, name
    mov ebx, 1
    mov eax, 4
    int 0x80

    
    ; Part 3: Display " Welcome to Assembly Programming."

    mov edx, greet_end_len
    mov ecx, greet_end
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Exit program
    mov eax, 1
    int 0x80

