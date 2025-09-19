;with prompt output
    section .data
        firstNamePrompt db "First name: ", 0
        lastNamePrompt db "Last name: ", 0
        middleNamePrompt db "Middle name: ", 0
        space db ' ', 0
        firstNameOutputPrompt db "Your first name is: ", 0
        lastNameOutputPrompt db 10,"Your last name is: ",0
        middleNameOutputPrompt db 10,"Your middle name is: ",0,10
        
    section .bss
        firstName resb 256
        lastName  resb 256
        middleName resb 256
        
    section .text
        global _start
        
    _start:
        ; Input first name
        call displayFirstNamePrompt
        call inputFirstName
        
        ; Input last name
        call displayLastNamePrompt
        call inputLastName
        
        ; Input middle name
        call displayMiddleNamePrompt
        call inputMiddleName
        
        ; Display the data
        call displayFirstNameOutput
        call displaySpace
        call displayLastNameOutput
        call displaySpace
        call displayMiddleNameOutput
        
        ; Exit the program
        mov eax, 1          
        int 0x80
        
    ; Display routines for the prompts
    displayFirstNamePrompt:
        mov edx, firstNamePrompt
        call displayString
        ret
        
    displayLastNamePrompt:
        mov edx, lastNamePrompt
        call displayString
        ret
        
    displayMiddleNamePrompt:
        mov edx, middleNamePrompt
        call displayString
        ret
        
    ; Input routines
    inputFirstName:
        mov eax, firstName
        call inputString
        ret
        
    inputLastName:
        mov eax, lastName
        call inputString
        ret
        
    inputMiddleName:
        mov eax, middleName
        call inputString
        ret
        
    ; Display output prompts and names
    displayFirstNameOutput:
        mov edx, firstNameOutputPrompt
        call displayString
        mov edx, firstName
        call displayString
        ret
        
    displayLastNameOutput:
        mov edx, lastNameOutputPrompt
        call displayString
        mov edx, lastName
        call displayString
        ret
        
    displayMiddleNameOutput:
        mov edx, middleNameOutputPrompt
        call displayString
        mov edx, middleName
        call displayString
        ret
        
    ; General display string routine
    displayString:
        mov ecx, edx
        mov edx, 0
    countChars:
        cmp byte [ecx + edx], 0
        je doneCounting
        inc edx
        jmp countChars
    doneCounting:
        mov eax, 4          ; SYS_WRITE
        mov ebx, 1          ; STDOUT
        int 0x80
        ret
        
    ; General input string routine
    inputString:
        mov ebx, 0          ; STDIN
        mov edx, 255
        mov ecx, eax
        mov eax, 3          ; SYS_READ
        int 0x80
        
        ; Replace newline with null byte
        mov byte [ecx + eax - 1], 0
        ret
        
    ; Display space
    displaySpace:
        mov edx, space
        call displayString
        ret
