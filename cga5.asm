   DOSSEG
   .MODEL small
   .CODE

   jmp_addr   DW ?
   ydelta_xor DW ?
   sp_save    DW ?
   iter_save  DW ?

   PUBLIC _cga_draw_line1
_cga_draw_line1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: ES:[DI], BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8191         ; also compute ydelta and ydelta_xor
   jnc line1_y_even
   mov bx, -8113
line1_y_even:
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line1_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0c050h
line1_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 18
   shl ax, 1
   mov si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov ah, [colour]     ; patch colours in
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch1 + 1], ah
   mov BYTE PTR cs:[line1_patch5 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch2 + 1], ah
   mov BYTE PTR cs:[line1_patch6 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch3 + 1], ah
   mov BYTE PTR cs:[line1_patch7 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch4 + 1], ah


   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy
   mov al, es:[di]      ; get first word


   cmp cl, 0            ; check for iterations = 0
   je line1_no_iter


   lea si, si + line1_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line1_loop:
   and al, 03fh         
line1_patch1:
   or al, 040h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy1
   stosb                ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   mov al, [di]
line1_skip_incy1:

   and al, 0cfh
line1_patch2:
   or al, 010h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy2
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   mov al, [di]
line1_skip_incy2:             

   and al, 0f3h
line1_patch3:
   or al, 04h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy3
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   mov al, [di]
line1_skip_incy3:             

   and al, 0fch
line1_patch4:
   or al, 01h
   add dx, sp           ; D += 2*dy
   stosb
   
   jle line1_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   inc di
line1_skip_incy4:             
   mov al, [di]

   loop line1_loop

line1_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line1_done                   

   and al, 03fh         
line1_patch5:
   or al, 040h
   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line1_skip_incy5

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   mov al, [di]
   inc di
line1_skip_incy5:
   dec di

   dec cl
   jz line1_done


   and al, 0cfh         
line1_patch6:
   or al, 010h
   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line1_skip_incy6
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   mov al, [di]
   inc di
line1_skip_incy6:
   dec di

   dec cl
   jz line1_done


   and al, 0f3h         
line1_patch7:
   or al, 04h

   stosb                ; draw pixel

line1_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line1 ENDP

   PUBLIC _cga_draw_line1_11
_cga_draw_line1_11 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: colour, BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8192         ; also compute ydelta and ydelta_xor
   jnc line1_11_y_even
   mov bx, -8112
line1_11_y_even:
   mov WORD PTR cs:[ydelta_xor], 0c050h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line1_11_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
line1_11_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 17
   mov si, ax
   shl ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy
   xor al, al


   cmp cl, 0            ; check for iterations = 0
   je line1_11_no_iter


   lea si, si + line1_11_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line1_11_loop:
   mov al, 0c0h         
   add dx, sp           ; D += 2*dy

   jle line1_11_skip_incy1
   or [di], al          ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line1_11_skip_incy1:

   or al, 030h
   add dx, sp           ; D += 2*dy

   jle line1_11_skip_incy2
   or [di], al          ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line1_11_skip_incy2:             

   or al, 0ch
   add dx, sp           ; D += 2*dy

   jle line1_11_skip_incy3
   or [di], al          ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line1_11_skip_incy3:             

   or al, 03h
   or [di], al          ; write pixel(s)
   add dx, sp           ; D += 2*dy
   
   jle line1_11_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line1_11_skip_incy4:             
   inc di

   loop line1_11_loop

line1_11_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line1_11_done                   

   mov al, 0c0h
   or [di], al          ; draw pixel
   add dx, sp           ; D += 2*dy

   jle line1_11_skip_incy5

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line1_11_skip_incy5:

   dec cl
   jz line1_11_done


   or al, 030h
   or [di], al          ; draw pixel
   add dx, sp           ; D += 2*dy

   jle line1_11_skip_incy6
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line1_11_skip_incy6:

   dec cl
   jz line1_11_done


   or al, 0ch
   or [di], al         ; draw pixel

line1_11_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line1_11 ENDP

   PUBLIC _cga_draw_line1_00
_cga_draw_line1_00 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: colour, BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8192         ; also compute ydelta and ydelta_xor
   jnc line1_00_y_even
   mov bx, -8112
line1_00_y_even:
   mov WORD PTR cs:[ydelta_xor], 0c050h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line1_00_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
