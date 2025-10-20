; case-insensitive input handling with CMP
; that accepts both lowercase and uppercase 'y'/'n'.

section .data
    prompt      db "Enter y or n: "
    len_prompt  equ $ - prompt

    msg_yes     db "You entered yes.", 10
    len_yes     equ $ - msg_yes

    msg_no      db "You entered no.", 10
    len_no      equ $ - msg_no

    msg_other   db "Input not recognized.", 10
    len_other   equ $ - msg_other

section .bss
    buffer resb 2             ; store input char + newline

section .text
    global _start

_start:
    ; write prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, len_prompt
    int 0x80

    ; read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2
    int 0x80

    mov al, [buffer]
    or  al, 0x20              ; force lowercase for alphabetic characters

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
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
