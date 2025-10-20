; Example using JMP and JNE/JNZ with arithmetic results

section .data
    msg_intro       db "Computing 25 - 15...", 10
    len_intro       equ $ - msg_intro

    msg_expected    db "Result equals 10.", 10
    len_expected    equ $ - msg_expected

    msg_not_equal   db "Result does not equal 10.", 10
    len_not_equal   equ $ - msg_not_equal

    msg_diff_zero   db "Result minus 7 is zero.", 10
    len_diff_zero   equ $ - msg_diff_zero

    msg_diff_nonzero db "Result minus 7 is not zero.", 10
    len_diff_nonzero equ $ - msg_diff_nonzero

    msg_done        db "Done.", 10
    len_done        equ $ - msg_done

section .text
    global _start

_start:
    ; announce calculation
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov eax, 25
    sub eax, 15          ; eax = 10
    mov esi, eax         ; preserve arithmetic result

    cmp esi, 10
    jne .not_equal       ; jump if result != 10

    mov ecx, msg_expected
    mov edx, len_expected
    jmp .write_first

.not_equal:
    mov ecx, msg_not_equal
    mov edx, len_not_equal

.write_first:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, esi
    sub eax, 7           ; eax holds result - 7
    jnz .difference_nonzero  ; jump if subtraction != 0

    mov ecx, msg_diff_zero
    mov edx, len_diff_zero
    jmp .write_second

.difference_nonzero:
    mov ecx, msg_diff_nonzero
    mov edx, len_diff_nonzero

.write_second:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_done
    mov edx, len_done
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
