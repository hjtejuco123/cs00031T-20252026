
section .data
    value          db 0x3C                 ; byte to invert
    msg_value      db "Value = ", '0', '0', 10
    msg_value_len  equ $ - msg_value
    msg_not        db "NOT value = ", '0', '0', 10
    msg_not_len    equ $ - msg_not

section .text
    global _start

_start:
    mov al, [value]
    mov edi, msg_value + 8             ; fill hex digits in message
    call byte_to_hex

    ; Compute NOT and store in message template
    mov al, [value]
    not al
    mov edi, msg_not + 12
    call byte_to_hex

    ; Print original value line
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_value
    mov edx, msg_value_len
    int 0x80

    ; Print NOT result line
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_not
    mov edx, msg_not_len
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80

; byte_to_hex
;   AL: byte to convert
;   EDI: destination for two ASCII hex characters
byte_to_hex:
    push ebx
    mov bl, al

    mov dl, bl
    shr dl, 4
    call nibble_to_char
    mov [edi], dl
    inc edi

    mov dl, bl
    and dl, 0x0F
    call nibble_to_char
    mov [edi], dl
    inc edi

    pop ebx
    ret

; nibble_to_char: convert lower 4 bits of DL to ASCII hex digit
nibble_to_char:
    cmp dl, 9
    jbe .digit
    add dl, 'A' - 10
    ret
.digit:
    add dl, '0'
    ret
