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
   and ax, 3            ; multiply x mod 4 by 17
   mov si, ax
   shl ax, 1
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

   mov si, cs:[ydelta_xor] ; restore ydelta_xor

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
   and ax, 3            ; multiply x mod 4 by 16
   shl ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax


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

   mov si, cs:[ydelta_xor] ; restore ydelta_xor

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
   and ax, 3            ; multiply x mod 4 by 16
   shl ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax


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

   mov si, cs:[ydelta_xor] ; restore ydelta_xor

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
   and ax, 3            ; multiply x mod 4 by 16
   shl ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax


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

   mov si, cs:[ydelta_xor] ; restore ydelta_xor

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
   and ax, 3            ; multiply x mod 4 by 11
   mov si, ax
   shl ax, 1
   add si, ax
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

   mov si, cs:[ydelta_xor] ; restore ydelta_xor

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
   ; line from (x0, y0) - (?, yend) including endpoints, right moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; set up to deal with odd/even computed jump offset
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov bx, 14           ; adjust computed jump for extra inc/dec 
   cmp al, 3
   jne line2_not4
   add bl, 2            
line2_not4:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 38 bytes
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax    

   mov ah, [colour]     ; patch colours in
   mov BYTE PTR cs:[line2_patch3 + 1], ah
   mov BYTE PTR cs:[line2_patch4 + 1], ah
   mov BYTE PTR cs:[line2_patch12 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch1 + 1], ah
   mov BYTE PTR cs:[line2_patch2 + 1], ah
   mov BYTE PTR cs:[line2_patch10 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch5 + 1], ah
   mov BYTE PTR cs:[line2_patch6 + 1], ah
   mov BYTE PTR cs:[line2_patch9 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line2_patch7 + 1], ah
   mov BYTE PTR cs:[line2_patch8 + 1], ah
   mov BYTE PTR cs:[line2_patch11 + 1], ah


   cmp cl, 0            ; check for iterations = 0
   jne line2_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   mov ah, [colour]
   ror ah, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line2_no_iter
line2_iter:

   lea si, si + line2_loop2 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 79

   jmp cs:[jmp_addr]
   

line2_loop2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
line2_patch5:
   or al, 030h
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx31
   add dx, si           ; D += 2*dy
line2_incx21:

   mov al, [di]
   and al, 0cfh
line2_patch6:
   or al, 030h
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx32
   add dx, si           ; D += 2*dy
line2_incx22:
   add di, sp

   loop line2_loop2
   mov al, 0cfh
line2_patch9:
   mov ah, 030h
   jmp line2_no_iter

line2_loop1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
line2_patch1:
   or al, 0c0h
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx21
   add dx, si           ; D += 2*dy
line2_incx11:

   mov al, [di]
   and al, 03fh
line2_patch2:
   or al, 0c0h
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx22
   add dx, si           ; D += 2*dy
line2_incx12:
   add di, sp

   loop line2_loop1
   mov al, 03fh
line2_patch10:
   mov ah, 0c0h
   jmp line2_no_iter

line2_loop3:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
line2_patch7:
   or al, 0ch
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx41
   add dx, si           ; D += 2*dy
line2_incx31:

   mov al, [di]
   and al, 0f3h
line2_patch8:
   or al, 0ch
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx42
   add dx, si           ; D += 2*dy
line2_incx32:
   add di, sp

   loop line2_loop3
   mov al, 0f3h
line2_patch11:
   mov ah, 0ch
   jmp line2_no_iter

line2_loop4:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
line2_patch3:
   or al, 03h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx11
   dec di
   add dx, si           ; D += 2*dy
line2_incx41:

   mov al, [di]
   and al, 0fch
line2_patch4:
   or al, 03h
   stosb
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_incx12
   dec di
   add dx, si           ; D += 2*dy
line2_incx42:
   add di, sp

   loop line2_loop4
   mov al, 0fch
line2_patch12:
   mov ah, 03h

line2_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line2_done
   and al, [bx+di]
   or al, ah 
   mov [bx+di], al
line2_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line2 ENDP

   PUBLIC _cga_draw_line2_00
_cga_draw_line2_00 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD
   ; line from (x0, y0) - (?, yend) including endpoints, right moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; set up to deal with odd/even computed jump offset
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov bx, 9            ; adjust computed jump for extra inc/dec 
   cmp al, 3
   jne line2_00_not4
   add bl, 2            
line2_00_not4:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 28 bytes
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax    


   cmp cl, 0            ; check for iterations = 0
   jne line2_00_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line2_00_no_iter
