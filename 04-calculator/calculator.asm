; one digit calculator

section .data
    msg_num1 db 'enter the first number (0-9)', 0x0A
    len_num1 equ $ - msg_num1
    
    msg_op   db 'enter operator (+ - * /): ', 0x0A
    len_op   equ $ - msg_op
    
    msg_num2 db 'enter the second number (0-9): ', 0x0A
    len_num2 equ $ - msg_num2
    
    msg_res  db 'result: '
    len_res  equ $ - msg_res
    
    newline  db 0x0A

section .bss
    userInput resb 2
    result    resb 1  

section .text
    global _start

_start:
    ;first number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_num1
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 2
    syscall
    
    mov al, [userInput]
    sub al, 48
    mov bl, al

    ; raed operator
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_op
    mov rdx, len_op
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 2
    syscall
    
    mov r12b, [userInput]

    ; read second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_num2
    syscall


    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 2
    syscall
    
 
    mov al, [userInput]
    sub al, 48 

; bl has the first number
; r12b has the operator
; al has the second number

    cmp r12b, 43  ; '+'
    je _do_add

    cmp r12b, 45  ; '-'
    je _do_sub

    cmp r12b, 42  ; '*'
    je _do_mul

    cmp r12b, 47  ; '/'
    je _do_div
    
    jmp _exit 

_do_add:
    add al, bl
    jmp _print_result

_do_sub:
    sub bl, al
    mov al, bl
    jmp _print_result

_do_mul:
    mul bl
    jmp _print_result

_do_div:
    mov cl, al
    mov al, bl
    div cl

_print_result:
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
    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
_exit:
    mov rax, 60
    mov rdi, 0
    syscall