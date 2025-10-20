; Example demonstrating AAM (ASCII Adjust after Multiply)
; Scenario: a student multiplies 4 project points by 6 bonus stickers.

section .data
    msg_intro       db "Points check: multiplying 4 x 6 using AAM.", 10
    len_intro       equ $ - msg_intro

    msg_tens_label  db "Tens digit: "
    len_tens_label  equ $ - msg_tens_label

    msg_ones_label  db "Ones digit: "
    len_ones_label  equ $ - msg_ones_label

    msg_total_label db "Total reward shown as digits: "
    len_total_label equ $ - msg_total_label

    tens_value      db '0', 10
    ones_value      db '0', 10
    total_value     db '0', '0', 10

section .text
    global _start

_start:
    ; intro
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov al, 4
    mov bl, 6
    mul bl                ; AX = 24 (decimal)

    aam                   ; AH = 2, AL = 4 (unpacked BCD)

    add al, '0'
    add ah, '0'

    mov byte [ones_value], al
    mov byte [tens_value], ah

    mov al, ah
    mov byte [total_value], al
    mov al, [ones_value]
    mov byte [total_value + 1], al

    ; print tens digit
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_tens_label
    mov edx, len_tens_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, tens_value
    mov edx, 2
    int 0x80

    ; print ones digit
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_ones_label
    mov edx, len_ones_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, ones_value
    mov edx, 2
    int 0x80

    ; print final total
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_total_label
    mov edx, len_total_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, total_value
    mov edx, 3
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