line2_00_iter:

   lea si, si + line2_00_loop2 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 80

   jmp cs:[jmp_addr]
   
ALIGN 2
line2_00_loop2:

   and BYTE PTR [bx+di], 0cfh    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx31
   add dx, si           ; D += 2*dy
line2_00_incx21:

   and BYTE PTR [di], 0cfh       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx32
   add dx, si           ; D += 2*dy
line2_00_incx22:
   add di, sp

   loop line2_00_loop2
   mov al, 0cfh
   jmp line2_00_no_iter

ALIGN 2
line2_00_loop1:

   and BYTE PTR [bx+di], 03fh    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx21
   add dx, si           ; D += 2*dy
line2_00_incx11:

   and BYTE PTR [di], 03fh       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx22
   add dx, si           ; D += 2*dy
line2_00_incx12:
   add di, sp

   loop line2_00_loop1
   mov al, 03fh
   jmp line2_00_no_iter

ALIGN 2
line2_00_loop3:

   and BYTE PTR [bx+di], 0f3h    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx41
   add dx, si           ; D += 2*dy
line2_00_incx31:

   and BYTE PTR [di], 0f3h       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx42
   add dx, si           ; D += 2*dy
line2_00_incx32:
   add di, sp

   loop line2_00_loop3
   mov al, 0f3h
   jmp line2_00_no_iter

ALIGN 2
line2_00_loop4:

   and BYTE PTR [bx+di], 0fch    ; reenigne's trick
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx11
   dec di
   add dx, si           ; D += 2*dy
line2_00_incx41:

   and BYTE PTR [di], 0fch       ; reenigne's trick
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_00_incx12
   dec di
   add dx, si           ; D += 2*dy
line2_00_incx42:
   add di, sp

   loop line2_00_loop4
   mov al, 0fch

line2_00_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line2_00_done
   and [bx+di], al
line2_00_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line2_00 ENDP

   PUBLIC _cga_draw_line2_11
_cga_draw_line2_11 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD
   ; line from (x0, y0) - (?, yend) including endpoints, right moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; set up to deal with odd/even computed jump offset
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov bx, 9            ; adjust computed jump for extra inc/dec 
   cmp al, 3
   jne line2_11_not4
   add bl, 2            
line2_11_not4:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 28 bytes
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax    


   cmp cl, 0            ; check for iterations = 0
   jne line2_11_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 03h
   ror al, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line2_11_no_iter
line2_11_iter:

   lea si, si + line2_11_loop2 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 80

   jmp cs:[jmp_addr]
   
ALIGN 2
line2_11_loop2:

   or BYTE PTR [bx+di], 030h     ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx31
   add dx, si           ; D += 2*dy
line2_11_incx21:

   or BYTE PTR [di], 030h        ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx32
   add dx, si           ; D += 2*dy
line2_11_incx22:
   add di, sp

   loop line2_11_loop2
   mov al, 030h
   jmp line2_11_no_iter

ALIGN 2
line2_11_loop1:

   or BYTE PTR [bx+di], 0c0h     ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx21
   add dx, si           ; D += 2*dy
line2_11_incx11:

   or BYTE PTR [di], 0c0h        ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx22
   add dx, si           ; D += 2*dy
line2_11_incx12:
   add di, sp

   loop line2_11_loop1
   mov al, 0c0h
   jmp line2_11_no_iter

ALIGN 2
line2_11_loop3:

   or BYTE PTR [bx+di], 0ch      ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx41
   add dx, si           ; D += 2*dy
line2_11_incx31:

   or BYTE PTR [di], 0ch         ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx42
   add dx, si           ; D += 2*dy
line2_11_incx32:
   add di, sp

   loop line2_11_loop3
   mov al, 0ch
   jmp line2_11_no_iter

ALIGN 2
line2_11_loop4:

   or BYTE PTR [bx+di], 03h      ; reenigne's trick
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx11
   dec di
   add dx, si           ; D += 2*dy
line2_11_incx41:

   or BYTE PTR [di], 03h         ; reenigne's trick
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line2_11_incx12
   dec di
   add dx, si           ; D += 2*dy
line2_11_incx42:
   add di, sp

   loop line2_11_loop4
   mov al, 03h

line2_11_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line2_11_done
   or [bx+di], al
line2_11_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line2_11 ENDP

   PUBLIC _cga_draw_line_blank2
