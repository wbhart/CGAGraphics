   DOSSEG
   .MODEL small
   .CODE

   jmp_addr       DW ?
   line_hd_jmptab DW line_hd0_0, line_hd0_1, line_hd0_2, line_hd0_3, line_hd1_0, line_hd1_1, line_hd1_2, line_hd1_3, line_hd2_0, line_hd2_1, line_hd2_2, line_hd2_3, line_hd3_0, line_hd3_1, line_hd3_2, line_hd3_3 
   line_hu_jmptab DW line_hu0_0, line_hu0_1, line_hu0_2, line_hu0_3, line_hu1_0, line_hu1_1, line_hu1_2, line_hu1_3, line_hu2_0, line_hu2_1, line_hu2_2, line_hu2_3, line_hu3_0, line_hu3_1, line_hu3_2, line_hu3_3 
   line_vd_jmptab DW line_vd_loop1_0, line_vd_loop1_1, line_vd_loop1_2, line_vd_loop1_3, line_vd_loop2_0, line_vd_loop2_1, line_vd_loop2_2, line_vd_loop2_3
                  DW line_vd_loop3_0, line_vd_loop3_1, line_vd_loop3_2, line_vd_loop3_3, line_vd_loop4_0, line_vd_loop4_1, line_vd_loop4_2, line_vd_loop4_3
                  DW line_vd_incx11_0, line_vd_incx11_1, line_vd_incx11_2, line_vd_incx11_3, line_vd_incx21_0, line_vd_incx21_1, line_vd_incx21_2, line_vd_incx21_3
                  DW line_vd_incx31_0, line_vd_incx31_1, line_vd_incx31_2, line_vd_incx31_3, line_vd_incx41_0, line_vd_incx41_1, line_vd_incx41_2, line_vd_incx41_3
   line_vu_jmptab DW line_vu_loop1_0, line_vu_loop1_1, line_vu_loop1_2, line_vu_loop1_3, line_vu_loop2_0, line_vu_loop2_1, line_vu_loop2_2, line_vu_loop2_3
                  DW line_vu_loop3_0, line_vu_loop3_1, line_vu_loop3_2, line_vu_loop3_3, line_vu_loop4_0, line_vu_loop4_1, line_vu_loop4_2, line_vu_loop4_3
                  DW line_vu_incx11_0, line_vu_incx11_1, line_vu_incx11_2, line_vu_incx11_3, line_vu_incx21_0, line_vu_incx21_1, line_vu_incx21_2, line_vu_incx21_3
                  DW line_vu_incx31_0, line_vu_incx31_1, line_vu_incx31_2, line_vu_incx31_3, line_vu_incx41_0, line_vu_incx41_1, line_vu_incx41_2, line_vu_incx41_3

   PUBLIC _cga_draw_line
_cga_draw_line PROC
   ; Draw a line from (x0, y0) to (x1, y1) in the given colour (0-3) in the CGA buffer buff
   ARG buff:DWORD, x0:WORD, y0:WORD, x1:WORD, y1:WORD, colour:BYTE
   push bp
   mov bp, sp
   push di
   push si
   push ds

   les di, buff         ; set ES to segment for graphics memory (CGA or buffer)
   mov ax, es
   mov ds, ax           ; reflect in DS

   mov dx, [x1]         ; compute dx
   sub dx, [x0]
   jae line_dx_pos      ; if x1 < x0 switch line endpoints
   mov ax, [x0]         ; line must always be right moving
   xchg ax, [x1]
   mov [x0], ax
   mov ax, [y0]
   xchg ax, [y1]
   mov [y0], ax
   neg dx
line_dx_pos:

   mov ax, [y0]         ; compute offset for line y0
   shr ax, 1            ; add 8192 to offset if odd line
   sbb si, si
   and si, 8192
   shl ax, 1            ; add 80*y0 to offset
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add si, ax
   shl ax, 1
   shl ax, 1
   add si, ax
   mov ax, [x0]         ; add x0/4 to offset
   shr ax, 1
   shr ax, 1
   add si, ax
   add di, si
   
   mov si, [x0]         ; compute 2*(x0 mod 4)
   and si, 3
   shl si, 1

   mov cx, 6           ; compute colour shift
   sub cx, si

   shl si, 1            ; compute colour jump
   mov bl, [colour]
   xor bh, bh
   add si, bx
   shl si, 1

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
   
   jb line_hd
   jmp line_vd   

