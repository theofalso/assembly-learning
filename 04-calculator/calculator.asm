; CALCULATOR by theofalso. Assembly x86-64 Linux NASM. github.com/theofalso/assembly-learning
;
;   rbx: main acumulator, holding num1 and the result of the previous calculations
;   r12b stores the operator, r12 (the full register) used in _print_number
;   r13 holds the converted value for num2
;   r14 used as safe place to store the constant 10 for atoi and print number, and the constant 100 for scaling
;   r15 used in atoi as negative flag
;   rbp used in _print_number as safe temporary copy of the numer while counting digits
;

section .data
    msg_num1 db 'Enter the first number: ', 0x0A
    len_num1 equ $ - msg_num1
    
    msg_op   db 'Enter operator (+ - * /) or ( c = Clear, q = Quit): ', 0x0A
    len_op   equ $ - msg_op
    
    msg_num2 db 'Enter the next number: ', 0x0A
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
    ; first number (start or clear)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_num1
    syscall
    
    call _read_number
    mov rbx, rax

_main_loop: ; rbx contains the accumulator, r12b the operator, r13 holds the converted and scalated num2


    ; read operator
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

    cmp r12b, 'c'
    je _start           ; cleaer
    cmp r12b, 'q'
    je _exit            ; quit

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_num2
    syscall
    
    call _read_number
    mov r13, rax

; rbx = num1 acumulator, r12b operator, r12 num2

    cmp r12b, 43  ; '+'
    je _do_add
    cmp r12b, 45  ; '-'
    je _do_sub
    cmp r12b, 42  ; '*'
    je _do_mul
    cmp r12b, 47  ; '/'
    je _do_div
    
    jmp _main_loop

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
    
    mov rbx, rax
    jmp _print_setup

_do_div:
    mov rax, rbx
    
    mov r14, 100
    imul r14
    cqo
    cmp r13, 0
    je _exit
    idiv r13
    mov rbx, rax
    jmp _print_setup

; user types string into stdin, rax will contain the converted, scaled and signed integer
_read_number:
    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 16
    syscall
    
    mov rsi, userInput
    call _atoi
    ret

; atoi function with decimal point handling
_atoi:
    mov rax, 0
    mov r14, 10
    mov r15, 0
    mov r10, 0
    mov r11, 0
    movzx rcx, byte [rsi]
    cmp rcx, 45
    jne _atoi_loop_start
    mov r15, 1
    inc rsi
_atoi_loop_start:
    movzx rcx, byte [rsi]
    inc rsi
    cmp rcx, 10
    je _atoi_scale
    cmp rcx, 46
    je _atoi_found_decimal
    cmp rcx, '0'
    jl _atoi_loop_start
    cmp rcx, '9'
    jg _atoi_loop_start
    sub rcx, 48
    mul r14
    add rax, rcx
    cmp r11, 1
    jne _atoi_loop_start
    inc r10
    jmp _atoi_loop_start
_atoi_found_decimal:
    mov r11, 1
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

; input rax: contains the scaled integer to be printed/ output: prints de formatted number to stdout. this modifies r12, r14, rbp and uses stack

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
    jmp _main_loop

; itoa function with decimal point handling
_print_number:
    mov r12, 0
    mov r14, 10
    cmp rax, 0
    je _print_zero
    jge _check_positive
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
    cmp r12, 2
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