_cga_draw_line_blank2 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
   ; line from (x0, y0) - (?, yend) including endpoints, right moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; set up to deal with odd/even computed jump offset
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov bx, 8            ; adjust computed jump for extra inc/dec 
   cmp al, 3
   jne line_blank2_not4
   add bl, 2            
line_blank2_not4:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 22 bytes
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   shl al, 1
   add si, ax    


   mov al, [colour]     ; duplicate colour 4 times in byte
   mov ah, al
   shl ah, 1
   shl ah, 1
   add al, ah
   mov ah, al
   shl ah, 1
   shl ah, 1
   shl ah, 1
   shl ah, 1
   add al, ah


   cmp cl, 0            ; check for iterations = 0
   jne line_blank2_iter
   xor bx, bx
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line_blank2_no_iter
line_blank2_iter:

   lea si, si + line_blank2_loop2 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 79

   jmp cs:[jmp_addr]
   

line_blank2_loop2:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx31
   add dx, si           ; D += 2*dy
line_blank2_incx21:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx32
   add dx, si           ; D += 2*dy
line_blank2_incx22:
   add di, sp

   loop line_blank2_loop2
   jmp line_blank2_no_iter

line_blank2_loop1:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx21
   add dx, si           ; D += 2*dy
line_blank2_incx11:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx22
   add dx, si           ; D += 2*dy
line_blank2_incx12:
   add di, sp

   loop line_blank2_loop1
   jmp line_blank2_no_iter

line_blank2_loop3:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx41
   add dx, si           ; D += 2*dy
line_blank2_incx31:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx42
   add dx, si           ; D += 2*dy
line_blank2_incx32:
   add di, sp

   loop line_blank2_loop3
   jmp line_blank2_no_iter

line_blank2_loop4:

   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx11
   dec di
   add dx, si           ; D += 2*dy
line_blank2_incx41:

   stosb
   inc di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank2_incx12
   dec di
   add dx, si           ; D += 2*dy
line_blank2_incx42:
   add di, sp

   loop line_blank2_loop4

line_blank2_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line_blank2_done
   mov [bx+di], al
line_blank2_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line_blank2 ENDP

   PUBLIC _cga_draw_line3
_cga_draw_line3 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
   ; line from (x0, y0) - (?, yend) including endpoints, left moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; setup odd/even line computed jump offset
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
   mov bx, 14
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   jnz line3_not1       ; adjust computed offset for extra inc/dec instructions
   add bl, 2
line3_not1:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3         
   shl al, 1            ; multiply x mod 4 by 38 bytes
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   shl al, 1
   shl al, 1
   add si, ax    

   mov ah, [colour]     ; patch colours in
   mov BYTE PTR cs:[line3_patch1 + 1], ah
   mov BYTE PTR cs:[line3_patch2 + 1], ah
   mov BYTE PTR cs:[line3_patch10 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line3_patch3 + 1], ah
   mov BYTE PTR cs:[line3_patch4 + 1], ah
   mov BYTE PTR cs:[line3_patch12 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line3_patch7 + 1], ah
   mov BYTE PTR cs:[line3_patch8 + 1], ah
   mov BYTE PTR cs:[line3_patch11 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line3_patch5 + 1], ah
   mov BYTE PTR cs:[line3_patch6 + 1], ah
   mov BYTE PTR cs:[line3_patch9 + 1], ah


   cmp cl, 0            ; check for iterations = 0
   jne line3_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   mov ah, [colour]
   ror ah, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line3_no_iter
line3_iter:

   lea si, si + line3_loop3 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   neg bp
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 79

   jmp cs:[jmp_addr]
   

line3_loop3:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
line3_patch5:
   or al, 0ch
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx21
   add dx, si           ; D += 2*dy
line3_incx31:

   mov al, [di]
   and al, 0f3h
line3_patch6:
   or al, 0ch
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx22
   add dx, si           ; D += 2*dy
line3_incx32:
   add di, sp

   loop line3_loop3
   mov al, 0f3h
line3_patch9:
   mov ah, 0ch
   jmp line3_no_iter

line3_loop4:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
line3_patch1:
   or al, 03h
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx31
   add dx, si           ; D += 2*dy
line3_incx41:

   mov al, [di]
   and al, 0fch
line3_patch2:
   or al, 03h
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx32
   add dx, si           ; D += 2*dy
line3_incx42:
   add di, sp

   loop line3_loop4
   mov al, 0fch
line3_patch10:
   mov ah, 03h
   jmp line3_no_iter

line3_loop2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
line3_patch7:
   or al, 030h
   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx11
   add dx, si           ; D += 2*dy
