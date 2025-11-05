org 0x7e00
jmp 0x0000:start



%include "data.asm"
%include "drivers.asm"
%include "shell.asm"









start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    call init_video

    mov ax, homescreen_fn
    mov [state], ax

.loop: 
    mov ax, [state]
    call eax
    jmp .loop



%include "media.asm"
