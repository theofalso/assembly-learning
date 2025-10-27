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
    mov ah, 0 
    jmp _print_setup

_do_sub:
    sub bl, al 
    mov al, bl
    mov ah, 0
    jmp _print_setup

_do_mul:
    mul bl
    jmp _print_setup

_do_div:
    mov cl, al
    mov al, bl ; al has the number to be divided
    mov ah, 0
    
    cmp cl, 0
    je _exit ; div per 0 not sopported
    
    div cl ; al = quotient, ah = remainder
    mov ah, 0
    jmp _print_setup

_print_setup:

    push rax

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_res
    mov rdx, len_res
    syscall

    pop rax
    
    call _print_number

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    jmp _exit

; itoa function
_print_number:

    mov r12, 0 ; r12 is the digit counter
    mov rbx, 10 

    cmp ax, 0
    je _print_zero
    
_convert_loop:
    mov rdx, 0
    div rbx; divide rax by 10
    push rdx; save digit
    inc r12; r12 is the digit counter
    
    cmp rax, 0
    jne _convert_loop
    
_print_loop:
    cmp r12, 0; any digits left?
    je _print_done
    
    pop rax
    add rax, 48
    
    mov [result], al
    
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall
    dec r12
    jmp _print_loop

_print_zero:
    mov [result], byte '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall

_print_done:
    ret

_exit:
    mov rax, 60
    mov rdi, 0
    syscall