line1_00_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 17
   mov si, ax
   shl ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy
   mov al, 0ffh


   cmp cl, 0            ; check for iterations = 0
   je line1_00_no_iter


   lea si, si + line1_00_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line1_00_loop:
   mov al, 03fh         
   add dx, sp           ; D += 2*dy

   jle line1_00_skip_incy1
   and [di], al          ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   mov al, 0ffh
line1_00_skip_incy1:

   and al, 0cfh
   add dx, sp           ; D += 2*dy

   jle line1_00_skip_incy2
   and [di], al          ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   mov al, 0ffh
line1_00_skip_incy2:             

   and al, 0f3h
   add dx, sp           ; D += 2*dy

   jle line1_00_skip_incy3
   and [di], al          ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   mov al, 0ffh
line1_00_skip_incy3:             

   and al, 0fch
   and [di], al          ; write pixel(s)
   add dx, sp           ; D += 2*dy
   
   jle line1_00_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line1_00_skip_incy4:             
   inc di

   loop line1_00_loop

line1_00_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line1_00_done                   

   mov al, 03fh
   and [di], al          ; draw pixel
   add dx, sp           ; D += 2*dy

   jle line1_00_skip_incy5

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   mov al, 0ffh
line1_00_skip_incy5:

   dec cl
   jz line1_00_done


   and al, 0cfh
   and [di], al          ; draw pixel
   add dx, sp           ; D += 2*dy

   jle line1_00_skip_incy6
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   mov al, 0ffh
line1_00_skip_incy6:

   dec cl
   jz line1_00_done


   and al, 0f3h
   and [di], al         ; draw pixel

line1_00_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line1_00 ENDP

   PUBLIC _cga_draw_line_xor1
_cga_draw_line_xor1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: ES:[DI], BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8192         ; also compute ydelta and ydelta_xor
   jnc line_xor1_y_even
   mov bx, -8112
line_xor1_y_even:
   mov WORD PTR cs:[ydelta_xor], 0c050h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line_xor1_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
line_xor1_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 18
   shl ax, 1
   mov si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov ah, [colour]     ; patch colours in
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_xor1_patch1 + 1], ah
   mov BYTE PTR cs:[line_xor1_patch5 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_xor1_patch2 + 1], ah
   mov BYTE PTR cs:[line_xor1_patch6 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_xor1_patch3 + 1], ah
   mov BYTE PTR cs:[line_xor1_patch7 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_xor1_patch4 + 1], ah


   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy
   mov al, es:[di]      ; get first word


   cmp cl, 0            ; check for iterations = 0
   je line_xor1_no_iter


   lea si, si + line_xor1_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line_xor1_loop:
line_xor1_patch1:
   mov al, 040h
   add dx, sp           ; D += 2*dy

   jle line_xor1_skip_incy1
   xor [di], al         ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_xor1_skip_incy1:

line_xor1_patch2:
   or al, 010h
   add dx, sp           ; D += 2*dy

   jle line_xor1_skip_incy2
   xor [di], al         ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_xor1_skip_incy2:             

line_xor1_patch3:
   or al, 04h
   add dx, sp           ; D += 2*dy

   jle line_xor1_skip_incy3
   xor [di], al         ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_xor1_skip_incy3:             

line_xor1_patch4:
   or al, 01h
   xor [di], al
   add dx, sp           ; D += 2*dy
   
   jle line_xor1_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line_xor1_skip_incy4:             
   inc di

   loop line_xor1_loop

line_xor1_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_xor1_done                   

line_xor1_patch5:
   mov al, 040h
   add dx, sp           ; D += 2*dy

   xor [di], al         ; draw pixel

   jle line_xor1_skip_incy5

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_xor1_skip_incy5:

   dec cl
   jz line_xor1_done

   
line_xor1_patch6:
   or al, 010h
   add dx, sp           ; D += 2*dy

   xor [di], al         ; draw pixel

   jle line_xor1_skip_incy6
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_xor1_skip_incy6:

   dec cl
   jz line_xor1_done

   
line_xor1_patch7:
   or al, 04h

   xor [di], al         ; draw pixel

line_xor1_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line_xor1 ENDP

   PUBLIC _cga_draw_line_write1
_cga_draw_line_write1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: ES:[DI], BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8191         ; also compute ydelta and ydelta_xor
   jnc line_write1_y_even
   mov bx, -8113
