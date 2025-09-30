section .data
    dividend    dd 9                  ; dividend used for division
    divisor     dd 2                  ; divisor used for division
    msg_quot    db "Quotient: "
    msg_quot_len equ $ - msg_quot
    msg_rem     db "Remainder: "
    msg_rem_len equ $ - msg_rem
    newline     db 10

section .bss
    quotient_ch resb 1                ; holds printable quotient
    remainder_ch resb 1               ; holds printable remainder

section .text
    global _start

_start:
    mov eax, [dividend]               ; load dividend into EAX
    xor edx, edx                      ; clear upper word for division
    mov ebx, [divisor]                ; load divisor into EBX
    div ebx                           ; unsigned divide: quotient->EAX, remainder->EDX

    add al, '0'                       ; convert quotient to ASCII digit
    add dl, '0'                       ; convert remainder to ASCII digit
    mov [quotient_ch], al
    mov [remainder_ch], dl

    ; print "Quotient: X"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_quot
    mov edx, msg_quot_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, quotient_ch
    mov edx, 1
    int 0x80

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; print "Remainder: Y"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_rem
    mov edx, msg_rem_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, remainder_ch
    mov edx, 1
    int 0x80

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80