line_hd:                ; horizontalish, down

   mov si, cs:[line_hd_jmptab + si]
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

   mov al, [di]         ; get initial graphics byte

   cmp cl, 0            ; check for zero iterations
   jne line_hd_iter

   mov cx, [x0]
   and cl, 3
   inc cl

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8191
   jnc line_hd_even_no_iter
   sub bp, 16304
line_hd_even_no_iter:

   dec cl
   jnz line_hd_not0
   jmp line_hd_no_iter0
line_hd_not0:

   dec cl
   jnz line_hd_not1
   pop cx
   and cl, 3
   jmp line_hd_no_iter1
line_hd_not1:

   pop cx
   and cl, 3
   dec cl
   jmp line_hd_no_iter2

line_hd_iter:

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8191
   jnc line_hd_even
   sub bp, 16304
line_hd_even:

   jmp WORD PTR cs:[jmp_addr]

line_hd0_0:
   and al, 03fh         
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd0_0
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd0_0:

line_hd1_0:
   and al, 0cfh
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd1_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd1_0:

line_hd2_0:
   and al, 0f3h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd2_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd2_0:             

line_hd3_0:
   and al, 0fch
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hd3_0
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hd3_0:             

   mov al, [di]
   loop line_hd0_0
   jmp line_hd_no_iter0

line_hd0_1:
   and al, 03fh         
   or al, 040h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd0_1
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd0_1:

line_hd1_1:
   and al, 0cfh
   or al, 010h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd1_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd1_1:

line_hd2_1:
   and al, 0f3h
   or al, 04h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd2_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd2_1:             

line_hd3_1:
   and al, 0fch
   or al, 01h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hd3_1
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hd3_1:             

   mov al, [di]
   loop line_hd0_1
   mov ah, 040h
   jmp line_hd_no_iter0

line_hd0_2:
   and al, 03fh         
   or al, 080h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd0_2
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd0_2:

line_hd1_2:
   and al, 0cfh
   or al, 020h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd1_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd1_2:

line_hd2_2:
   and al, 0f3h
   or al, 08h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd2_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd2_2:             

line_hd3_2:
   and al, 0fch
   or al, 02h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hd3_2
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hd3_2:             

   mov al, [di]
   loop line_hd0_2
   mov ah, 080h
   jmp line_hd_no_iter0

line_hd0_3:
   or al, 0c0h         
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd0_3
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd0_3:

line_hd1_3:
   or al, 030h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd1_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd1_3:

line_hd2_3:
   or al, 0ch
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hd2_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hd2_3:             

line_hd3_3:
   or al, 03h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hd3_3
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hd3_3:             

   mov al, [di]
   loop line_hd0_3
   mov ah, 0c0h

line_hd_no_iter0:

   pop cx               ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_hd_done                   

   and al, 03fh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_hd4

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_hd4:
   dec di

line_hd_no_iter1:
   dec cl
   jz line_hd_done

   and al, 0cfh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_hd5
 
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0ffb0h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_hd5:
   dec di

line_hd_no_iter2:
   dec cl
   jz line_hd_done

   and al, 0f3h         
   or al, ah

   stosb                ; draw pixel

line_hd_done:        
 
   pop ds
   pop si
   pop di
   pop bp
   ret

line_vd:                ; verticalish, down

   mov ax, [y0]         ; start rounding y0 down to multiple of 2
   shr ax, 1

   jnc line_vd_even     ; deal with odd starting line
   add si, 32
   sub di, 8192         ; addressing below assumes we started on even line
line_vd_even:

   shl ax, 1            ; finish rounding y0 down to multiple of 2

   mov si, cs:[line_vd_jmptab + si]
   mov cs:[jmp_addr], si

   mov si, [y1]         ; compute iterations
   sub si, ax
   inc si
   shr si, 1            ; divide iterations by 2

   mov ah, [colour]     ; compute shifted colour
   shl ah, cl

   mov cx, si           ; get iterations

   push bp

   cmp cl, 0            ; check for zero iterations
   jne line_vd_iter

   xor bx, bx           ; compute ah and al
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   mov ah, [colour]
   ror ah, cl
   
   jmp line_vd_no_iter
