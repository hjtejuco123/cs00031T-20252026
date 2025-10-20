;CMP with JE/JZ after arithmetic operations

section .data
    msg_intro       db "Adding 8 + 12...", 10
    len_intro       equ $ - msg_intro

    msg_target      db "Sum equals 20.", 10
    len_target      equ $ - msg_target

    msg_not_target  db "Sum does not equal 20.", 10
    len_not_target  equ $ - msg_not_target

    msg_zero_diff   db "Difference is zero (sum - 20).", 10
    len_zero_diff   equ $ - msg_zero_diff

    msg_nonzero     db "Difference is non-zero.", 10
    len_nonzero     equ $ - msg_nonzero

section .text
    global _start

_start:
    ; announce arithmetic operation
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov eax, 8              ; first operand
    mov ebx, 12             ; second operand
    add eax, ebx            ; eax = eax + ebx (sum)
    mov esi, eax            ; keep a copy of the sum

    cmp eax, 20             ; compare sum to 20
    je  .sum_equals_target

    ; sum != 20 path
    mov ecx, msg_not_target
    mov edx, len_not_target
    jmp .write_message

.sum_equals_target:
    mov ecx, msg_target
    mov edx, len_target

.write_message:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; check difference using JZ
    mov eax, esi            ; restore sum
    mov ecx, eax            ; ecx = last sum (eax still holds sum)
    sub ecx, 20             ; ecx = sum - 20
    jz  .difference_zero    ; jump if difference is zero

    mov ecx, msg_nonzero
    mov edx, len_nonzero
    jmp .write_diff

.difference_zero:
    mov ecx, msg_zero_diff
    mov edx, len_zero_diff

.write_diff:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
