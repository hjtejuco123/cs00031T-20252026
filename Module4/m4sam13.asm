; Example demonstrating AAS (ASCII Adjust after Subtraction)
; Scenario: a student double-checks 5 - 8 and sees the borrow in action.

section .data
    msg_intro        db "Math drill: subtracting quiz digits 5 - 8 using AAS.", 10
    len_intro        equ $ - msg_intro

    msg_ones_label   db "Ones digit after borrow: "
    len_ones_label   equ $ - msg_ones_label

    msg_borrow_yes   db "Borrow happened (carry flag set).", 10
    len_borrow_yes   equ $ - msg_borrow_yes

    msg_borrow_no    db "No borrow needed.", 10
    len_borrow_no    equ $ - msg_borrow_no

    ones_value       db '0', 10

section .text
    global _start

_start:
    ; intro
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    xor ax, ax
    mov al, '5'
    sub al, '0'
    mov bl, '8'
    sub bl, '0'
    sub al, bl            ; perform subtraction: 5 - 8

    aas                   ; adjust result into unpacked BCD

    add al, '0'           ; ASCII for ones digit
    mov byte [ones_value], al

    ; report ones digit
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

    ; explain borrow status (carry flag acts as borrow flag here)
    jc  .borrow_needed

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_borrow_no
    mov edx, len_borrow_no
    int 0x80
    jmp .exit_program

.borrow_needed:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_borrow_yes
    mov edx, len_borrow_yes
    int 0x80

.exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
