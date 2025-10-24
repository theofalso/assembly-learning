; this program reads an entry and write that

section .data
    prompt_msg db 'write something: ', 0x0A  ; 0x0A is enter 
    prompt_len equ $ - prompt_msg       ; msg len

section .bss
    ; this section is for save the bytes of the user's entry
    userInput resb 100

section .text
    global _start

_start:
    mov rax, 1          ; syscall 1 (write)
    mov rdi, 1          ; 1 = stdout (display)
    mov rsi, prompt_msg ; "write something"
    mov rdx, prompt_len
    syscall

    mov rax, 0          ; syscall 0 (read)
    mov rdi, 0          ; 0 = stdin (keyboard)
    mov rsi, userInput  ; the line 7-9 buffer
    mov rdx, 100        ; max amount of bytes redeables
    syscall
    
    mov rdx, rax        ; moves rax (amount of bytes of the message) to rdx


    mov rax, 1          ; syscall 1 (write)
    mov rdi, 1          ;
    mov rsi, userInput  ; 
    ; rdx ya tiene la longitud correcta (la movimos desde rax)
    syscall

    ; EXIT
    mov rax, 60
    mov rdi, 0
    syscall