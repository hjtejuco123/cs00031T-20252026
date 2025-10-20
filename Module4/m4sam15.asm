; Example demonstrating AAD (ASCII Adjust before Division)
; Scenario: a student enters tens and ones digits separately for a score.

section .data
    msg_intro        db "Planner update: combining tens and ones using AAD.", 10
    len_intro        equ $ - msg_intro

    msg_input_hdr    db "Digits entered (AH=tens, AL=ones):", 10
    len_input_hdr    equ $ - msg_input_hdr

    msg_tens_label   db "  Tens digit: "
    len_tens_label   equ $ - msg_tens_label

    msg_ones_label   db "  Ones digit: "
    len_ones_label   equ $ - msg_ones_label

    msg_result_label db "Combined decimal value after AAD: "
    len_result_label equ $ - msg_result_label

    msg_closing      db "All set! Score stored as a single number.", 10
    len_closing      equ $ - msg_closing

    tens_value       db '0', 10
    ones_value       db '0', 10
    result_value     db '0', '0', 10

section .text
    global _start

_start:
    ; intro
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov ah, 2                 ; tens digit
    mov al, 3                 ; ones digit

    mov bl, ah
    add bl, '0'
    mov byte [tens_value], bl

    mov bl, al
    add bl, '0'
    mov byte [ones_value], bl

    ; display digits before combining
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_input_hdr
    mov edx, len_input_hdr
    int 0x80

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

    ; combine digits: AAD converts AH*10 + AL into AL (binary)
    aad

    mov ah, 0                ; prepare AX for division
    mov bl, 10
    div bl                   ; AL=quotient (tens), AH=remainder (ones)

    add al, '0'
    add ah, '0'

    mov byte [result_value], al
    mov byte [result_value + 1], ah

    ; display combined value
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result_label
    mov edx, len_result_label
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, result_value
    mov edx, 3
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_closing
    mov edx, len_closing
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
