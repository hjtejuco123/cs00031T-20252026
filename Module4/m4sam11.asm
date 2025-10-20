; Example using the LOOP instruction

section .data
    msg_header  db "Counting down using LOOP:", 10
    len_header  equ $ - msg_header

    msg_value   db "Value: "
    len_value   equ $ - msg_value

    digit_buf   db '0', 10
    len_digit   equ $ - digit_buf

    msg_done    db "Loop finished.", 10
    len_done    equ $ - msg_done

section .text
    global _start

_start:
    ; print header
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_header
    mov edx, len_header
    int 0x80

    mov ecx, 5              ; start counter at 5 iterations

.loop_start:
    cmp ecx, 0
    je  .loop_done

    ; print static label
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_value
    mov edx, len_value
    int 0x80
    pop ecx

    ; show current counter value (loop decrements ECX after this body)
    mov eax, ecx
    add eax, '0'
    mov [digit_buf], al

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, digit_buf
    mov edx, len_digit
    int 0x80
    pop ecx

    loop .loop_start        ; dec ECX and jump if ECX != 0
    jmp .loop_done

.loop_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_done
    mov edx, len_done
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
