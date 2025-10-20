; Example with user input using logical ops plus JE/JZ jumps
; Student enters whether homework/chores are done; program tracks bits.

section .data
    msg_intro       db "Daily tracker setup...", 10
    len_intro       equ $ - msg_intro

    prompt_hw       db "Did you finish homework? (y/n): "
    len_prompt_hw   equ $ - prompt_hw

    prompt_ch       db "Did you finish chores? (y/n): "
    len_prompt_ch   equ $ - prompt_ch

    msg_status_hdr  db 10, "Current tracker (1 = done, 0 = not):", 10
    len_status_hdr  equ $ - msg_status_hdr

    msg_hw_done     db "  Homework: done (bit 0 = 1)", 10
    len_hw_done     equ $ - msg_hw_done

    msg_hw_pending  db "  Homework: pending (bit 0 = 0)", 10
    len_hw_pending  equ $ - msg_hw_pending

    msg_ch_done     db "  Chores: done (bit 1 = 1)", 10
    len_ch_done     equ $ - msg_ch_done

    msg_ch_pending  db "  Chores: pending (bit 1 = 0)", 10
    len_ch_pending  equ $ - msg_ch_pending

    msg_all_done    db 10, "Congrats! Both tasks are complete.", 10
    len_all_done    equ $ - msg_all_done

    msg_still_need  db 10, "Reminder: finish homework or chores.", 10
    len_still_need  equ $ - msg_still_need

    msg_resetting   db 10, "Resetting tracker for tomorrow...", 10
    len_resetting   equ $ - msg_resetting

    msg_cleared     db "Tracker cleared. Ready for a new day!", 10
    len_cleared     equ $ - msg_cleared

    msg_not_clear   db "Tracker still shows tasks. Check inputs.", 10
    len_not_clear   equ $ - msg_not_clear

section .bss
    buffer resb 2                  ; room for char + newline

section .text
    global _start

_start:
    ; intro
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    xor edi, edi                   ; tracker bits (bit0=homework, bit1=chores)

    ; prompt for homework
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_hw
    mov edx, len_prompt_hw
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2
    int 0x80

    mov al, [buffer]
    or  al, 0x20                  ; force lowercase for letters
    cmp al, 'y'
    je  .set_homework
    jmp .after_homework

.set_homework:
    or  edi, 0b0001               ; set bit 0

.after_homework:
    ; prompt for chores
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_ch
    mov edx, len_prompt_ch
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2
    int 0x80

    mov al, [buffer]
    or  al, 0x20
    cmp al, 'y'
    je  .set_chores
    jmp .after_chores

.set_chores:
    or  edi, 0b0010               ; set bit 1

.after_chores:
    mov esi, edi                  ; keep original tracker for later steps

    ; status header
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_status_hdr
    mov edx, len_status_hdr
    int 0x80

    ; homework message
    mov eax, esi
    test eax, 0b0001
    jz  .homework_pending
    mov ecx, msg_hw_done
    mov edx, len_hw_done
    jmp .write_homework

.homework_pending:
    mov ecx, msg_hw_pending
    mov edx, len_hw_pending

.write_homework:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; chores message
    mov eax, esi
    test eax, 0b0010
    jz  .chores_pending
    mov ecx, msg_ch_done
    mov edx, len_ch_done
    jmp .write_chores

.chores_pending:
    mov ecx, msg_ch_pending
    mov edx, len_ch_pending

.write_chores:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, esi
    mov ebx, 0b0011
    and eax, ebx
    cmp eax, ebx
    je  .all_tasks_complete

    mov ecx, msg_still_need
    mov edx, len_still_need
    jmp .write_summary

.all_tasks_complete:
    mov ecx, msg_all_done
    mov edx, len_all_done

.write_summary:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; reset tracker demonstration
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_resetting
    mov edx, len_resetting
    int 0x80

    mov eax, esi
    xor eax, esi                ; clear by XORing with itself
    cmp eax, 0
    je  .tracker_cleared

    mov ecx, msg_not_clear
    mov edx, len_not_clear
    jmp .write_reset

.tracker_cleared:
    mov ecx, msg_cleared
    mov edx, len_cleared

.write_reset:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
