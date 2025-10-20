; example using macros with user input
; Prompt a student to log their mood before studying.

%macro PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro PRINT_LINE 2
    PRINT %1, %2
    PRINT newline, newline_len
%endmacro

%macro READ_INPUT 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    welcome_msg     db "Study mood tracker"
    welcome_len     equ $ - welcome_msg

    prompt_msg      db "How are you feeling before studying? (h = hyped, c = calm): "
    prompt_len      equ $ - prompt_msg

    msg_hyped       db "Awesome! Channel that energy into your practice problems.", 10
    msg_hyped_len   equ $ - msg_hyped

    msg_calm        db "Nice! A calm mind makes reviewing notes smoother.", 10
    msg_calm_len    equ $ - msg_calm

    msg_other       db "Thanks for sharing—remember every day is progress!", 10
    msg_other_len   equ $ - msg_other

    newline         db 10
    newline_len     equ $ - newline

section .bss
    input_buf       resb 4      ; store input + newline

section .text
    global _start

_start:
    PRINT_LINE welcome_msg, welcome_len

    PRINT prompt_msg, prompt_len
    READ_INPUT input_buf, 4

    mov al, [input_buf]
    or  al, 0x20               ; normalize to lowercase if letter

    cmp al, 'h'
    je  .feeling_hyped
    cmp al, 'c'
    je  .feeling_calm

    PRINT msg_other, msg_other_len
    jmp .exit_program

.feeling_hyped:
    PRINT msg_hyped, msg_hyped_len
    jmp .exit_program

.feeling_calm:
    PRINT msg_calm, msg_calm_len

.exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
