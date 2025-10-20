; Example demonstrating AAA (ASCII Adjust after Addition)
; Scenario: a student adds two quiz digits (4 + 7) and wants decimal digits.

section .data
    msg_intro       db "Math drill: adding quiz digits 4 + 7 using AAA.", 10
    len_intro       equ $ - msg_intro

    msg_tens_label  db "Tens digit (carry): "
    len_tens_label  equ $ - msg_tens_label

    msg_ones_label  db "Ones digit: "
    len_ones_label  equ $ - msg_ones_label

    msg_total_label db "Final sum shown as digits: "
    len_total_label equ $ - msg_total_label

    tens_value      db '0', 10
    ones_value      db '0', 10
    total_value     db '0', '0', 10

section .text
    global _start

_start:
    ; intro message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    ; prepare digits as BCD values in AL
    xor ax, ax
    mov al, '4'
    sub al, '0'
    mov bl, '7'
    sub bl, '0'
    add al, bl                ; add digits together (AL now holds sum)

    aaa                       ; adjust AL/AH to unpacked BCD digits

    add al, '0'               ; convert ones digit to ASCII
    add ah, '0'               ; convert tens digit to ASCII

    mov byte [ones_value], al
    mov byte [tens_value], ah

    mov al, ah
    mov byte [total_value], al
    mov al, [ones_value]
    mov byte [total_value + 1], al

    ; show tens digit
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_tens_label
    mov edx, len_tens_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, tens_value
    mov edx, 2               ; character plus newline
    int 0x80

    ; show ones digit
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

    ; show full result
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_total_label
    mov edx, len_total_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, total_value
    mov edx, 3               ; two digits plus newline
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
