; Example showing basic array handling
; Scenario: tally daily study minutes stored in an array.

section .data
    msg_intro       db "Study tracker: summing minutes for 5 days.", 10
    len_intro       equ $ - msg_intro

    msg_total_label db "Total minutes studied: "
    len_total_label equ $ - msg_total_label

    msg_average_lbl db "Average per day: "
    len_average_lbl equ $ - msg_average_lbl

    newline         db 10

    study_minutes   dd 45, 50, 40, 60, 55   ; array of 5 entries
    count_days      equ 5

section .bss
    buffer          resb 12                 ; for simple decimal string

section .text
    global _start

_start:
    ; intro text
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov ecx, count_days         ; loop counter
    mov esi, study_minutes      ; pointer to array
    xor eax, eax                ; use EAX as running sum

.sum_loop:
    add eax, [esi]              ; add current element
    add esi, 4                  ; move to next dword
    loop .sum_loop

    mov edi, eax                ; preserve total

    ; print total label
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_total_label
    mov edx, len_total_label
    int 0x80

    ; convert total to decimal and print
    push edi
    call print_number
    add esp, 4

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; compute average = total / count_days
    mov eax, edi
    mov ebx, count_days
    xor edx, edx                ; clear remainder
    div ebx                     ; eax = average

    ; print average label
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_average_lbl
    mov edx, len_average_lbl
    int 0x80

    ; print average value
    push eax
    call print_number
    add esp, 4

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

;------------------------------------------------
; print_number: prints unsigned integer from stack
; expects value in [esp]
; uses buffer in .bss
;------------------------------------------------
print_number:
    push ebp
    mov ebp, esp
    sub esp, 16

    mov ebx, [ebp + 8]          ; source value
    lea edi, [buffer + 11]
    mov byte [edi], 0

.convert_loop:
    xor edx, edx
    mov eax, ebx
    mov ecx, 10
    div ecx                     ; eax = value / 10, edx = remainder
    add dl, '0'
    dec edi
    mov [edi], dl
    mov ebx, eax
    test ebx, ebx
    jnz .convert_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buffer + 11
    sub edx, edi                ; length
    int 0x80

    mov esp, ebp
    pop ebp
    ret
