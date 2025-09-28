section .data
    clearScreen db 27, '[2J', 0          ; ANSI code to clear screen

moveCursor1 db 27, '[1; 38H' ; Move cursor to 1st row, 38th column
moveCursor1_len equ $ - moveCursor1

    text1 db "hadji", 10, 0              ; 10 is the newline character
    text1_len equ $ - text1

moveCursor2 db 27, '[2; 36H' ; Move cursor to 2nd row, 36th column
moveCursor2_len equ $ - moveCursor2

    text2 db "tejuco", 10, 0             
    text2_len equ $ - text2

moveCursor3 db 27, '[5; 37H' ; Move cursor to 5th row, 37th column
moveCursor3_len equ $ - moveCursor3

    text3 db "javier", 10, 0
    text3_len equ $ - text3

section .text
    global _start

_start:
    call clearTheScreen
    call displayText1
    call displayText2
    call displayText3
    call exitProgram

; Clear the screen
clearTheScreen:
    mov eax, 4
    mov ebx, 1
    mov ecx, clearScreen
    mov edx, 4
    int 0x80
    ret

; Display "hadji" at row 1, col 38
displayText1:
    mov eax, 4
    mov ebx, 1
    mov ecx, moveCursor1
    mov edx, moveCursor1_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, text1
    mov edx, text1_len
    int 0x80
    ret

; Display "tejuco" at row 2, col 36
displayText2:
    mov eax, 4
    mov ebx, 1
    mov ecx, moveCursor2
    mov edx, moveCursor2_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, text2
    mov edx, text2_len
    int 0x80
    ret

; Display "javier" at row 5, col 37
displayText3:
    mov eax, 4
    mov ebx, 1
    mov ecx, moveCursor3
    mov edx, moveCursor3_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, text3
    mov edx, text3_len
    int 0x80
    ret

; Exit program
exitProgram:
    mov eax, 1
    int 0x80