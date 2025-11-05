homescreen_fn:
    mov si, mensagemi
    mov bl, 14                                                 ; yellow
    call print_str_color
    call exit_to_shell
    ret                                                        ; back to main loop

shell_fn:
    mov si, sprompt
    mov bl, 14                                                ; yellow
    call print_str_color
    xor dx, dx
    mov di, 0

.input_loop:
    call getc

    cmp dl, 0
    jne .notsave
    mov dl, al
.notsave:
    call putc
    cmp al, 13                                                 ; enter key?
    je .handle_enter
    cmp al, 32
    jne .notspace
    cmp di, 0
    jne .notspace

    mov di, arg
    jmp .input_loop

.notspace:
    cmp di, 0
    je .input_loop
    stosb
    jmp .input_loop

.handle_enter:

    cmp di, 0
    je .find_command
    mov al, 0
    stosb

.find_command:
    mov al, dl
    sub al, 'a'                                               ; convert to index
    mov ah, 0
    mov bx ,2
    mul bx

    mov bx, ctable
    add ax, bx

    mov bx, [eax]
    mov [state], bx

    ret

.check_space:
    cmp al, 32
    jne .check_arg

    cmp di, 0
    jne .check_arg

    mov di, arg
    jmp .check_enter

.check_arg:
    cmp di, 0
    je .check_enter
    stosb

.check_enter:
    cmp al, 13
    jne .input_loop
    cmp di, 0
    je .find_command
    mov al, 0
    stosb


exit_to_shell:
    mov ax, shell_fn
    mov [state], ax
    ret

help_fn:
    call endl
    mov si, commands
    call print_str
    call exit_to_shell
    ret

clear_fn:
    call init_video
    call exit_to_shell
    ret

ef:
    call endl
    mov si, error_msg
    call print_str
    call exit_to_shell
    ret

about_fn:
    call endl
    mov si, about_msg
    call print_str
    call endl
    call exit_to_shell
    ret

echo_fn:
    call endl
    mov si, arg
    call print_str
    call endl
    call exit_to_shell
    ret



show_image_fn:
    
    pusha
    call clear_screen

    mov ax, my_image_data
    xor dx, dx
    mov bx, 16
    div bx
    
    mov ds, ax
    mov si, dx
    
    mov ax, 0xA000
    mov es, ax
    xor di, di
    
    mov cx, 64000
    rep movsb
    

    xor ax, ax
    mov ds, ax
    
    call getc
    popa
    
    call clear_screen
    call exit_to_shell
    ret