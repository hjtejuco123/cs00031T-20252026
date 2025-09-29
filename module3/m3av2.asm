section .data
    value   db 5
    msg     db "Incremented value: "
    msg_len equ $ - msg
    digit   db 0
    newline db 10

section .text
    global _start

_start:
    inc byte [value]

    mov al, [value]
    add al, '0'
    mov [digit], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, digit
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    movzx ebx, byte [value]
    mov eax, 1
    int 0x80
