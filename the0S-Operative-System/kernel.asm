org 0x7e00
jmp 0x0000:start

data:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;STRINGS;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mensagemi db 'theOS - Ver 0.1',13,10,'Iniciando...',13,10,0
    sprompt db 13,10,'MY-PC1>',0
    commands db 'help - list of commands.', 13,10,'clear - clear the screen.',13,10,0
    error_msg db 'Command not found. Type "help" for a list of commands.',13,10,0

    arg TIMES 64 db 0                                          ; INPUT BUFFER


    ;;;;;;;;;;;;;;;;;;;;;;JUMP TABLE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    ; Key: 0   1   2  3         4   5   6   7   8         9   10  11
    ; Letter:  a,  b, c,        d,  e,  f,  g,  h,        i,  j,  k,  l
    ctable dw ef, ef, clear_fn, ef, ef, ef, ef, help_fn, ef, ef, ef, ef
    ;
    ; Key: 12  13  14  15  16  17  18  19  20  21  22  23  24  25
    ; Letter:  m,  n,  o,  p,  q,  r,  s,  t,  u,  v,  w,  x,  y,  z
           dw ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;GLOBAL VARIABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cor db 3                                                   ; TEXT COLOR
    state dw 0                                                 ; STATE VARIABLE 

start:
    xor ax, ax
    mov ds, ax                                                 ; INITIALIZE DATA SEGMENT
    mov es, ax

    call init_video                                            ; INITIALIZE VIDEO MODE

    mov ax, homescreen_fn                                      ; START STATE MODE
    mov [state], ax

.loop:                                                         ; MAIN LOOP 
    mov ax, [state]
    call eax                                                   ; CALL FUNCTION IN STATE
    jmp .loop

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;STATE FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    call cursor

    ; initialize parameters for input
    xor dx, dx
    mov di, 0
    ;ret

    mov bl, 15
    mov [cor], bl

.input_loop:
    call getc
    call putc
    call cursor


    cmp dl, 0                                                 ; we already have a char?
    jne .check_enter                                            ; if not jump back
    mov dl, al
    jmp .check_enter

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

exit_to_shell:
    mov ax, shell_fn
    mov [state], ax
    ret

help_fn:
    mov si, commands
    call print_str
    call exit_to_shell
    ret

clear_fn:
    call init_video
    call exit_to_shell
    ret

ef:
    mov si, error_msg
    call print_str
    call exit_to_shell
    ret


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;DRIVERS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getc:
    xor ah, ah
    int 16h                                                    ; keyboard interrupt
    ret
putc:
    call print_char                                            ; print character in al
    ret
endl:
    mov al, 13                                                 ; print line jump
    call putc
    mov al, 10
    call putc
    ret
_put_pixel:
    mov bp, sp
    mov ax, 0a000h                                             ; video memory segment
    push es
    mov es, ax
    mov ax, [bp+2]
    mov cx, 320
    mul cx
    add ax, [bp+4]
    mov bx, ax
    mov al, [bp+6] ; color
    es mov [bx], al
    pop es
    ret

%macro put_pixel 3
    pusha
    push %3; color
    push %1; x
    push %2; y
    call _put_pixel
    add sp, 6
    popa
%endmacro

_draw_horizontal_line:
    mov bp, sp
    mov ax, [bp+2]  ; y
    mov bx, [bp+4]  ; x1 start
    mov cx, [bp+6]  ; x2 end
    mov dx, [bp+8]  ; color
.loop:
    put_pixel bx, ax, dx
    inc bx
    cmp bx, cx
    jl .loop
    ret

%macro draw_horizontal_line 4
    pusha
    push %4 ; color
    push %3 ; x2
    push %2 ; x1
    push %1 ; y
    call _draw_horizontal_line
    add sp, 8
    popa
%endmacro

clear_screen: 
    pusha
    ; this function clears the screen by drawing black horizontal lines
    mov bx, 0 ; y = 0
.loop:
    draw_horizontal_line bx, 0, 320, 0 ;bx, de x=0 to x=320, color 0 black
    inc bx
    cmp bx, 200
    jl .loop
    popa
    ret

init_video:
    mov ah, 00h
    mov al, 13h
    int 10h
    ret

    ;;;;;;;;;;;;;;;;;;;;;;TEXT PRINT FUNCTION;;;;;;;;;;;;;;;;;;;
print_str:
    mov bl, 7
    call print_str_color
    ret

print_char:
    pusha
    mov bl, [cor]
    mov bh, 0
    mov ah, 0xe
    int 10h
    popa
    ret

cursor:
    pusha
    mov bl, 10                                                 ; COLOR
    mov bh, 0
    mov cx, 1
    mov al, '_'                                                ; CHAR FOR CURSOR
    mov ah, 09h                                                ; WRITE CHAR AND ATTRIBUTE
    int 10h
    popa
    ret


print_str_prompt:

    lodsb
    cmp al, 0

    je .done

    mov ah,0xe
    int 10h
    jmp print_str_color

.done:
    call cursor
    ret

print_str_color:
    lodsb
    cmp al, 0
    je .done
    mov ah,0xe
    int 10h
    jmp print_str_color
.done:
    ret