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