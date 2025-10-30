cpu 8086
org 0x7C00

    ; 1. Configurar memoria para la carga
    mov ax, 0x0800
    mov es, ax
    xor bx, bx

    ; set ah for read sectors
    mov ah, 0x02
    
    ; read from the first drive
    mov al, 1
    
    mov ch, 0
    mov cl, 2
    mov dh, 0

    ; call bios
    int 0x13
    
    jc disk_error

    ; go to 0x8000 
    jmp 0x8000

disk_error: ; error handling
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
.hang:
    jmp .hang

; Boot sector signature
TIMES 510 - ($ - $$) db 0
dw 0xaa55