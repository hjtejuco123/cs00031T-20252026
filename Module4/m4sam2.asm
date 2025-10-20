; Read a character from stdin, compare it using CMP

section .data
    prompt      db "Enter y or n: ", 0
    len_prompt  equ $ - prompt

    msg_yes     db "You entered yes.", 10
    len_yes     equ $ - msg_yes

    msg_no      db "You entered no.", 10
    len_no      equ $ - msg_no

    msg_other   db "Input not recognized.", 10
    len_other   equ $ - msg_other

section .bss
    buffer resb 2           ; store input + newline

section .text
    global _start

_start:
    ; write prompt
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; stdout
    mov ecx, prompt
    mov edx, len_prompt
    int 0x80

    ; read user input (up to 2 bytes to capture char + newline)
    mov eax, 3              ; syscall: read
    mov ebx, 0              ; stdin
    mov ecx, buffer
    mov edx, 2
    int 0x80

    ; compare first character
    mov al, [buffer]
    cmp al, 'y'
    je  .handle_yes

    cmp al, 'n'
    je  .handle_no

    mov ecx, msg_other
    mov edx, len_other
    jmp .write_response

.handle_yes:
    mov ecx, msg_yes
    mov edx, len_yes
    jmp .write_response

.handle_no:
    mov ecx, msg_no
    mov edx, len_no

.write_response:
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; stdout
    int 0x80

.exit:
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; exit code 0
    int 0x80
