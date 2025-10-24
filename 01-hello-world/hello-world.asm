section .data
    msg db 'hello world', 0x0A 
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1; syscall 1 (write)
    mov rdi, 1; 
    mov rsi, msg; 
    mov rdx, len; 
    syscall;

    mov rax, 60; syscall 60 (exit)
    mov rdi, 0; 
    syscall;