line_vd_iter:

   shl dx, 1            ; compute 2*dx
   mov si, bx           ; compute D
   mov bp, bx
   shl bp, 1            ; compute 2*dy
   sub dx, bp           ; compute 2*dx - 2*dy

   mov bx, -8192
   add di, 8192         ; compensate for first subtraction of 8192

   jmp cs:[jmp_addr]

line_vd_loop2_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx31_0
   add si, bp           ; D += 2*dy
line_vd_incx21_0:

   mov al, [di]
   and al, 0cfh
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx32_0
   add si, bp           ; D += 2*dy  
line_vd_incx22_0:
   add di, 79

   loop line_vd_loop2_0
   mov ax, 0cfh
   jmp line_vd_no_iter

line_vd_loop1_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx21_0
   add si, bp           ; D += 2*dy
line_vd_incx11_0:

   mov al, [di]
   and al, 03fh
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx22_0
   add si, bp           ; D += 2*dy
line_vd_incx12_0:
   add di, 79

   loop line_vd_loop1_0
   mov ax, 03fh
   jmp line_vd_no_iter

line_vd_loop3_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx41_0
   add si, bp           ; D += 2*dy
line_vd_incx31_0:

   mov al, [di]
   and al, 0f3h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx42_0
   add si, bp           ; D += 2*dy
line_vd_incx32_0:
   add di, 79

   loop line_vd_loop3_0
   mov ax, 0f3h
   jmp line_vd_no_iter

line_vd_loop4_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx11_0
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx41_0:

   mov al, [di]
   and al, 0fch
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx12_0
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx42_0:
   add di, 79

   loop line_vd_loop4_0
   mov ax, 0fch
   jmp line_vd_no_iter

line_vd_loop2_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   or al, 010h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx31_1
   add si, bp           ; D += 2*dy
line_vd_incx21_1:

   mov al, [di]
   and al, 0cfh
   or al, 010h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx32_1
   add si, bp           ; D += 2*dy  
line_vd_incx22_1:
   add di, 79

   loop line_vd_loop2_1
   mov ax, 010cfh
   jmp line_vd_no_iter

line_vd_loop1_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   or al, 040h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx21_1
   add si, bp           ; D += 2*dy
line_vd_incx11_1:

   mov al, [di]
   and al, 03fh
   or al, 040h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx22_1
   add si, bp           ; D += 2*dy
line_vd_incx12_1:
   add di, 79

   loop line_vd_loop1_1
   mov ax, 0403fh
   jmp line_vd_no_iter

line_vd_loop3_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   or al, 04h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx41_1
   add si, bp           ; D += 2*dy
line_vd_incx31_1:

   mov al, [di]
   and al, 0f3h
   or al, 04h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx42_1
   add si, bp           ; D += 2*dy
line_vd_incx32_1:
   add di, 79

   loop line_vd_loop3_1
   mov ax, 04f3h
   jmp line_vd_no_iter

line_vd_loop4_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   or al, 01h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx11_1
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx41_1:

   mov al, [di]
   and al, 0fch
   or al, 01h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx12_1
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx42_1:
   add di, 79

   loop line_vd_loop4_1
   mov ax, 01fch
   jmp line_vd_no_iter

line_vd_loop2_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   or al, 020h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx31_2
   add si, bp           ; D += 2*dy
line_vd_incx21_2:

   mov al, [di]
   and al, 0cfh
   or al, 020h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx32_2
   add si, bp           ; D += 2*dy  
line_vd_incx22_2:
   add di, 79

   loop line_vd_loop2_2
   mov ax, 020cfh
   jmp line_vd_no_iter

line_vd_loop1_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   or al, 080h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx21_2
   add si, bp           ; D += 2*dy
line_vd_incx11_2:

   mov al, [di]
   and al, 03fh
   or al, 080h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx22_2
   add si, bp           ; D += 2*dy
line_vd_incx12_2:
   add di, 79

   loop line_vd_loop1_2
   mov ax, 0803fh
   jmp line_vd_no_iter

line_vd_loop3_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   or al, 08h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx41_2
   add si, bp           ; D += 2*dy
line_vd_incx31_2:

   mov al, [di]
   and al, 0f3h
   or al, 08h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx42_2
   add si, bp           ; D += 2*dy
line_vd_incx32_2:
   add di, 79

   loop line_vd_loop3_2
   mov ax, 08f3h
   jmp line_vd_no_iter

