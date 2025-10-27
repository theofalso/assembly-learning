
; itoa is basically "integer to ascii", what happens is:
; we get the remainders of the number by dividing it by 10 and pushing it, then we pop and print
section .bss
    result    resb 1

section .text
;  - r12: digit counter  
;   - rbx: divisor (10)
;   - rax, rdx: for division
; itoa is basically "integer to ascii", what happens is:
; we get the remainders of the number by dividing it by 10 and pushing it, then we pop and print

_print_number:

    mov r12, 0
    mov rbx, 10

    ; special case for 0
    cmp ax, 0
    je _print_zero
    
_convert_loop:
    ; div divides rax by rbx, in rdx we have the remainder
    ; clean rdx before division
    mov rdx, 0
    div rbx
    
    push rdx; push remainder (digit) onto stack
    inc r12;increment digit counter
    
    cmp rax, 0; is quotient 0?
    jne _convert_loop
    
_print_loop:
    cmp r12, 0
    je _print_done
    
    pop rax
    add rax, 48; convert to ASCII
    
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