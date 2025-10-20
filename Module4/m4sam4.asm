; Prompt for day number and print the weekday using CMP

section .data
    prompt      db "Enter day number (1-7): ", 0
    len_prompt  equ $ - prompt

    msg_mon     db "Monday", 10
    len_mon     equ $ - msg_mon
    msg_tue     db "Tuesday", 10
    len_tue     equ $ - msg_tue
    msg_wed     db "Wednesday", 10
    len_wed     equ $ - msg_wed
    msg_thu     db "Thursday", 10
    len_thu     equ $ - msg_thu
    msg_fri     db "Friday", 10
    len_fri     equ $ - msg_fri
    msg_sat     db "Saturday", 10
    len_sat     equ $ - msg_sat
    msg_sun     db "Sunday", 10
    len_sun     equ $ - msg_sun

    msg_invalid db "Invalid day.", 10
    len_invalid equ $ - msg_invalid

section .bss
    buffer resb 3              ; digit + optional newline + padding

section .text
    global _start

_start:
    ; prompt user
    mov eax, 4                 ; write
    mov ebx, 1
    mov ecx, prompt
    mov edx, len_prompt
    int 0x80

    ; read input
    mov eax, 3                 ; read
    mov ebx, 0
    mov ecx, buffer
    mov edx, 3
    int 0x80

    mov al, [buffer]
    cmp al, '1'
    je  .day_mon
    cmp al, '2'
    je  .day_tue
    cmp al, '3'
    je  .day_wed
    cmp al, '4'
    je  .day_thu
    cmp al, '5'
    je  .day_fri
    cmp al, '6'
    je  .day_sat
    cmp al, '7'
    je  .day_sun

    mov ecx, msg_invalid
    mov edx, len_invalid
    jmp .write_response

.day_mon:
    mov ecx, msg_mon
    mov edx, len_mon
    jmp .write_response

.day_tue:
    mov ecx, msg_tue
    mov edx, len_tue
    jmp .write_response

.day_wed:
    mov ecx, msg_wed
    mov edx, len_wed
    jmp .write_response

.day_thu:
    mov ecx, msg_thu
    mov edx, len_thu
    jmp .write_response

.day_fri:
    mov ecx, msg_fri
    mov edx, len_fri
    jmp .write_response

.day_sat:
    mov ecx, msg_sat
    mov edx, len_sat
    jmp .write_response

.day_sun:
    mov ecx, msg_sun
    mov edx, len_sun

.write_response:
    mov eax, 4                 ; write
    mov ebx, 1
    int 0x80

.exit:
    mov eax, 1                 ; exit
    xor ebx, ebx
    int 0x80
