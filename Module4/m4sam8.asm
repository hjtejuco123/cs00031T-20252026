; Example using JMP with JG/JNLE after arithmetic operations

section .data
    msg_intro       db "Evaluating 30 - 18...", 10
    len_intro       equ $ - msg_intro

    msg_greater     db "Result is greater than 10.", 10
    len_greater     equ $ - msg_greater

    msg_not_greater db "Result is 10 or less.", 10
    len_not_greater equ $ - msg_not_greater

    msg_final       db "Finished check.", 10
    len_final       equ $ - msg_final

section .text
    global _start

_start:
    ; announce arithmetic
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov eax, 30
    sub eax, 18              ; eax = 12
    mov esi, eax             ; preserve result

    cmp esi, 10
    jg  .greater_than_ten    ; Jump if result > 10
    jmp .not_greater

.greater_than_ten:
    mov ecx, msg_greater
    mov edx, len_greater
    jmp .write_outcome

.not_greater:
    cmp esi, 10
    jnle .greater_than_ten   ; Demonstrate JNLE (same as JG)

    mov ecx, msg_not_greater
    mov edx, len_not_greater

.write_outcome:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; final message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_final
    mov edx, len_final
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