line_vd_loop4_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   or al, 02h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx11_2
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx41_2:

   mov al, [di]
   and al, 0fch
   or al, 02h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx12_2
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx42_2:
   add di, 79

   loop line_vd_loop4_2
   mov ax, 02fch
   jmp line_vd_no_iter

line_vd_loop2_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 030h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx31_3
   add si, bp           ; D += 2*dy
line_vd_incx21_3:

   mov al, [di]
   or al, 030h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx32_3
   add si, bp           ; D += 2*dy  
line_vd_incx22_3:
   add di, 79

   loop line_vd_loop2_3
   mov ax, 030cfh
   jmp line_vd_no_iter

line_vd_loop1_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0c0h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx21_3
   add si, bp           ; D += 2*dy
line_vd_incx11_3:

   mov al, [di]
   or al, 0c0h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx22_3
   add si, bp           ; D += 2*dy
line_vd_incx12_3:
   add di, 79

   loop line_vd_loop1_3
   mov ax, 0c03fh
   jmp line_vd_no_iter

line_vd_loop3_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0ch
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx41_3
   add si, bp           ; D += 2*dy
line_vd_incx31_3:

   mov al, [di]
   or al, 0ch
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx42_3
   add si, bp           ; D += 2*dy
line_vd_incx32_3:
   add di, 79

   loop line_vd_loop3_3
   mov ax, 0cf3h
   jmp line_vd_no_iter

line_vd_loop4_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 03h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx11_3
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx41_3:

   mov al, [di]
   or al, 03h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vd_incx12_3
   dec di
   add si, bp           ; D += 2*dy
line_vd_incx42_3:
   add di, 79

   loop line_vd_loop4_3
   mov ax, 03fch

line_vd_no_iter:

   pop bp
   test [y1], 1

   jnz line_vd_done
   and al, [bx+di]
   or al, ah 
   mov [bx+di], al
line_vd_done:

   pop ds
   pop si
   pop di
   pop bp
   ret

line_vu:                ; verticalish, up

   mov ax, [y0]         ; start rounding y0 up to multiple of 2
   inc ax
   shr ax, 1

   jc line_vu_even
   add si, 32
   sub di, 8112         ; addressing below assumes we started on even line
line_vu_even:

   shl ax, 1            ; finish rounding y0 up to multiple of 2

   mov si, cs:[line_vu_jmptab + si]
   mov cs:[jmp_addr], si

   mov si, [y1]         ; compute iterations
   sub si, ax
   neg si
   inc si
   shr si, 1            ; divide iterations by 2

   mov ah, [colour]     ; compute shifted colour
   shl ah, cl

   mov cx, si           ; get iterations

   push bp

   cmp cl, 0            ; check for zero iterations
   jne line_vu_iter

   xor bx, bx           ; compute ah and al
   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   mov ah, [colour]
   ror ah, cl
   
   jmp line_vu_no_iter
line_vu_iter:

   shl dx, 1            ; compute 2*dx
   mov si, bx           ; compute D
   mov bp, bx
   shl bp, 1            ; compute 2*dy
   sub dx, bp           ; compute 2*dx - 2*dy

   mov bx, -8112
   add di, 8112         ; compensate for first subtraction of 8112

   jmp cs:[jmp_addr]

line_vu_loop2_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx31_0
   add si, bp           ; D += 2*dy
line_vu_incx21_0:

   mov al, [di]
   and al, 0cfh
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx32_0
   add si, bp           ; D += 2*dy  
line_vu_incx22_0:
   sub di, 81

   loop line_vu_loop2_0
   mov ax, 0cfh
   jmp line_vu_no_iter

line_vu_loop1_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx21_0
   add si, bp           ; D += 2*dy
line_vu_incx11_0:

   mov al, [di]
   and al, 03fh
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx22_0
   add si, bp           ; D += 2*dy
line_vu_incx12_0:
   sub di, 81

   loop line_vu_loop1_0
   mov ax, 03fh
   jmp line_vu_no_iter

line_vu_loop3_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx41_0
   add si, bp           ; D += 2*dy
line_vu_incx31_0:

   mov al, [di]
   and al, 0f3h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx42_0
   add si, bp           ; D += 2*dy
line_vu_incx32_0:
   sub di, 81

   loop line_vu_loop3_0
   mov ax, 0f3h
   jmp line_vu_no_iter

