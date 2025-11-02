; sam6m5.asm
; Combines reusable macros with file I/O and user input.
; Flow:
;   1. Prompt for a short note.
;   2. Display the note back to the user.
;   3. Write the note (with newline) into a text file.
;   4. Re-read the file and echo its contents.

; Macro helpers wrap int 0x80 syscalls so the call sites stay concise.
%macro SYS_WRITE 3
    ; %1 = file descriptor, %2 = buffer address, %3 = byte length
    mov eax, 4
    mov ebx, %1
    mov ecx, %2
    mov edx, %3
    int 0x80
%endmacro

%macro SYS_READ 3
    ; %1 = file descriptor, %2 = buffer address, %3 = max bytes to read
    mov eax, 3
    mov ebx, %1
    mov ecx, %2
    mov edx, %3
    int 0x80
%endmacro

%macro SYS_EXIT 1
    ; %1 = exit status code
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

section .data
    filename        db "notes.txt", 0         ; target file for the saved note
    prompt_msg      db "Enter a short note (max 80 chars): "
    prompt_len      equ $ - prompt_msg
    echo_msg        db "You typed: ", 0       ; null terminator trims from printed slice
    echo_len        equ $ - echo_msg - 1
    saved_msg       db 10, "Saved to notes.txt:", 10
    saved_len       equ $ - saved_msg
    newline         db 10                     ; spare newline if future expansion needs it

section .bss
    input_buf       resb 81                   ; note + trailing newline + zero padding
    file_buf        resb 128                  ; scratch buffer for file readback

section .text
    global _start

_start:
    ; Prompt user and capture input line
    SYS_WRITE 1, prompt_msg, prompt_len
    SYS_READ 0, input_buf, 81
    mov esi, eax                           ; remember byte count from stdin

    ; Echo the typed message back immediately
    SYS_WRITE 1, echo_msg, echo_len
    SYS_WRITE 1, input_buf, esi

    ; Create/truncate file and write input
    mov eax, 8                             ; sys_creat
    mov ebx, filename
    mov ecx, 0777o                         ; rwxrwxrwx (octal literal)
    int 0x80
    mov ebp, eax                           ; store new file descriptor

    mov eax, 4                             ; sys_write
    mov ebx, ebp
    mov ecx, input_buf
    mov edx, esi
    int 0x80

    mov eax, 6                             ; sys_close
    mov ebx, ebp
    int 0x80

    ; Reopen file for reading
    mov eax, 5                             ; sys_open
    mov ebx, filename
    mov ecx, 0                             ; O_RDONLY
    int 0x80
    mov ebp, eax

    SYS_READ ebp, file_buf, 128
    mov edi, eax                           ; length read

    ; Show confirmation plus the contents fetched from disk
    SYS_WRITE 1, saved_msg, saved_len
    SYS_WRITE 1, file_buf, edi

    SYS_EXIT 0
