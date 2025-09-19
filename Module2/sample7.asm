;center text screen
;version1
explain the following codes
section .data
    text1 db "hadji", 10     ; 10 is newline
    text2 db "tejuco", 10    ; 10 is newline
    padding1 times 37 db ' ' ; Center padding for the first line
    padding2 times 36 db ' ' ; Center padding for the second line

section .text
    global _start

_start:
    ; Print padding1
    mov eax, 4
    mov ebx, 1
    mov ecx, padding1
    mov edx, 37
    int 0x80

    ; Print "hadji"
    mov eax, 4
    mov ebx, 1
    mov ecx, text1
    mov edx, 6
    int 0x80

    ; Print padding2
    mov eax, 4
    mov ebx, 1
    mov ecx, padding2
    mov edx, 36
    int 0x80

    ; Print "tejuco"
    mov eax, 4
    mov ebx, 1
    mov ecx, text2
    mov edx, 7
    int 0x80

    ; Exit
    mov eax, 1
    int 0x80
