; Read a digit and compare with a target value using CMP

section .data
    prompt      db "Enter a digit (0-9): ", 0
    len_prompt  equ $ - prompt

    msg_low     db "Digit is less than 5.", 10
    len_low     equ $ - msg_low

    msg_equal   db "Digit equals 5.", 10
    len_equal   equ $ - msg_equal

    msg_high    db "Digit is greater than 5.", 10
    len_high    equ $ - msg_high

    msg_invalid db "Invalid input.", 10
    len_invalid equ $ - msg_invalid

section .bss
    buffer resb 2             ; capture digit + newline

section .text
    global _start

_start:
    ; write prompt
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; stdout
    mov ecx, prompt
    mov edx, len_prompt
    int 0x80

    ; read user input
    mov eax, 3                ; syscall: read
    mov ebx, 0                ; stdin
    mov ecx, buffer
    mov edx, 2
    int 0x80

    mov al, [buffer]          ; load character
    cmp al, '0'               ; ensure >= '0'
    jl  .invalid_input

    cmp al, '9'               ; ensure <= '9'
    jg  .invalid_input

    cmp al, '5'
    je  .equal_case
    jl  .low_case

    ; al > '5'
    mov ecx, msg_high
    mov edx, len_high
    jmp .write_response

.low_case:
    mov ecx, msg_low
    mov edx, len_low
    jmp .write_response

.equal_case:
    mov ecx, msg_equal
    mov edx, len_equal
    jmp .write_response

.invalid_input:
    mov ecx, msg_invalid
    mov edx, len_invalid

.write_response:
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; stdout
    int 0x80

.exit:
    mov eax, 1                ; syscall: exit
    xor ebx, ebx              ; exit code 0
    int 0x80
