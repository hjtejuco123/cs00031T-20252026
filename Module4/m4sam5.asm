; Prints a countdown using CMP/JMP to control loop flow.

section .data
    msg_start   db "Starting countdown", 10
    len_start   equ $ - msg_start

    msg_counter db "Counter: "
    len_counter equ $ - msg_counter

    value_char  db '0', 10     ; digit placeholder + newline
    len_value   equ $ - value_char

    msg_done    db "Loop done", 10
    len_done    equ $ - msg_done

section .text
    global _start

_start:
    ; write start message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_start
    mov edx, len_start
    int 0x80

    mov edi, 3              ; countdown start value

.loop_top:
    ; show "Counter: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_counter
    mov edx, len_counter
    int 0x80

    ; convert counter to ASCII and write
    mov eax, edi
    add eax, '0'
    mov [value_char], al

    mov eax, 4
    mov ebx, 1
    mov ecx, value_char
    mov edx, len_value
    int 0x80

    dec edi                 ; decrement counter
    cmp edi, 0
    jg  .loop_top           ; continue while > 0

    ; final message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_done
    mov edx, len_done
    int 0x80

    mov eax, 1              ; exit
    xor ebx, ebx
    int 0x80