line_write1_y_even:
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line_write1_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0c050h
line_write1_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 18
   shl ax, 1
   mov si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov ah, [colour]     ; patch colours in
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_write1_patch1 + 1], ah
   mov BYTE PTR cs:[line_write1_patch5 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_write1_patch2 + 1], ah
   mov BYTE PTR cs:[line_write1_patch6 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_write1_patch3 + 1], ah
   mov BYTE PTR cs:[line_write1_patch7 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line_write1_patch4 + 1], ah


   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy
   mov al, es:[di]      ; get first word


   cmp cl, 0            ; check for iterations = 0
   je line_write1_no_iter


   lea si, si + line_write1_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line_write1_loop:         
line_write1_patch1:
   mov al, 040h
   add dx, sp           ; D += 2*dy

   jle line_write1_skip_incy1
   stosb                ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_write1_skip_incy1:

line_write1_patch2:
   or al, 010h
   add dx, sp           ; D += 2*dy

   jle line_write1_skip_incy2
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_write1_skip_incy2:             

line_write1_patch3:
   or al, 04h
   add dx, sp           ; D += 2*dy

   jle line_write1_skip_incy3
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_write1_skip_incy3:             

line_write1_patch4:
   or al, 01h
   add dx, sp           ; D += 2*dy
   stosb
   
   jle line_write1_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   inc di
line_write1_skip_incy4:             
   xor al, al

   loop line_write1_loop

line_write1_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_write1_done                   
         
line_write1_patch5:
   mov al, 040h
   add dx, sp           ; D += 2*dy

   dec cl
   jz line_write1_last_write

   jle line_write1_skip_incy5
   stosb                ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   xor al, al
line_write1_skip_incy5:

         
line_write1_patch6:
   or al, 010h
   add dx, sp           ; D += 2*dy

   dec cl
   jz line_write1_last_write

   jle line_write1_skip_incy6
   stosb                ; draw pixel
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   xor al, al
line_write1_skip_incy6:


line_write1_patch7:
   or al, 04h

line_write1_last_write:
   stosb                ; draw pixel

line_write1_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line_write1 ENDP

   PUBLIC _cga_draw_line_blank1
_cga_draw_line_blank1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AL: ES:[DI], BX: ydelta, CX: Loop, DX: D, SP: 2*dy, BP: 2*dx,
   ; SI: ydelta_xor, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS


   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov bx, 8191         ; also compute ydelta and ydelta_xor
   jnc line_blank1_y_even
   mov bx, -8113
line_blank1_y_even:
   mov WORD PTR cs:[ydelta_xor], 0ffb0h
   sbb di, 0
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax


   mov ax, [x0]         ; compute loop iterations

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   
   mov cx, [xend] 
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4


   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp


   mov sp, [ydiff]      ; fixups for +ve/-ve slope
   cmp sp, 0

   jge line_blank1_pos
   neg sp
   sub bx, 80           ; correct ydelta and ydelta_xor
   mov WORD PTR cs:[ydelta_xor], 0c050h
line_blank1_pos:

   shl sp, 1            ; compute 2*dy
            

   mov dx, [D]          ; store D


   mov ax, [x0]         ; compute jump offset
   and ax, 3            ; multiply x mod 4 by 18
   shl ax, 1
   mov si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax


   mov ah, [colour]     ; compute colour byte
   mov al, ah
   ror ah, 1
   ror ah, 1
   add al, ah
   ror ah, 1
   ror ah, 1
   add al, ah
   ror ah, 1
   ror ah, 1
   add al, ah

   mov bp, [xdiff]      ; compute 2*dx
   shl bp, 1


   sub dx, sp           ; compensate for first addition of 2*dy


   cmp cl, 0            ; check for iterations = 0
   je line_blank1_no_iter


   lea si, si + line_blank1_loop ; computed jump into loop
   mov cs:[jmp_addr], si


   mov si, cs:[ydelta_xor] ; restore ydelta_xor


   jmp cs:[jmp_addr]

line_blank1_loop:
   add dx, sp           ; D += 2*dy

   jle line_blank1_skip_incy1
   stosb                ; draw pixel

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line_blank1_skip_incy1:

   add dx, sp           ; D += 2*dy

   jle line_blank1_skip_incy2
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line_blank1_skip_incy2:             

   add dx, sp           ; D += 2*dy

   jle line_blank1_skip_incy3
   stosb                ; draw pixel(s)

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
line_blank1_skip_incy3:             

   add dx, sp           ; D += 2*dy
   stosb
   
   jle line_blank1_skip_incy4
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx
   inc di
line_blank1_skip_incy4:             

   loop line_blank1_loop

line_blank1_no_iter:

   mov cx, cs:[iter_save]  ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_blank1_done                   

   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line_blank1_skip_incy5

   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   inc di
