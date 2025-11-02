; sam2m5.asm
; Sample that separates prompting, input, and echoing into procedural calls.
; The user types a single character, which is echoed back with a short label.
; Comments highlight the syscall setup and data usage in each stage.

section .data
    prompt_message db "Enter a number (0-9): ", 0
    result_message db "You entered: ", 0
    newline db 10, 0             ; newline terminator for output

section .bss
    input_char resb 1            ; single-byte buffer for user input

section .text
    global _start

_start:
    call display_prompt
    call get_input
    call display_result
    call exit_program

; Subroutine: display_prompt
display_prompt:
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, prompt_message
    mov edx, 21                 ; literal length of prompt string
    int 0x80
    ret

; Subroutine: get_input
get_input:
    mov eax, 3                  ; sys_read
    xor ebx, ebx                ; stdin
    mov ecx, input_char
    mov edx, 1                  ; read exactly one byte
    int 0x80
    ret

; Subroutine: display_result
display_result:
    mov eax, 4                  ; sys_write for label
    mov ebx, 1
    mov ecx, result_message
    mov edx, 13                 ; literal length of label
    int 0x80

    mov eax, 4                  ; write the captured character
    mov ebx, 1
    mov ecx, input_char
    mov edx, 1
    int 0x80

    mov eax, 4                  ; terminate with newline
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

; Subroutine: exit_program
exit_program:
    mov eax, 1                  ; sys_exit
    xor ebx, ebx                ; exit code 0
    int 0x80
    ret
    
