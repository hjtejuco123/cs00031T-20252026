; sam3m5.asm
; Demonstrates procedure calls with user input. The program prompts for a name,
; reads it from stdin, then prints "Hello, <name>!" using separate routines for
; prompting, reading, and composing the greeting. Line comments explain the data
; layout, register usage, and control flow through each procedure.

section .data
prompt_message     db "Enter your name: "
prompt_length      equ $ - prompt_message
greet_prefix       db "Hello, "
greet_prefix_len   equ $ - greet_prefix
greet_suffix       db "!", 10
greet_suffix_len   equ $ - greet_suffix

section .bss
input_buffer       resb 64          ; holds the raw user input including newline
buffer_length      equ 64

section .text
global _start

_start:
    call print_prompt
    call read_input               ; EAX returns number of bytes read
    mov esi, eax                  ; pass line length to greeting printer
    call print_greeting

    ; Exit program
    mov eax, 1                    ; sys_exit
    xor ebx, ebx                  ; exit status 0
    int 0x80

; Procedure: print the prompt message
print_prompt:
    mov eax, 4                    ; sys_write
    mov ebx, 1                    ; stdout
    mov ecx, prompt_message
    mov edx, prompt_length
    int 0x80
    ret

; Procedure: read user input into buffer
; Returns: EAX = number of bytes read
read_input:
    mov eax, 3                    ; sys_read
    xor ebx, ebx                  ; stdin
    mov ecx, input_buffer
    mov edx, buffer_length
    int 0x80
    ret

; Procedure: print greeting with user input
; Expects: ESI = number of bytes captured in input_buffer
print_greeting:
    push esi                      ; preserve length across prefix write

    ; Write greeting prefix
    mov eax, 4
    mov ebx, 1
    mov ecx, greet_prefix
    mov edx, greet_prefix_len
    int 0x80

    pop esi                       ; restore input length
    mov ecx, input_buffer
    mov edx, esi

    ; Trim trailing newline if present
    cmp edx, 0
    jle .skip_name
    mov bl, [ecx + edx - 1]       ; inspect last character from read buffer
    cmp bl, 10                    ; ASCII LF from pressing Enter?
    jne .write_name
    dec edx                       ; ignore newline so it doesn't appear in greeting

.write_name:
    cmp edx, 0
    jle .skip_name                ; skip if nothing remains after trimming
    mov eax, 4
    mov ebx, 1
    int 0x80

.skip_name:
    ; Write suffix and newline
    mov eax, 4
    mov ebx, 1
    mov ecx, greet_suffix
    mov edx, greet_suffix_len
    int 0x80
    ret
