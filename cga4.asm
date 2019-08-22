   DOSSEG
   .MODEL small
   .CODE
   
   PUBLIC _cga_draw_line1
_cga_draw_line1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AX: Acc, BX: 2*dx, DX: 2*dy, CX: Loop, BP: ydelta
   ; SI: D, DI: Offset, DS: Colour/Mask, ES: B800
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set segment for CGA memory
   mov es, ax

   xor di, di           ; compute offset for line y0
   mov ax, [y0]
   shr ax, 1

   mov bx, 8192         ; also compute ydelta
   jnc line1_y_even
   mov bx, -8112
line1_y_even:
   push bx

   sbb di, 0            ; continue computing offset for line y0
   and di, 8192
   mov cl, 4        
   shl ax, cl
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov bx, [xdiff]      ; compute 2*dx
   shl bx, 1

   mov dx, [ydiff]      ; compute 2*dy
   shl dx, 1

line1_yinc:

   mov si, [D]          ; store D

   mov cx, [x0]         ; set up colour and mask
   and cl, 3            ; multiply x mod 4 by 20
   shl cl, 1
   shl cl, 1
   mov al, cl
   shl cl, 1
   shl cl, 1
   add al, cl
   xor ah, ah
   mov ds, ax
   mov ah, [colour] 

   mov ax, [x0]         ; get x0
   
   mov cx, [xend]       ; compute loop iterations
   pop bp               ; (get ydelta here so we can push below)
   sub cx, ax
   inc cx
   push cx              ; save iterations for prologue
   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   sub si, dx           ; compensate for first addition of 2*dy

   cli
   mov WORD PTR cs:[line1_patch1 + 1], sp
   mov sp, dx

   mov ax, ds           ; get jump offset
   
   mov dx, si
   mov si, ax
   lea si, si + line1_loop
   jmp si
line1_loop:
   mov al, 03fh         
   and al, es:[di]      ; draw pixel at x, y
   or al, 040h
   add dx, sp           ; D += 2*dy
   stosb

   jle line1_skip_incy1

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, -16304       ; adjust ydelta

   sub dx, bx           ; D -= 2*dx
line1_skip_incy1:             
   dec di               ; adjust offset


   mov al, 0cfh
   and al, es:[di]      ; draw pixel at x, y
   or al, 010h
   add dx, sp           ; D += 2*dy
   stosb

   jle line1_skip_incy2

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, -16304       ; adjust ydelta

   sub dx, bx           ; D -= 2*dx
line1_skip_incy2:             
   dec di               ; adjust offset


   mov al, 0f3h
   and al, es:[di]      ; draw pixel at x, y
   or al, 04h
   add dx, sp           ; D += 2*dy
   stosb

   jle line1_skip_incy3

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, -16304       ; adjust ydelta

   sub dx, bx           ; D -= 2*dx
line1_skip_incy3:             
   dec di               ; adjust offset


   mov al, 0fch
   and al, es:[di]      ; draw pixel at x, y
   or al, 01h
   add dx, sp           ; D += 2*dy
   stosb

   jle line1_skip_incy4

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, -16304       ; adjust ydelta

   sub dx, bx           ; D -= 2*dx
line1_skip_incy4:             

   loop line1_loop

line1_patch1:
   mov sp, 1234
   sti

   pop cx

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line1 ENDP

   END