line3_incx21:

   mov al, [di]
   and al, 0cfh
line3_patch8:
   or al, 030h
   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx12
   add dx, si           ; D += 2*dy
line3_incx22:
   add di, sp

   loop line3_loop2
   mov al, 0cfh
line3_patch11:
   mov ah, 030h
   jmp line3_no_iter

line3_loop1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
line3_patch3:
   or al, 0c0h
   mov [bx+di], al
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx41
   inc di
   add dx, si           ; D += 2*dy
line3_incx11:

   mov al, [di]
   and al, 03fh
line3_patch4:
   or al, 0c0h
   stosb
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_incx42
   inc di
   add dx, si           ; D += 2*dy
line3_incx12:
   add di, sp

   loop line3_loop1
   mov al, 03fh
line3_patch12:
   mov ah, 0c0h

line3_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line3_done
   and al, [bx+di]
   or al, ah 
   mov [bx+di], al
line3_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line3 ENDP

   PUBLIC _cga_draw_line3_00
_cga_draw_line3_00 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD
   ; line from (x0, y0) - (?, yend) including endpoints, left moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; setup odd/even line computed jump offset
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
   mov bx, 9
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   jnz line3_00_not1    ; adjust computed offset for extra inc/dec instructions
   add bl, 2
line3_00_not1:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3         
   shl al, 1            ; multiply x mod 4 by 28 bytes
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax    


   cmp cl, 0            ; check for iterations = 0
   jne line3_00_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line3_00_no_iter
line3_00_iter:

   lea si, si + line3_00_loop3 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   neg bp
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 80

   jmp cs:[jmp_addr]
   
ALIGN 2
line3_00_loop3:

   and BYTE PTR [bx+di], 0f3h    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx21
   add dx, si           ; D += 2*dy
line3_00_incx31:

   and BYTE PTR [di], 0f3h       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx22
   add dx, si           ; D += 2*dy
line3_00_incx32:
   add di, sp

   loop line3_00_loop3
   mov al, 0f3h
   jmp line3_00_no_iter

ALIGN 2
line3_00_loop4:

   and BYTE PTR [bx+di], 0fch    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx31
   add dx, si           ; D += 2*dy
line3_00_incx41:

   and BYTE PTR [di], 0fch       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx32
   add dx, si           ; D += 2*dy
line3_00_incx42:
   add di, sp

   loop line3_00_loop4
   mov al, 0fch
   jmp line3_00_no_iter

ALIGN 2
line3_00_loop2:

   and BYTE PTR [bx+di], 0cfh    ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx11
   add dx, si           ; D += 2*dy
line3_00_incx21:

   and BYTE PTR [di], 0cfh       ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx12
   add dx, si           ; D += 2*dy
line3_00_incx22:
   add di, sp

   loop line3_00_loop2
   mov al, 0cfh
   jmp line3_00_no_iter

ALIGN 2
line3_00_loop1:

   and BYTE PTR [bx+di], 03fh    ; reenigne's trick
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx41
   inc di
   add dx, si           ; D += 2*dy
line3_00_incx11:

   and BYTE PTR [di], 03fh       ; reenigne's trick
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_00_incx42
   inc di
   add dx, si           ; D += 2*dy
line3_00_incx12:
   add di, sp

   loop line3_00_loop1
   mov al, 03fh

line3_00_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line3_00_done
   and [bx+di], al
line3_00_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line3_00 ENDP

   PUBLIC _cga_draw_line3_11
_cga_draw_line3_11 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD
   ; line from (x0, y0) - (?, yend) including endpoints, left moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; setup odd/even line computed jump offset
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
   mov bx, 9
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   jnz line3_11_not1    ; adjust computed offset for extra inc/dec instructions
   add bl, 2
line3_11_not1:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3         
   shl al, 1            ; multiply x mod 4 by 28 bytes
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax    


   cmp cl, 0            ; check for iterations = 0
   jne line3_11_iter
   xor bx, bx
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 03h
   ror al, cl
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line3_11_no_iter
line3_11_iter:

   lea si, si + line3_11_loop3 ; computed jump into loop
   mov cs:[jmp_addr], si

   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   neg bp
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 80

   jmp cs:[jmp_addr]
   
ALIGN 2
line3_11_loop3:

   or BYTE PTR [bx+di], 0ch      ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx21
   add dx, si           ; D += 2*dy
line3_11_incx31:

   or BYTE PTR [di], 0ch         ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx22
   add dx, si           ; D += 2*dy