line_vu_loop4_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx11_0
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx41_0:

   mov al, [di]
   and al, 0fch
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx12_0
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx42_0:
   sub di, 81

   loop line_vu_loop4_0
   mov ax, 0fch
   jmp line_vu_no_iter

line_vu_loop2_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   or al, 010h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx31_1
   add si, bp           ; D += 2*dy
line_vu_incx21_1:

   mov al, [di]
   and al, 0cfh
   or al, 010h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx32_1
   add si, bp           ; D += 2*dy  
line_vu_incx22_1:
   sub di, 81

   loop line_vu_loop2_1
   mov ax, 010cfh
   jmp line_vu_no_iter

line_vu_loop1_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   or al, 040h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx21_1
   add si, bp           ; D += 2*dy
line_vu_incx11_1:

   mov al, [di]
   and al, 03fh
   or al, 040h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx22_1
   add si, bp           ; D += 2*dy
line_vu_incx12_1:
   sub di, 81

   loop line_vu_loop1_1
   mov ax, 0403fh
   jmp line_vu_no_iter

line_vu_loop3_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   or al, 04h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx41_1
   add si, bp           ; D += 2*dy
line_vu_incx31_1:

   mov al, [di]
   and al, 0f3h
   or al, 04h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx42_1
   add si, bp           ; D += 2*dy
line_vu_incx32_1:
   sub di, 81

   loop line_vu_loop3_1
   mov ax, 04f3h
   jmp line_vu_no_iter

line_vu_loop4_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   or al, 01h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx11_1
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx41_1:

   mov al, [di]
   and al, 0fch
   or al, 01h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx12_1
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx42_1:
   sub di, 81

   loop line_vu_loop4_1
   mov ax, 01fch
   jmp line_vu_no_iter

line_vu_loop2_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   or al, 020h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx31_2
   add si, bp           ; D += 2*dy
line_vu_incx21_2:

   mov al, [di]
   and al, 0cfh
   or al, 020h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx32_2
   add si, bp           ; D += 2*dy  
line_vu_incx22_2:
   sub di, 81

   loop line_vu_loop2_2
   mov ax, 020cfh
   jmp line_vu_no_iter

line_vu_loop1_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   or al, 080h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx21_2
   add si, bp           ; D += 2*dy
line_vu_incx11_2:

   mov al, [di]
   and al, 03fh
   or al, 080h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx22_2
   add si, bp           ; D += 2*dy
line_vu_incx12_2:
   sub di, 81

   loop line_vu_loop1_2
   mov ax, 0803fh
   jmp line_vu_no_iter

line_vu_loop3_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   or al, 08h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx41_2
   add si, bp           ; D += 2*dy
line_vu_incx31_2:

   mov al, [di]
   and al, 0f3h
   or al, 08h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx42_2
   add si, bp           ; D += 2*dy
line_vu_incx32_2:
   sub di, 81

   loop line_vu_loop3_2
   mov ax, 08f3h
   jmp line_vu_no_iter

line_vu_loop4_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fch
   or al, 02h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx11_2
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx41_2:

   mov al, [di]
   and al, 0fch
   or al, 02h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx12_2
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx42_2:
   sub di, 81

   loop line_vu_loop4_2
   mov ax, 02fch
   jmp line_vu_no_iter

line_vu_loop2_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 030h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx31_3
   add si, bp           ; D += 2*dy
line_vu_incx21_3:

   mov al, [di]
   or al, 030h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx32_3
   add si, bp           ; D += 2*dy  
line_vu_incx22_3:
   sub di, 81

   loop line_vu_loop2_3
   mov ax, 030cfh
   jmp line_vu_no_iter

line_vu_loop1_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0c0h
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx21_3
   add si, bp           ; D += 2*dy
line_vu_incx11_3:

   mov al, [di]
   or al, 0c0h
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx22_3
   add si, bp           ; D += 2*dy
line_vu_incx12_3:
   sub di, 81

   loop line_vu_loop1_3
   mov ax, 0c03fh
   jmp line_vu_no_iter

line_vu_loop3_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0ch
   mov [bx+di], al
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx41_3
   add si, bp           ; D += 2*dy
line_vu_incx31_3:

   mov al, [di]
   or al, 0ch
   stosb
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx42_3
   add si, bp           ; D += 2*dy
line_vu_incx32_3:
   sub di, 81

   loop line_vu_loop3_3
   mov ax, 0cf3h
   jmp line_vu_no_iter

