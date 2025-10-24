; prank russian roulette

section .data
    ; not really random, i choose 4
    losingNumber db 4

    ; massages section
    msg_ask   db 'choose a number (1-6): ', 0x0A
    len_ask   equ $ - msg_ask
    
    msg_boom  db '¡BOOM!', 0x0A
    len_boom  equ $ - msg_boom
    
    msg_safe  db 'you are save... for now...', 0x0A
    len_safe  equ $ - msg_safe

    ; prank msg
    msg_scare db 'rm -rf /', 0x0A;
    len_scare equ $ - msg_scare

section .bss
    userInput resb 4  

section .text
    global _start

_start:
_main_loop:
    ; ask for a number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ask
    mov rdx, len_ask
    syscall

    ; read number
    mov rax, 0
    mov rdi, 0
    mov rsi, userInput
    mov rdx, 4
    syscall

    ; covert from ascii
    mov al, [userInput] 
    sub al, 48          

    ; compare 
    cmp al, [losingNumber] 
    je _boom        
    
    
    jmp _safe

_safe:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_safe
    mov rdx, len_safe
    syscall
    jmp _main_loop 

_boom:
    

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_boom
    mov rdx, len_boom
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_scare
    mov rdx, len_scare
    syscall

    ; 3. Ahora sí, salimos del juego
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall