; Example showing how to build and use %macro / %endmacro
; Scenario: create a simple checklist printer with reusable print macros.

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

section .data
    header_msg      db "Checklist for the day:", 10
    header_len      equ $ - header_msg

    task1_msg       db "- Finish math homework", 0
    task1_len       equ $ - task1_msg - 1

    task2_msg       db "- Review science notes", 0
    task2_len       equ $ - task2_msg - 1

    task3_msg       db "- Practice coding exercises", 0
    task3_len       equ $ - task3_msg - 1

    closing_msg     db "Great job keeping organized!", 10
    closing_len     equ $ - closing_msg

    newline         db 10
    newline_len     equ $ - newline

section .text
    global _start

_start:
    ; header already includes newline
    PRINT header_msg, header_len

    PRINT_LINE task1_msg, task1_len
    PRINT_LINE task2_msg, task2_len
    PRINT_LINE task3_msg, task3_len

    PRINT closing_msg, closing_len

    mov eax, 1
    xor ebx, ebx
    int 0x80
