; atoi example
; this is not a complete program, it won't run as is

section .data
    msg         db ' '
    len_msg     equ $ - msg
    test_string db '12345', 0x0A; string to convert 
    newline     db 0x0A

section .bss
    result    resb 1  ; useful buffer for itoa

section .text
    global _start


; --- FUNCIÓN 'atoi' (ASCII to Integer) ---
; Entrada: rsi = puntero al string
; Salida: rax = número convertido
; Usa: r14 (seguro)
_atoi:
    mov rax, 0          ; rax = Total = 0
    mov r14, 10         ; Usamos r14 (seguro) para el '10'
    
_atoi_loop:
    movzx rcx, byte [rsi] ; load up the next caracter filling upper bits with 0
    inc rsi               ; get ready for next char
    
    cmp rcx, 10         ; is it newline?
    je _atoi_done
    
    cmp rcx, '0'        ; is less than '0'? then
    jl _atoi_loop; ignore
    
    cmp rcx, '9'        ; is greater than '9'? then
    jg _atoi_loop; ignore
    
    sub rcx, 48
    
    mul r14; rax = rax * 10
    add rax, rcx; rax = rax + new_digit
    
    jmp _atoi_loop
    
_atoi_done:
    ret