section .data
    prompt1     db "Enter first digit: "
    prompt1_len equ $ - prompt1
    prompt2     db "Enter second digit: "
    prompt2_len equ $ - prompt2
    result_msg  db "Sum: "
    result_len  equ $ - result_msg
    newline     db 10

section .bss
    input_buf   resb 2
    sum_buf     resb 2

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 2
    int 0x80

    movzx eax, byte [input_buf]
    sub eax, '0'
    mov edi, eax                ; keep first input

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 2
    int 0x80

    movzx eax, byte [input_buf]
    sub eax, '0'
    add eax, edi                ; apply ADD to combine inputs
    mov esi, eax                ; preserve sum for exit

    cmp eax, 9
    jg two_digits

    add al, '0'
    mov [sum_buf], al
    mov edi, 1
    jmp print_result

two_digits:
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    mov [sum_buf], al
    mov al, dl
    add al, '0'
    mov [sum_buf + 1], al
    mov edi, 2

print_result:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, sum_buf
    mov edx, edi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, esi
    int 0x80
