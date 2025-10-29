section .data
    msg_num1 db 'enter the first number (e.g., 123.45): ', 0x0A
    len_num1 equ $ - msg_num1
    
    msg_op   db 'enter operator (+ - * /): ', 0x0A
    len_op   equ $ - msg_op
    
    msg_num2 db 'enter the second number: ', 0x0A
    len_num2 equ $ - msg_num2
    
    msg_res  db 'result: '
    len_res  equ $ - msg_res
    
    newline  db 0x0A
    decimal_point db '.'

section .bss
    userInput resb 16
    result    resb 1  

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_num1
    syscall
    
    call _read_number
    mov rbx, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_op
    mov rdx, len_op
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 2; operator + '\n'
    syscall
    mov r12b, [userInput]


    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_num2
    syscall
    
    call _read_number
    mov r13, rax

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
    add rbx, r13
    mov rax, rbx
    jmp _print_setup

_do_sub:
    sub rbx, r13
    mov rax, rbx
    jmp _print_setup

_do_mul:
    mov rax, rbx
    imul r13
    
    mov r14, 100
    idiv r14
    jmp _print_setup

_do_div:
    mov rax, rbx
    cqo; Convert Quadword to Octoword this instruction extends the sign of rax into rdx
    mov r14, 100
    imul r14
    
    mov rdx, 0
    cmp r13, 0
    je _exit
    
    idiv r13
    jmp _print_setup

_read_number:
    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 16
    syscall
    
    mov rsi, userInput
    call _atoi
    ret

_atoi:
    mov rax, 0; rax total
    mov r14, 10
    mov r15, 0; r15 negative flag
    mov r10, 0; r10 decimal counter
    mov r11, 0; r11 = coma flag

; is the first character a '-'?
    movzx rcx, byte [rsi]
    cmp rcx, 45
    jne _atoi_loop_start
    mov r15, 1
    inc rsi
    
_atoi_loop_start:
    movzx rcx, byte [rsi]
    inc rsi
    
    cmp rcx, 10; is a newline?
    je _atoi_scale; go to scaling
    
    cmp rcx, 46; is a decimal point?
    je _atoi_found_decimal
    
    cmp rcx, '0'
    jl _atoi_loop_start
    cmp rcx, '9'
    jg _atoi_loop_start
    
    sub rcx, 48
    
    mul r14
    add rax, rcx
    
    cmp r11, 1; we already found a decimal point?
    jne _atoi_loop_start
    inc r10; if yes increment decimal counter
    
    jmp _atoi_loop_start

_atoi_found_decimal:
    mov r11, 1; set the decimal point found flag
    jmp _atoi_loop_start

_atoi_scale:
    cmp r10, 2
    je _atoi_done
    
    cmp r10, 1
    je _atoi_scale_10
    
    mov r14, 100
    mul r14
    jmp _atoi_done
    
_atoi_scale_10:
    mov r14, 10
    mul r14
    
_atoi_done:
    cmp r15, 1
    jne _atoi_return
    neg rax
    
_atoi_return:
    ret

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

_print_number:
    mov r12, 0
    mov r14, 10
    
    cmp rax, 0
    je _print_zero
    jge _check_positive
    
    ; Es negativo:
    push rax
    mov [result], byte '-'
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall
    pop rax
    neg rax
    
_check_positive:
    push rax
    mov rbp, rax
_count_digits_loop:
    mov rdx, 0
    div r14
    inc r12
    cmp rax, 0
    jne _count_digits_loop
    
    pop rax
    
    ;r12 contains the number of digits before decimal point
    
    cmp r12, 2
    jg _print_loop_start
    
    mov [result], byte '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall
    
    cmp r12, 1
    jne _print_loop_start
    
    mov [result], byte '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall

_print_loop_start:
    mov rax, rbp
_convert_loop:
    mov rdx, 0
    div r14
    push rdx
    cmp rax, 0
    jne _convert_loop
_print_loop:
    cmp r12, 0
    je _print_done
    cmp r12, 2 ; if r12 is 2 print decimal point
    jne _print_digit
    mov rax, 1
    mov rdi, 1
    mov rsi, decimal_point
    mov rdx, 1
    syscall
    
_print_digit:
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