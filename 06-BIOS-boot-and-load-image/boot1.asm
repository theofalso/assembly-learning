org 0x7c00
jmp 0x0000:start

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, 0x50 
    mov es, ax
    xor bx, bx   

    jmp reset

reset:
    mov ah, 00h 
    mov dl, 0   
    int 13h

    jc reset

    jmp load

load:
    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 2 
    mov dh, 0
    mov dl, 0
    int 13h

    jc load

    jmp 0x500

times 510-($-$$) db 0
dw 0xaa55s