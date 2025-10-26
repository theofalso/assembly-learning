; one digit calculator

section .data
    msg_num1 db 'enter the first number (0-9)', 0x0A
    len_num1 equ $ - msg_num1
    
    msg_op   db 'enter operator (+ o -): ', 0x0A
    len_op   equ $ - msg_op
    
    msg_num2 db 'enter the second number (0-9): ', 0x0A
    len_num2 equ $ - msg_num2
    
    msg_res  db 'result: '
    len_res  equ $ - msg_res

section .bss
    userInput resb 4
    result    resb 1  ; result buffer

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_num1
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 4
    syscall
    
    mov al, [userInput]
    sub al, 48
    mov bl, al

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_op
    mov rdx, len_op
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 4
    syscall
    
    mov cl, [userInput]

    ; second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_num2
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 4
    syscall
    
    mov al, [userInput]
    sub al, 48

; 'bl' first has the first number
; 'cl' has the operator 
; 'al' has the second number

    cmp cl, '+'
    je _do_add

    cmp cl, '-'
    je _do_sub
    
    jmp _exit

_do_add:
    add al, bl
    jmp _print_result

_do_sub:
    sub bl, al
    mov al, bl
    jmp _print_result

_print_result:
    ; al has the result in both cases
    add al, 48

    mov [result], al

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_res
    mov rdx, len_res
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, result 
    mov rdx, 1         
    syscall
    
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall