; sam5m5.asm
; Demonstrates Linux int 0x80 syscalls for a simple file round-trip:
;   1. create a file and write "Hello World\n"
;   2. reopen it for reading
;   3. echo the bytes we read back to stdout.
; Inline comments call out which registers each syscall expects.

section .data
    filename    db 'myfile.txt', 0
    content     db 'Hello World', 10        ; include newline for nicer output
    content_len equ $ - content
    buffer      times 100 db 0

section .text
    global _start

_start:
    ; Step 1: Create/Open the file (sys_creat)
    mov eax, 8
    mov ebx, filename
    mov ecx, 0777                  ; permissions rwx for demo
    int 0x80
    mov ebx, eax                    ; keep returned fd in EBX for reuse

    ; Step 2: Write the message (sys_write)
    mov eax, 4
    mov ecx, content
    mov edx, content_len
    int 0x80

    ; Step 3: Close the file (sys_close)
    mov eax, 6
    int 0x80

    ; Step 4: Reopen for reading (sys_open)
    mov eax, 5
    mov ebx, filename
    mov ecx, 0                      ; O_RDONLY
    int 0x80
    mov ebx, eax

    ; Step 5: Read back into buffer (sys_read)
    mov eax, 3
    mov ecx, buffer
    mov edx, 100
    int 0x80                        ; EAX holds number of bytes read

    ; Step 6: Echo to stdout (sys_write)
    mov edx, eax                    ; reuse actual bytes read, newline included
    mov eax, 4
    mov ebx, 1                      ; stdout
    mov ecx, buffer
    int 0x80

    ; Step 7: Exit program (sys_exit)
    mov eax, 1
    xor ebx, ebx
    int 0x80
