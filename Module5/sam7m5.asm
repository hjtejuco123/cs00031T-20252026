; sam7m5.asm
; Procedure-based variant of the user-input/file logger:
;   - prompts for basic info (name and favorite subject),
;   - echoes it back to stdout,
;   - saves the formatted data to a file with 0777 permissions,
;   - reopens the file and displays its contents.
; Each helper procedure wraps a specific syscall so the control flow is easy to
; follow when reading `_start`.

NAME_MAX        equ 80
SUBJECT_MAX     equ 80

section .data
    filename            db "basic_info.txt", 0
    intro_msg           db "Basic info logger", 10
    intro_len           equ $ - intro_msg
    name_prompt         db "Enter your name: "
    name_prompt_len     equ $ - name_prompt
    subject_prompt      db "Enter your favorite subject: "
    subject_prompt_len  equ $ - subject_prompt
    summary_msg         db 10, "Summary:", 10
    summary_len         equ $ - summary_msg
    name_label          db "Name: "
    name_label_len      equ $ - name_label
    subject_label       db "Favorite subject: "
    subject_label_len   equ $ - subject_label
    file_msg            db 10, "File contents:", 10
    file_msg_len        equ $ - file_msg
    newline             db 10
    newline_len         equ 1

section .bss
    name_buf        resb NAME_MAX + 1
    subject_buf     resb SUBJECT_MAX + 1
    name_len        resd 1
    subject_len     resd 1
    file_buf        resb 256

section .text
    global _start

_start:
    ; Intro banner
    mov ecx, intro_msg
    mov edx, intro_len
    call print_stdout

    ; Ask for name
    mov ecx, name_prompt
    mov edx, name_prompt_len
    call print_stdout

    mov ecx, name_buf
    mov edx, NAME_MAX + 1
    call read_stdin
    mov [name_len], eax
    mov ecx, name_buf
    mov eax, [name_len]
    call trim_newline
    mov [name_len], eax

    ; Ask for favorite subject
    mov ecx, subject_prompt
    mov edx, subject_prompt_len
    call print_stdout

    mov ecx, subject_buf
    mov edx, SUBJECT_MAX + 1
    call read_stdin
    mov [subject_len], eax
    mov ecx, subject_buf
    mov eax, [subject_len]
    call trim_newline
    mov [subject_len], eax

    ; Echo summary to stdout
    mov ecx, summary_msg
    mov edx, summary_len
    call print_stdout

    mov ecx, name_label
    mov edx, name_label_len
    call print_stdout
    mov ecx, name_buf
    mov edx, [name_len]
    call print_stdout
    mov ecx, newline
    mov edx, newline_len
    call print_stdout

    mov ecx, subject_label
    mov edx, subject_label_len
    call print_stdout
    mov ecx, subject_buf
    mov edx, [subject_len]
    call print_stdout
    mov ecx, newline
    mov edx, newline_len
    call print_stdout

    ; Save details to file
    call create_file_full_access
    mov ebp, eax                ; store file descriptor

    mov ebx, ebp
    mov ecx, name_label
    mov edx, name_label_len
    call write_fd
    mov ebx, ebp
    mov ecx, name_buf
    mov edx, [name_len]
    call write_fd
    mov ebx, ebp
    mov ecx, newline
    mov edx, newline_len
    call write_fd

    mov ebx, ebp
    mov ecx, subject_label
    mov edx, subject_label_len
    call write_fd
    mov ebx, ebp
    mov ecx, subject_buf
    mov edx, [subject_len]
    call write_fd
    mov ebx, ebp
    mov ecx, newline
    mov edx, newline_len
    call write_fd

    mov ebx, ebp
    call close_fd

    ; Reopen and display the file contents
    call open_file_readonly
    mov ebp, eax

    mov ebx, ebp
    mov ecx, file_buf
    mov edx, 256
    call read_fd
    mov edi, eax                ; byte count read

    mov ebx, ebp
    call close_fd

    mov ecx, file_msg
    mov edx, file_msg_len
    call print_stdout
    mov ecx, file_buf
    mov edx, edi
    call print_stdout

    call exit_success

; --- Procedures -------------------------------------------------------------

print_stdout:
    ; ECX = buffer, EDX = length
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

read_stdin:
    ; ECX = buffer, EDX = max bytes
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

write_fd:
    ; EBX = file descriptor, ECX = buffer, EDX = length
    mov eax, 4
    int 0x80
    ret

read_fd:
    ; EBX = file descriptor, ECX = buffer, EDX = max bytes
    mov eax, 3
    int 0x80
    ret

close_fd:
    ; EBX = file descriptor
    mov eax, 6
    int 0x80
    ret

create_file_full_access:
    ; returns file descriptor in EAX
    mov eax, 8
    mov ebx, filename
    mov ecx, 0777o              ; rwxrwxrwx for demonstration
    int 0x80
    ret

open_file_readonly:
    ; returns file descriptor in EAX
    mov eax, 5
    mov ebx, filename
    mov ecx, 0                  ; O_RDONLY
    int 0x80
    ret

trim_newline:
    ; EAX = current length, ECX = buffer
    ; Removes trailing LF if present and null-terminates the resulting string.
    test eax, eax
    jle .terminate
    lea edx, [eax - 1]
    js .terminate
    cmp byte [ecx + edx], 10
    jne .terminate
    mov eax, edx

.terminate:
    mov byte [ecx + eax], 0
    ret

exit_success:
    mov eax, 1
    xor ebx, ebx
    int 0x80
