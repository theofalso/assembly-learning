cpu 8086             ;  use 8086 instruction set
org 0x7C00

;clean screen
mov ah, 0x06 ; scroll up function
 mov al, 0x00 ; clear window
 mov bh, 0x07
 mov cx, 0x0000 ; top left corner 0.0 to 24 79 bottom right corner
 mov dx, 0x184F ; call te bios
 int 0x10

 ;set up to print
 mov si, string ; source index, pointer  to the string
 mov bh, 0x00; use the video page 1
 ; set the starter position of the cursor
 mov dh, 1; 1
 mov dl, 1; 1
 
.print_char: ; this is the print loop
 mov al, [si]; load up char
 cmp al, 0 ; is null?
 je .move_cursor_down; is yes move the cursor down

 mov ah, 0x02 ; set cursor bios function
 int 0x10

  ;print char
  mov ah, 0x09; write char bios function
  mov bl, 0x0A ; color green
  mov cx, 1; char amount
  int 0x10;       call the bios!

  ;go on
 inc si; next char
  inc dl; move cursor
    mov ah, 0x02 ; set cursor bios function
    int 0x10

; little delay 
  push dx;save the cursor position, then pop
  mov ah, 0x86 ; bios wait function
 mov cx, 0x0007 ; high part of hexadecimal representation for 500000 (mili seconds)
 mov dx, 0xA120; low part
 int 0x15 ; call bios, this destroy dx for that reason we save it
  pop dx

 jmp .print_char ; jump to loop

.move_cursor_down:
 inc dh; next file
 mov dl, 1; allign to start
 mov ah, 0x02
 int 0x10
.done:
 hlt

string db 'Wake up Neo...', 0 ; our null

TIMES 510 - ($ - $$) db 0 ; pad the file with 0s up to 510 bytes
dw 0xaa55 ;                                      magic number!