line3_11_incx32:
   add di, sp

   loop line3_11_loop3
   mov al, 0ch
   jmp line3_11_no_iter

ALIGN 2
line3_11_loop4:

   or BYTE PTR [bx+di], 03h      ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx31
   add dx, si           ; D += 2*dy
line3_11_incx41:

   or BYTE PTR [di], 03h         ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx32
   add dx, si           ; D += 2*dy
line3_11_incx42:
   add di, sp

   loop line3_11_loop4
   mov al, 03h
   jmp line3_11_no_iter

ALIGN 2
line3_11_loop2:

   or BYTE PTR [bx+di], 030h     ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx11
   add dx, si           ; D += 2*dy
line3_11_incx21:

   or BYTE PTR [di], 030h        ; reenigne's trick
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx12
   add dx, si           ; D += 2*dy
line3_11_incx22:
   add di, sp

   loop line3_11_loop2
   mov al, 030h
   jmp line3_11_no_iter

ALIGN 2
line3_11_loop1:

   or BYTE PTR [bx+di], 0c0h     ; reenigne's trick
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx41
   inc di
   add dx, si           ; D += 2*dy
line3_11_incx11:

   or BYTE PTR [di], 0c0h        ; reenigne's trick
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line3_11_incx42
   inc di
   add dx, si           ; D += 2*dy
line3_11_incx12:
   add di, sp

   loop line3_11_loop1
   mov al, 0c0h

line3_11_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line3_11_done
   or [bx+di], al
line3_11_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line3_11 ENDP

   PUBLIC _cga_draw_line_blank3
_cga_draw_line_blank3 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
   ; line from (x0, y0) - (?, yend) including endpoints, left moving
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

   xor si, si           ; clear computed jump offset

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   sbb si, 0            ; setup odd/even line computed jump offset
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
   mov bx, 8
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   jnz line_blank3_not1       ; adjust computed offset for extra inc/dec instructions
   add bl, 2
line_blank3_not1:
   and si, bx
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3         
   shl al, 1            ; multiply x mod 4 by 22 bytes
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   shl al, 1
   add si, ax    

   mov al, [colour]     ; duplicate colour 4 times in byte
   mov ah, al
   shl ah, 1
   shl ah, 1
   add al, ah
   mov ah, al
   shl ah, 1
   shl ah, 1
   shl ah, 1
   shl ah, 1
   add al, ah
   
   cmp cl, 0            ; check for iterations = 0
   jne line_blank3_iter
   xor bx, bx
   push bp
   cli
   mov WORD PTR cs:[sp_save], sp
   jmp line_blank3_no_iter
line_blank3_iter:

   lea si, si + line_blank3_loop3 ; computed jump into loop
   mov cs:[jmp_addr], si
   
   mov si, [ydiff]      ; compute 2*dy
   shl si, 1            

   mov dx, [D]          ; store D
   
   push bp              ; free up bp
   mov bp, [xdiff]      ; compute 2*dx - 2*dy
   neg bp
   shl bp, 1
   sub bp, si
           
   sub dx, bp           ; compensate D for first addition of 2*dx - 2*dy  
   mov bx, -8192
   add di, 8192         ; compensate for subtraction of 8192

   cli
   mov WORD PTR cs:[sp_save], sp
   mov sp, 79

   jmp cs:[jmp_addr]
   

line_blank3_loop3:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx21
   add dx, si           ; D += 2*dy
line_blank3_incx31:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx22
   add dx, si           ; D += 2*dy
line_blank3_incx32:
   add di, sp

   loop line_blank3_loop3
   jmp line_blank3_no_iter

line_blank3_loop4:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx31
   add dx, si           ; D += 2*dy
line_blank3_incx41:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx32
   add dx, si           ; D += 2*dy
line_blank3_incx42:
   add di, sp

   loop line_blank3_loop4
   jmp line_blank3_no_iter

line_blank3_loop2:

   mov [bx+di], al
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx11
   add dx, si           ; D += 2*dy
line_blank3_incx21:

   stosb
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx12
   add dx, si           ; D += 2*dy
line_blank3_incx22:
   add di, sp

   loop line_blank3_loop2
   jmp line_blank3_no_iter

line_blank3_loop1:

   mov [bx+di], al
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx41
   inc di
   add dx, si           ; D += 2*dy
line_blank3_incx11:

   stosb
   dec di               ; move to next byte, maybe?
   add dx, bp           ; D += 2*dx - 2*dy
   jg line_blank3_incx42
   inc di
   add dx, si           ; D += 2*dy
