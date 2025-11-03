org 0x500
jmp 0x0000:start

runningKernel db 'Rodando Kernel...', 0


print_string:
	lodsb
	cmp al,0
	je end

	mov ah, 0eh
	mov bl, 15
	int 10h

	mov dx, 0
	.delay_print:
	inc dx
	mov cx, 0
		.time:
			inc cx
			cmp cx, 10000
			jne .time

	cmp dx, 1000
	jne .delay_print

	jmp print_string

	end:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, runningKernel
    call print_string


    reset:
        mov ah, 00h
        mov dl, 0
        int 13h

        jc reset

        jmp load_kernel

    load_kernel:
        mov ax,0x7E0
        mov es,ax
        xor bx,bx

        mov ah, 0x02
        mov al, 20
        mov ch, 0
        mov cl, 3
        mov dh, 0
        mov dl, 0
        int 13h

        jc load_kernel

        jmp 0x7e00

  


    times 510-($-$$) db 0
    dw 0xaa55	