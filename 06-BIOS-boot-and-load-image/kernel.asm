org 0x7e00
jmp 0x0000:start

data:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;STRINGS;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mensagemi db 'theOS - Ver 0.1',13,10,'Iniciando...',13,10,0
    sprompt db 13,10,'MY-PC>',0

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;GLOBAL VARIABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cor db 3                                                         ; TEXT COLOR
    state dw 0                                                       ; STATE VARIABLE 

start:
    xor ax, ax                                                       ;
    mov ds, ax                                                       ; INITIALIZE DATA SEGMENT
    mov es, ax                                                       ;

    call init_video                                                  ; INITIALIZE VIDEO MODE

    mov ax, homescreen_fn                                            ; START STATE MODE
    mov [state], ax

.loop:                                                               ; MAIN LOOP 
    mov ax, [state]                                                  ;
    call eax                                                         ; CALL FUNCTION IN STATE
    jmp .loop

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;STATE FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

homescreen_fn:
    mov si, mensagemi
    mov bl, 14                                                        ; yellow
    call print_str_color
    call exit_to_shell
    ret                                                               ; back to main loop

shell_fn:
    mov si, sprompt
    mov bl, 14                                                        ; yellow
    call print_str_color
    jmp $ 

exit_to_shell:
    mov ax, shell_fn
    mov [state], ax
    ret

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;DRIVERS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_video:
    mov ah, 00h
    mov al, 13h
    int 10h
    ret

    ;;;;;;;;;;;;;;;;;;;;;;TEXT PRINT FUNCTION;;;;;;;;;;;;;;;;;;;
print_char:
    pusha
    mov bl, [cor]
    mov ah, 0xe
    int 10h
    popa
    ret

cursor:
    pusha
    mov bl, 10                                                        ; COLOR
    mov bh, 0
    mov cx, 1
    mov al, '_'                                                       ; CHAR FOR CURSOR
    mov ah, 09h                                                       ; WRITE CHAR AND ATTRIBUTE
    int 10h
    popa
    ret

print_str_color:
    lodsb
    cmp al, 0
    je .done

    mov ah,0xe
    int 10h
    jmp print_str_color

.done:
    call cursor
    ret