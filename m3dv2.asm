section .data
    prompt1     db "Enter first digit: "
    prompt1_len equ $ - prompt1
    prompt2     db "Enter second digit: "
    prompt2_len equ $ - prompt2
    result_msg  db "Difference: "
    result_len  equ $ - result_msg
    newline     db 10

section .bss
    input_buf   resb 2
    diff_buf    resb 2

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
    mov esi, eax                ; store first digit

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
    mov edi, eax                ; second digit

    mov eax, esi
    sub eax, edi                ; apply SUB to inputs
    mov esi, eax                ; keep difference for exit status

    mov ebp, 1
    mov edi, diff_buf
    cmp eax, 0
    jge diff_non_negative

    mov byte [edi], '-'
    neg eax
    add al, '0'
    mov [edi + 1], al
    mov ebp, 2
    jmp diff_ready

diff_non_negative:
    add al, '0'
    mov [edi], al

diff_ready:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, diff_buf
    mov edx, ebp
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, esi
    int 0x80
