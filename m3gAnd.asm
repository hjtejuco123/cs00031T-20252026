section .data
    value_a        db 6               ; first operand (0-9 for simple ASCII conversion)
    value_b        db 3               ; second operand (0-9)
    msg_a          db "A = ", '0', 10
    msg_a_len      equ $ - msg_a
    msg_b          db "B = ", '0', 10
    msg_b_len      equ $ - msg_b
    msg_result     db "A AND B = ", '0', 10
    msg_result_len equ $ - msg_result

section .text
    global _start

_start:
    ; Load operands
    movzx eax, byte [value_a]
    movzx ebx, byte [value_b]

    ; Update message strings with operand values
    mov ecx, eax
    add cl, '0'
    mov [msg_a + 4], cl

    mov ecx, ebx
    add cl, '0'
    mov [msg_b + 4], cl

    ; Perform AND and store result in message
    mov ecx, eax
    and ecx, ebx
    add cl, '0'
    mov [msg_result + 10], cl

    ; Print messages
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_a
    mov edx, msg_a_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_b
    mov edx, msg_b_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result
    mov edx, msg_result_len
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
