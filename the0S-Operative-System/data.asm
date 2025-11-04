data:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;STRINGS;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mensagemi db 'theOS - Ver 0.1',13,10,'Iniciando...',13,10,0
    sprompt db 13,10,'MY-PC1>',0
    commands db 'help - list of commands.', 13,10,'clear - clear the screen.',13,10,'about - Shows system information.',13,10,'echo [msg] - Prints [msg] to the screen.',13,10,0
    error_msg db 'Command not found. Type "help" for a list of commands.',13,10,0
    about_msg db 'theoOS - An experimental operating system developed by theofalso.',13,10,0

    arg TIMES 64 db 0                                          ; INPUT BUFFER


    ;;;;;;;;;;;;;;;;;;;;;;JUMP TABLE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    ; Key: 0            1             2  3           4   5   6         7   8   9   10  11
    ; Letter:  a,       b, c,        d,  e,          f,  g,  h,        i,  j,  k,  l
    ctable dw about_fn, ef, clear_fn, ef, echo_fn , ef, ef, help_fn, ef, ef, ef, ef
    ;
    ; Key: 12  13  14  15  16  17  18  19  20  21  22  23  24  25
    ; Letter:  m,  n,  o,  p,  q,  r,  s,  t,  u,  v,  w,  x,  y,  z
           dw ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef, ef


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;GLOBAL VARIABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cor db 3                                                   ; TEXT COLOR
    state dw 0                                                 ; STATE VARIABLE 
