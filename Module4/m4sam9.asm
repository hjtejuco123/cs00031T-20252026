; Example using logical operations with JE/JZ jumps
; Scenario: a student tracks two must-do tasks: homework (bit 0) and chores (bit 1).

section .data
    msg_intro       db "Checking today's task tracker...", 10
    len_intro       equ $ - msg_intro

    msg_all_done    db "Nice! Homework and chores are both done.", 10
    len_all_done    equ $ - msg_all_done

    msg_still_need  db "Reminder: finish homework or chores.", 10
    len_still_need  equ $ - msg_still_need

    msg_resetting   db "Resetting tracker for tomorrow...", 10
    len_resetting   equ $ - msg_resetting

    msg_cleared     db "Tracker is clear. Ready for a new day!", 10
    len_cleared     equ $ - msg_cleared

    msg_not_clear   db "Tracker still shows tasks. Double-check values.", 10
    len_not_clear   equ $ - msg_not_clear

    msg_status_hdr  db "Current tracker status (1 = done, 0 = not):", 10
    len_status_hdr  equ $ - msg_status_hdr

    msg_hw_done     db "  Homework: done (bit 0 = 1)", 10
    len_hw_done     equ $ - msg_hw_done

    msg_hw_pending  db "  Homework: pending (bit 0 = 0)", 10
    len_hw_pending  equ $ - msg_hw_pending

    msg_ch_done     db "  Chores: done (bit 1 = 1)", 10
    len_ch_done     equ $ - msg_ch_done

    msg_ch_pending  db "  Chores: pending (bit 1 = 0)", 10
    len_ch_pending  equ $ - msg_ch_pending

section .text
    global _start

_start:
    ; intro message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_intro
    int 0x80

    mov eax, 0b0011         ; task tracker: both tasks marked complete
    mov ebx, 0b0011         ; mask of tasks that must be done (homework + chores)
    mov esi, eax            ; keep the original tracker value for later

    ; display the individual task states
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_status_hdr
    mov edx, len_status_hdr
    int 0x80

    mov eax, esi
    test eax, 0b0001        ; check homework bit
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

    mov eax, esi
    test eax, 0b0010        ; check chores bit
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

    mov eax, esi            ; restore tracker before mask comparison
    mov ebx, 0b0011         ; ensure mask is reloaded

    and eax, ebx            ; leave only the must-do bits
    cmp eax, ebx            ; compare with required mask
    je  .all_tasks_done     ; JE -> streak of success!

    mov ecx, msg_still_need
    mov edx, len_still_need
    jmp .write_first

.all_tasks_done:
    mov ecx, msg_all_done
    mov edx, len_all_done

.write_first:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; simulate clearing the tracker at the end of the day
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_resetting
    mov edx, len_resetting
    int 0x80

    mov eax, esi            ; restore tracker
    xor eax, esi            ; XOR with itself -> should become zero
    cmp eax, 0
    je  .tracker_zero       ; JZ/JE trigger when the tracker is fully cleared

    mov ecx, msg_not_clear
    mov edx, len_not_clear
    jmp .write_second

.tracker_zero:
    mov ecx, msg_cleared
    mov edx, len_cleared

.write_second:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
