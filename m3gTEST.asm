
section .data
    value      db 6                    ; value to test
    mask       db 4                    ; bit mask to test against
    msg_value  db "Value = ", '0', 10
    msg_value_len equ $ - msg_value
    msg_mask   db "Mask  = ", '0', 10
    msg_mask_len  equ $ - msg_mask
    msg_true   db "Bit is set", 10
    msg_true_len equ $ - msg_true
    msg_false  db "Bit is clear", 10
    msg_false_len equ $ - msg_false

section .text
    global _start

_start:
    ; Patch digits for value and mask (single-digit for simplicity)
    movzx eax, byte [value]
    add al, '0'
    mov [msg_value + 8], al

    movzx eax, byte [mask]
    add al, '0'
    mov [msg_mask + 8], al

    ; Print the value and mask
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_value
    mov edx, msg_value_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_mask
    mov edx, msg_mask_len
    int 0x80

    ; Perform TEST to check if mask bit is set in value
    mov al, [value]
    mov bl, [mask]
    test al, bl

    jz .bit_clear

    ; if nonzero -> bit set
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_true
    mov edx, msg_true_len
    int 0x80
    jmp .exit

.bit_clear:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_false
    mov edx, msg_false_len
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
