section .data
    prompt_message db "Enter a number (0-9): ", 0
    result_message db "You entered: ", 0
    newline db 10, 0  ; Newline character
    
section .bss
    input_char resb 1  ; Reserve space for 1 byte of user input
    
section .text
    global _start
    
_start:
    ; Call the subroutine to display the prompt message
    call display_prompt
    
    ; Call the subroutine to get user input
    call get_input
    
    ; Call the subroutine to display the result message and the user's input
    call display_result
    
    ; Exit the program
    call exit_program
    
; Subroutine: display_prompt
display_prompt:
    ; Write the prompt message to the screen
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor (1 = stdout)
    mov ecx, prompt_message ; pointer to the message
    mov edx, 21           ; length of the message
    int 0x80              ; interrupt to make the syscall
    ret                   ; return from the subroutine
    
; Subroutine: get_input
get_input:
    ; Read a character from the user
    mov eax, 3            ; syscall number for sys_read
    mov ebx, 0            ; file descriptor (0 = stdin)
    mov ecx, input_char   ; buffer to store the input
    mov edx, 1            ; read 1 byte
    int 0x80              ; interrupt to make the syscall
    ret                   ; return from the subroutine
    
; Subroutine: display_result
display_result:
    ; Write the result message to the screen
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor (1 = stdout)
    mov ecx, result_message ; pointer to the result message
    mov edx, 13           ; length of the result message
    int 0x80              ; interrupt to make the syscall
    
    ; Write the user input to the screen
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor (1 = stdout)
    mov ecx, input_char   ; buffer containing the user input
    mov edx, 1            ; write 1 byte (the input)
    int 0x80              ; interrupt to make the syscall
    
    ; Write a newline character to the screen
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor (1 = stdout)
    mov ecx, newline      ; newline character
    mov edx, 1            ; write 1 byte (the newline)
    int 0x80              ; interrupt to make the syscall
    ret                   ; return from the subroutine
    
; Subroutine: exit_program
exit_program:
    ; Exit the program
    mov eax, 1            ; syscall number for sys_exit
    xor ebx, ebx          ; exit code 0
    int 0x80              ; interrupt to make the syscall
    ret                   ; return from the subroutine
    
