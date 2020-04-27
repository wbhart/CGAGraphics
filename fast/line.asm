   DOSSEG
   .MODEL small
   .CODE

   jmp_addr       DW ?
   line_vd_jmptab DW line_vd0, line_vd1, line_vd2, line_vd3

   PUBLIC _cga_draw_line
_cga_draw_line PROC
   ARG x0:WORD, y0:WORD, x1:WORD, y1:WORD, colour:BYTE
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   mov dx, [x1]         ; compute dx
   sub dx, [x0]
   jbe line_dx_pos      ; if x1 < x0 switch line endpoints
   mov ax, [x0]         ; line must always be right moving
   xchg ax, [x1]
   mov [x0], ax
   mov ax, [y0]
   xchg ax, [y1]
   mov [y0], ax
   neg dx
line_dx_pos:

   xor di, di           ; compute offset for line y0       
   shr ax, 1            ; add 8192 to offset if odd line
   sbb di, 0
   and di, 8192
   shl ax, 1            ; add 80*y0 to offset
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax
   mov ax, [x0]         ; add x0/4 to offset
   shr ax, 1
   shr ax, 1
   add di, ax

   mov si, [x0]         ; compute 2*(x0 mod 4)
   and si, 3
   shl si, 1

   mov cl, 6            ; compute colour shift
   sub cx, si

   mov bx, [y1]         ; compute dy
   sub bx, [y0]
   jae line_down
   
   neg bx
   cmp bx, dx
   
   jbe line_goto_hu
   jmp line_vu   
line_goto_hu:
   jmp line_hu

line_down:

   cmp bx, dx
   
   ja line_vd
   jmp line_hd   

line_vd:                ; verticalish, down

   mov si, cs:[line_vd_jmptab + si]
   mov cs:[jmp_addr], si

   shl ax, 1            ; round x0 down to multiple of 4
   shl ax, 1
   mov si, [x1]         ; compute iterations, unrolled by 4
   sub si, ax
   inc si
   push si              ; save iterations for prologue
   shr si, 1            ; divide iterations by 4
   shr si, 1

   mov ah, [colour]     ; initial colour shift
   shl ah, cl

   mov cx, si           ; get iterations

   shl bx, 1            ; compute 2*dy
   xor si, si           ; D = -dx
   sub si, dx
   shl dx, 1            ; compute 2*dx

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8191
   jnc line_vd_even
   sub bp, 16304
line_vd_even:

   mov al, [di]         ; get initial graphics byte

   cmp cl, 0            ; check for zero iterations
   je line_vd_no_iter

   jmp WORD PTR cs:[jmp_addr]

line_vd0:
   and al, 03fh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   jle line_skip_incy_vd0
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_vd0:

line_vd1:
   and al, 0cfh
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   jle line_skip_incy_vd1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_vd1:

line_vd2:
   and al, 0f3h
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   jle line_skip_incy_vd2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_vd2:             

line_vd3:
   and al, 0fch
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_vd3
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_vd3:             

   mov al, [di]
   loop line1_loop

line_vd_no_iter:

   pop cx               ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_vd_done                   

   and al, 03fh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_vd4

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_vd4:
   dec di

   dec cl
   jz line_vd_done

   and al, 0cfh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_vd5
 
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_vd5:
   dec di

   dec cl
   jz line_vd_done

   and al, 0f3h         
   or al, ah

   stosb                ; draw pixel

line_vd_done:        
 
   pop ds
   pop si
   pop di
   pop bp
   ret

line_hd:

   pop ds
   pop si
   pop di
   pop bp
   ret

line_hu:

   pop ds
   pop si
   pop di
   pop bp
   ret

line_hd:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line ENDP

   END