line_blank3_incx12:
   add di, sp

   loop line_blank3_loop1

line_blank3_no_iter:

   mov sp, WORD PTR cs:[sp_save]
   sti

   pop bp
   test [yend], 1

   jnz line_blank3_done
   mov [bx+di], al
line_blank3_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line_blank3 ENDP

   PUBLIC _cga_draw_circle1
_cga_draw_circle1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8191         ; also compute ydelta and ydelta_xor
   jnc circle1_y_even
   mov sp, -8113
circle1_y_even:
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

   mov dx, [x0]         ; adjust offset for column x0 + r
   add dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx


                        ; compute jump offset    
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 58 bytes
   mov si, ax
   shl al, 1
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax


   lea si, si + circle1_jump2 ; computed jump into loop
   mov cs:[jmp_addr], si


   mov ah, [colour]     ; patch colours in
   mov BYTE PTR cs:[circle1_patch7 + 1], ah
   mov BYTE PTR cs:[circle1_patch8 + 1], ah
   mov BYTE PTR cs:[circle1_patch9 + 1], ah
   mov BYTE PTR cs:[circle1_patch9 + 2], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[circle1_patch3 + 1], ah
   mov BYTE PTR cs:[circle1_patch4 + 1], ah
   mov BYTE PTR cs:[circle1_patch12 + 1], ah
   mov BYTE PTR cs:[circle1_patch12 + 2], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[circle1_patch1 + 1], ah
   mov BYTE PTR cs:[circle1_patch2 + 1], ah
   mov BYTE PTR cs:[circle1_patch11 + 1], ah
   mov BYTE PTR cs:[circle1_patch11 + 2], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[circle1_patch5 + 1], ah
   mov BYTE PTR cs:[circle1_patch6 + 1], ah
   mov BYTE PTR cs:[circle1_patch10 + 1], ah
   mov BYTE PTR cs:[circle1_patch10 + 2], ah


   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0ffb0h

   jmp cs:[jmp_addr]
   
                        ; verticalish part of circle
   ALIGN 2
circle1_jump2:
   mov al, [di+bx]      ; draw pixel above axis
   and al, 0cfh
circle1_patch1:
   or al, 030h
   mov [di+bx], al

   mov al, [di]         ; draw pixel below axis
   and al, 0cfh
circle1_patch2:
   or al, 030h
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x1

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump2
   jmp circle1_donev2   ; done verticalish

circle1_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump2
   jmp circle1_donev2   ; done verticalish
   
   
   ALIGN 2
circle1_jump1:
   mov al, [di+bx]      ; draw pixel above axis
   and al, 03fh
circle1_patch3:
   or al, 0c0h
   mov [di+bx], al

   mov al, [di]         ; draw pixel below axis
   and al, 03fh
circle1_patch4:
   or al, 0c0h
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x4

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump1
   jmp circle1_donev1   ; done verticalish

circle1_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump1
   jmp circle1_donev1   ; done verticalish
   

   ALIGN 2
circle1_jump3:
   mov al, [di+bx]      ; draw pixel above axis
   and al, 0f3h
circle1_patch5:
   or al, 0ch
   mov [di+bx], al

   mov al, [di]         ; draw pixel below axis
   and al, 0f3h
circle1_patch6:
   or al, 0ch
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x2

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump3
   jmp circle1_donev3   ; done verticalish

circle1_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump3
   jmp circle1_donev3   ; done verticalish


      ALIGN 2
circle1_jump4:
   mov al, [di+bx]      ; draw pixel above axis
   and al, 0fch
circle1_patch7:
   or al, 03h
   mov [di+bx], al

   mov al, [di]         ; draw pixel below axis
   and al, 0fch
circle1_patch8:
   or al, 03h
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x3

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump4
   jmp circle1_donev4   ; done verticalish

circle1_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump4
   jmp circle1_donev4   ; done verticalish


                        ; horizontalish part of circle
circle1_donev1:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h1   

circle1_donev2:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h2   

circle1_donev3:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h3   

circle1_donev4:

   neg si               ; D = -D
   jmp circle1_h4   


circle1_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle1_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch
circle1_patch9:
   or ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y4
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh1


circle1_h3:
   and ax, 0f3f3h
circle1_patch10:
   or ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh1


circle1_h2:
   and ax, 0cfcfh
circle1_patch11:
   or ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh2


circle1_h1:
   and ax, 03f3fh
circle1_patch12:
   or ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle1_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle1_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh2

   jmp circle1_h4


circle1_doneh2:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle1 ENDP

   END