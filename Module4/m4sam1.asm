; Example using CMP to compare two integers

section .data
    msg_equal  db "Numbers are equal", 10
    len_equal  equ $ - msg_equal
    msg_noteq  db "Numbers are different", 10
    len_noteq  equ $ - msg_noteq

section .text
    global _start

_start:
    mov eax, 42         ; first value
    mov ebx, 42         ; second value

    cmp eax, ebx        ; compare eax and ebx
    je  .equal          ; jump if equal

    ; not equal path
    mov edx, len_noteq  ; message length
    mov ecx, msg_noteq  ; message pointer
    jmp .write_message

.equal:
    mov edx, len_equal
    mov ecx, msg_equal

.write_message:
    mov ebx, 1          ; file descriptor stdout
    mov eax, 4          ; syscall: write
    int 0x80

.exit:
    mov ebx, 0          ; exit code
    mov eax, 1          ; syscall: exit
    int 0x80