line_vu_loop4_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 03h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx11_3
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx41_3:

   mov al, [di]
   or al, 03h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; D += 2*dx - 2*dy
   jg line_vu_incx12_3
   dec di
   add si, bp           ; D += 2*dy
line_vu_incx42_3:
   sub di, 81

   loop line_vu_loop4_3
   mov ax, 03fch

line_vu_no_iter:

   pop bp
   test [y1], 1

   jnz line_vu_done
   and al, [bx+di]
   or al, ah 
   mov [bx+di], al
line_vu_done:

   pop ds
   pop si
   pop di
   pop bp
   ret

line_hu:                ; horizontalish, up

   mov si, cs:[line_hu_jmptab + si]
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

   mov al, [di]         ; get initial graphics byte

   cmp cl, 0            ; check for zero iterations
   jne line_hu_iter

   mov cx, [x0]
   and cl, 3
   inc cl

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8111
   jnc line_hu_even_no_iter
   sub bp, 16304
line_hu_even_no_iter:

   dec cl
   jnz line_hu_not0
   jmp line_hu_no_iter0
line_hu_not0:

   dec cl
   jnz line_hu_not1
   pop cx
   and cl, 3
   jmp line_hu_no_iter1
line_hu_not1:

   pop cx
   and cl, 3
   dec cl
   jmp line_hu_no_iter2

line_hu_iter:

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8111
   jnc line_hu_even
   sub bp, 16304
line_hu_even:

   jmp WORD PTR cs:[jmp_addr]

line_hu0_0:
   and al, 03fh         
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu0_0
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu0_0:

line_hu1_0:
   and al, 0cfh
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu1_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu1_0:

line_hu2_0:
   and al, 0f3h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu2_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu2_0:             

line_hu3_0:
   and al, 0fch
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hu3_0
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hu3_0:             

   mov al, [di]
   loop line_hu0_0
   jmp line_hu_no_iter0

line_hu0_1:
   and al, 03fh         
   or al, 040h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu0_1
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu0_1:

line_hu1_1:
   and al, 0cfh
   or al, 010h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu1_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu1_1:

line_hu2_1:
   and al, 0f3h
   or al, 04h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu2_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu2_1:             

line_hu3_1:
   and al, 0fch
   or al, 01h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hu3_1
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hu3_1:             

   mov al, [di]
   loop line_hu0_1
   mov ah, 040h
   jmp line_hu_no_iter0

line_hu0_2:
   and al, 03fh         
   or al, 080h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu0_2
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu0_2:

line_hu1_2:
   and al, 0cfh
   or al, 020h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu1_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu1_2:

line_hu2_2:
   and al, 0f3h
   or al, 08h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu2_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu2_2:             

line_hu3_2:
   and al, 0fch
   or al, 02h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hu3_2
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hu3_2:             

   mov al, [di]
   loop line_hu0_2
   mov ah, 080h
   jmp line_hu_no_iter0

line_hu0_3:
   or al, 0c0h         
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu0_3
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu0_3:

line_hu1_3:
   or al, 030h
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu1_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu1_3:

line_hu2_3:
   or al, 0ch
   add si, bx           ; D += 2*dy

   jle line_skip_incy_hu2_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
line_skip_incy_hu2_3:             

line_hu3_3:
   or al, 03h
   add si, bx           ; D += 2*dy
   stosb
   
   jle line_skip_incy_hu3_3
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx
   inc di
line_skip_incy_hu3_3:             

   mov al, [di]
   loop line_hu0_3
   mov ah, 0c0h

line_hu_no_iter0:

   pop cx               ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line_hu_done                   

   and al, 03fh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_hu4

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_hu4:
   dec di

line_hu_no_iter1:
   dec cl
   jz line_hu_done

   and al, 0cfh         
   or al, ah
   ror ah, 1
   ror ah, 1
   add si, bx           ; D += 2*dy

   stosb                ; draw pixel

   jle line_skip_incy_hu5
 
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   sub si, dx           ; D -= 2*dx

   mov al, [di]
   inc di
line_skip_incy_hu5:
   dec di

line_hu_no_iter2:
   dec cl
   jz line_hu_done

   and al, 0f3h         
   or al, ah

   stosb                ; draw pixel

line_hu_done:        

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line ENDP

   END