line_blank1_skip_incy5:
   dec di

   dec cl
   jz line_blank1_done


   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line_blank1_skip_incy6
 
   add di, bx           ; odd <-> even line (reenigne's trick)
   xor bx, si           ; adjust ydelta

   sub dx, bp           ; D -= 2*dx

   inc di
line_blank1_skip_incy6:
   dec di

   dec cl
   jz line_blank1_done


   stosb                ; draw pixel

line_blank1_done:

   mov sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line_blank1 ENDP

   PUBLIC _cga_draw_line2
_cga_draw_line2 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
   ; line from (x0, y0) - (?, yend) including endpoints
   ; AL: colour, BX: 2*dx - 2*dy, CX: Loop, DX: D
   ; SI: 2*dy, DI: Offset, DS:B800, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS



   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb di, 0
   and di, 8192
   shl ax, 1            ; round y0 down to multiple of 2
   
   mov cx, [yend]       ; also compute iterations
   sub cx, ax
   inc cx
   mov cs:[iter_save], cx  ; save iterations for prologue

   shr cx, 1            ; we will unroll by 2 so divide by 2

   shl ax, 1            ; continue computing offset for line y0
   shl ax, 1
   shl ax, 1

   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov ax, [x0]         ; adjust offset for column x0

   shr ax, 1            
   shr ax, 1
   add di, ax


   mov ax, [x0]         ; compute jump offset
   
   ; TODO: fiddle bits of ax for 1423 ordering

   and ax, 3            ; multiply x mod 4 by 38
   shl ax, 1
   mov si, ax
   shl al, 1
   add si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax

   mov ah, [colour]     ; patch colours in
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch1 + 1], ah
   mov BYTE PTR cs:[line2_patch2 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch5 + 1], ah
   mov BYTE PTR cs:[line2_patch6 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch7 + 1], ah
   mov BYTE PTR cs:[line2_patch8 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch3 + 1], ah
   mov BYTE PTR cs:[line2_patch4 + 1], ah


   cmp cl, 0            ; check for iterations = 0
   jne line2_iter
   jmp line2_no_iter
line2_iter:

   lea si, si + line2_loop1 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov bx, [xdiff]      ; compute 2*dx - 2*dy
   shl bx, 1
   sub bx, si
           
   mov dx, [D]          ; store D
   add dx, si           ; shift D by 2*dy so jumps are correct   

   jmp cs:[jmp_addr]


line2_loop1:

   mov al, [di]
   and al, 03fh
line2_patch1:
   or al, 0c0h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx21
   add dx, si           ; D += 2*dy
line2_incx11:
   add di, 8191

   mov al, [di]
   and al, 03fh
line2_patch2:
   or al, 0c0h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx22
   add dx, si           ; D += 2*dy
line2_incx12:
   sub di, 8113

   loop line2_loop1
   jmp line2_no_iter
   

line2_loop4:

   mov al, [di]
   and al, 0fch
line2_patch3:
   or al, 03h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   inc di               ; move to next byte, maybe?
   jg line2_incx11
   dec di
   add dx, si           ; D += 2*dy
line2_incx41:
   add di, 8191

   mov al, [di]
   and al, 0fch
line2_patch4:
   or al, 03h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   inc di               ; move to next byte, maybe?
   jg line2_incx12
   dec di
   add dx, si           ; D += 2*dy
line2_incx42:
   sub di, 8113

   loop line2_loop4
   jmp line2_no_iter


line2_loop2:

   mov al, [di]
   and al, 0cfh
line2_patch5:
   or al, 030h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx31
   add dx, si           ; D += 2*dy
line2_incx21:
   add di, 8191

   mov al, [di]
   and al, 0cfh
line2_patch6:
   or al, 030h
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx32
   add dx, si           ; D += 2*dy
line2_incx22:
   sub di, 8113

   loop line2_loop2
   jmp line2_no_iter


line2_loop3:

   mov al, [di]
   and al, 0f3h
line2_patch7:
   or al, 0ch
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx41
   add dx, si           ; D += 2*dy
line2_incx31:
   add di, 8191

   mov al, [di]
   and al, 0f3h
line2_patch8:
   or al, 0ch
   stosb
   add dx, bx           ; D += 2*dx - 2*dy
   jg line2_incx42
   add dx, si           ; D += 2*dy
line2_incx32:
   sub di, 8113

   loop line2_loop3

line2_no_iter:

   ; TODO: final iteration

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line2 ENDP

   END