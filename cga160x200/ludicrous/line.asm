   DOSSEG
   .MODEL small
   .CODE

   jmp_addr       DW ?
   line_hd_jmptab DW line_hd0_0, line_hd0_1, line_hd0_2, line_hd0_3, line_hd1_0, line_hd1_1, line_hd1_2, line_hd1_3 
   line_hu_jmptab DW line_hu0_0, line_hu0_1, line_hu0_2, line_hu0_3, line_hu1_0, line_hu1_1, line_hu1_2, line_hu1_3
   line_vd_jmptab DW line_vd_loop1_0, line_vd_loop1_1, line_vd_loop1_2, line_vd_loop1_3, line_vd_loop2_0, line_vd_loop2_1, line_vd_loop2_2, line_vd_loop2_3
                  DW line_vd_incx11_0, line_vd_incx11_1, line_vd_incx11_2, line_vd_incx11_3, line_vd_incx21_0, line_vd_incx21_1, line_vd_incx21_2, line_vd_incx21_3
   line_vu_jmptab DW line_vu_loop1_0, line_vu_loop1_1, line_vu_loop1_2, line_vu_loop1_3, line_vu_loop2_0, line_vu_loop2_1, line_vu_loop2_2, line_vu_loop2_3
                  DW line_vu_incx11_0, line_vu_incx11_1, line_vu_incx11_2, line_vu_incx11_3, line_vu_incx21_0, line_vu_incx21_1, line_vu_incx21_2, line_vu_incx21_3

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
   add di, ax
   mov ax, [x0]         ; add x0/2 to offset
   shr ax, 1
   add di, ax
   
   mov si, [x0]         ; compute 4 - 4*(x0 mod 2)
   not si
   and si, 1
   shl si, 1
   shl si, 1
   mov cx, si
   
   xor bx, bx           ; compute colour jump
   mov bl, [colour]
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
   
   jbe line_hd
   jmp line_vd   

line_hd:                ; horizontalish, down

   mov si, cs:[line_hd_jmptab + si]
   mov cs:[jmp_addr], si

   shl ax, 1            ; round x0 down to multiple of 2
   mov si, [x1]         ; compute iterations, unrolled by 2
   sub si, ax
   inc si
   push si              ; save iterations for prologue
   shr si, 1            ; divide iterations by 2

   xor ax, ax           ; compute increment
   xchg bx, dx
   cmp bx, dx
   jne line_hd_noteq
   mov dx, 0ffffh
   jmp line_hd_skip_div
line_hd_noteq:
   div bx
   shl dx, 1
   adc ax, 0
   mov dx, ax
line_hd_skip_div:

   mov ah, [colour]     ; initial colour shift
   mov al, ah
   shl al, 1
   shl al, 1
   add ah, al
   shl ah, cl

   mov cx, si           ; get iterations

   mov si, 08000h       ; initial value for increment

   mov al, [di]         ; get initial graphics byte

   mov bx, 0ffb0h       ; xor value 

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8191
   jnc line_hd_even
   sub bp, 16304
line_hd_even:

   cmp cl, 0            ; check for zero iterations
   jne line_hd_iter

   jmp line_hd_no_iter

line_hd_iter:

   jmp WORD PTR cs:[jmp_addr]

line_hd0_0:
   and al, 0fh         
   add si, dx           ; inc y?

   jnc line_skip_incy_hd0_0
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hd0_0:           

line_hd1_0:
   and al, 0f0h
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hd1_0
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hd1_0:             

   mov al, [di]
   loop line_hd0_0
   jmp line_hd_no_iter

line_hd0_1:
   and al, 0fh         
   or al, 050h
   add si, dx           ; inc y?

   jnc line_skip_incy_hd0_1
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hd0_1:            

line_hd1_1:
   and al, 0f0h
   or al, 05h
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hd1_1
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hd1_1:             

   mov al, [di]
   loop line_hd0_1
   mov ah, 050h
   jmp line_hd_no_iter

line_hd0_2:
   and al, 0fh         
   or al, 0a0h
   add si, dx           ; inc y?

   jnc line_skip_incy_hd0_2
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hd0_2:            

line_hd1_2:
   and al, 0f0h
   or al, 0ah
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hd1_2
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hd1_2:             

   mov al, [di]
   loop line_hd0_2
   mov ah, 0a0h
   jmp line_hd_no_iter

line_hd0_3:
   or al, 0f0h         
   add si, dx           ; inc y?

   jnc line_skip_incy_hd0_3
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hd0_3:

line_hd1_3:
   or al, 0fh
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hd1_3
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hd1_3:             

   mov al, [di]
   loop line_hd0_3
   mov ah, 0f0h

line_hd_no_iter:

   pop cx               ; do remaining iterations (0-3)
   and cl, 01h

   jz line_hd_done                   

   and al, 0fh         
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
   add si, 16
   sub di, 8192         ; addressing below assumes we started on even line
line_vd_even:

   shl ax, 1            ; finish rounding y0 down to multiple of 2

   mov si, cs:[line_vd_jmptab + si]
   mov cs:[jmp_addr], si

   mov si, [y1]         ; compute iterations
   sub si, ax
   inc si
   shr si, 1            ; divide iterations by 2

   xor ax, ax           ; compute increment round(256*dx/dy)
   div bx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov ah, [colour]     ; compute shifted colour
   mov al, ah
   shl al, 1
   shl al, 1
   add ah, al
   shl ah, cl

   mov cx, si           ; get iterations

   mov si, 08000h       ; starting value for increments

   push bp
   mov bp, 79

   cmp cl, 0            ; check for zero iterations
   jne line_vd_iter

   xor bx, bx           ; compute ah and al
   mov cx, [x0]
   inc cl
   and cl, 1
   shl cl, 1
   shl cl, 1
   mov al, 0f0h
   ror al, cl
   
   jmp line_vd_no_iter
line_vd_iter:

   mov bx, -8192
   add di, 8192         ; compensate for first subtraction of 8192

   jmp cs:[jmp_addr]

line_vd_loop1_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fh
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vd_incx21_0
line_vd_incx11_0:

   mov al, [di]
   and al, 0fh
   stosb
   add si, dx           ; inc x?
   jc line_vd_incx22_0
line_vd_incx12_0:
   add di, bp

   loop line_vd_loop1_0
   mov ax, 0fh
   jmp line_vd_no_iter

line_vd_loop2_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f0h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx11_0
   dec di
line_vd_incx21_0:

   mov al, [di]
   and al, 0f0h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx12_0
   dec di
line_vd_incx22_0:
   add di, bp

   loop line_vd_loop2_0
   mov ax, 0f0h
   jmp line_vd_no_iter

line_vd_loop1_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fh
   or al, 050h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vd_incx21_1
line_vd_incx11_1:

   mov al, [di]
   and al, 0fh
   or al, 050h
   stosb
   add si, dx           ; inc x?
   jc line_vd_incx22_1
line_vd_incx12_1:
   add di, bp

   loop line_vd_loop1_1
   mov ax, 040fh
   jmp line_vd_no_iter

line_vd_loop2_1:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f0h
   or al, 05h
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx11_1
   dec di
line_vd_incx21_1:

   mov al, [di]
   and al, 0f0h
   or al, 05h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx12_1
   dec di
line_vd_incx22_1:
   add di, bp

   loop line_vd_loop2_1
   mov ax, 05f0h
   jmp line_vd_no_iter

line_vd_loop1_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0fh
   or al, 0a0h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vd_incx21_2
line_vd_incx11_2:

   mov al, [di]
   and al, 0fh
   or al, 0a0h
   stosb
   add si, dx           ; inc x?
   jc line_vd_incx22_2
line_vd_incx12_2:
   add di, bp

   loop line_vd_loop1_2
   mov ax, 0a0fh
   jmp line_vd_no_iter

line_vd_loop2_2:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f0h
   or al, 0ah
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx11_2
   dec di
line_vd_incx21_2:

   mov al, [di]
   and al, 0f0h
   or al, 0ah
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx12_2
   dec di
line_vd_incx22_2:
   add di, bp

   loop line_vd_loop2_2
   mov ax, 0af0h
   jmp line_vd_no_iter

line_vd_loop1_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0f0h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vd_incx21_3
line_vd_incx11_3:

   mov al, [di]
   or al, 0f0h
   stosb
   add si, dx           ; inc x?
   jc line_vd_incx22_3
line_vd_incx12_3:
   add di, bp

   loop line_vd_loop1_3
   mov ax, 0f0fh
   jmp line_vd_no_iter

line_vd_loop2_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0fh
   mov [bx+di], al
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx11_3
   dec di
line_vd_incx21_3:

   mov al, [di]
   or al, 0fh
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vd_incx12_3
   dec di
line_vd_incx22_3:
   add di, bp

   loop line_vd_loop2_3
   mov ax, 0ff0h

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

   xor ax, ax           ; compute increment round(256*dx/dy)
   div bx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov ah, [colour]     ; compute shifted colour
   shl ah, cl

   mov cx, si           ; get iterations

   push bp
   mov bp, 81

   mov si, 08000h       ; starting value for increments

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

   mov bx, -8112
   add di, 8112         ; compensate for first subtraction of 8112

   jmp cs:[jmp_addr]

line_vu_loop2_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0cfh
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx31_0
line_vu_incx21_0:

   mov al, [di]
   and al, 0cfh
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx32_0
line_vu_incx22_0:
   sub di, 81

   loop line_vu_loop2_0
   mov ax, 0cfh
   jmp line_vu_no_iter

line_vu_loop1_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 03fh
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx21_0
line_vu_incx11_0:

   mov al, [di]
   and al, 03fh
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx22_0
line_vu_incx12_0:
   sub di, 81

   loop line_vu_loop1_0
   mov ax, 03fh
   jmp line_vu_no_iter

line_vu_loop3_0:

   mov al, [bx+di]      ; reenigne's trick
   and al, 0f3h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx41_0
line_vu_incx31_0:

   mov al, [di]
   and al, 0f3h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx42_0
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
   add si, dx           ; inc x?
   jc line_vu_incx11_0
   dec di
line_vu_incx41_0:

   mov al, [di]
   and al, 0fch
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vu_incx12_0
   dec di
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
   add si, dx           ; inc x?
   jc line_vu_incx31_1
line_vu_incx21_1:

   mov al, [di]
   and al, 0cfh
   or al, 010h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx32_1
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
   add si, dx           ; inc x?
   jc line_vu_incx21_1
line_vu_incx11_1:

   mov al, [di]
   and al, 03fh
   or al, 040h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx22_1
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
   add si, dx           ; inc x?
   jc line_vu_incx41_1
line_vu_incx31_1:

   mov al, [di]
   and al, 0f3h
   or al, 04h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx42_1
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
   add si, dx           ; inc x?
   jc line_vu_incx11_1
   dec di
line_vu_incx41_1:

   mov al, [di]
   and al, 0fch
   or al, 01h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vu_incx12_1
   dec di
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
   add si, dx           ; inc x?
   jc line_vu_incx31_2
line_vu_incx21_2:

   mov al, [di]
   and al, 0cfh
   or al, 020h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx32_2
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
   add si, dx           ; inc x?
   jc line_vu_incx21_2
line_vu_incx11_2:

   mov al, [di]
   and al, 03fh
   or al, 080h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx22_2
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
   add si, dx           ; inc x?
   jc line_vu_incx41_2
line_vu_incx31_2:

   mov al, [di]
   and al, 0f3h
   or al, 08h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx42_2
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
   add si, dx           ; inc x?
   jc line_vu_incx11_2
   dec di
line_vu_incx41_2:

   mov al, [di]
   and al, 0fch
   or al, 02h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vu_incx12_2
   dec di
line_vu_incx42_2:
   sub di, 81

   loop line_vu_loop4_2
   mov ax, 02fch
   jmp line_vu_no_iter

line_vu_loop2_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 030h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx31_3
line_vu_incx21_3:

   mov al, [di]
   or al, 030h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx32_3
line_vu_incx22_3:
   sub di, 81

   loop line_vu_loop2_3
   mov ax, 030cfh
   jmp line_vu_no_iter

line_vu_loop1_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0c0h
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx21_3
line_vu_incx11_3:

   mov al, [di]
   or al, 0c0h
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx22_3
line_vu_incx12_3:
   sub di, 81

   loop line_vu_loop1_3
   mov ax, 0c03fh
   jmp line_vu_no_iter

line_vu_loop3_3:

   mov al, [bx+di]      ; reenigne's trick
   or al, 0ch
   mov [bx+di], al
   add si, dx           ; inc x?
   jc line_vu_incx41_3
line_vu_incx31_3:

   mov al, [di]
   or al, 0ch
   stosb
   add si, dx           ; inc x?
   jc line_vu_incx42_3
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
   add si, dx           ; inc x?
   jc line_vu_incx11_3
   dec di
line_vu_incx41_3:

   mov al, [di]
   or al, 03h
   stosb
   inc di               ; move to next byte, maybe?
   add si, dx           ; inc x?
   jc line_vu_incx12_3
   dec di
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

   xor ax, ax           ; compute increment
   xchg bx, dx
   cmp bx, dx
   jne line_hu_noteq
   mov dx, 0ffffh
   jmp line_hu_skip_div
line_hu_noteq:
   div bx
   shl dx, 1
   adc ax, 0
   mov dx, ax
line_hu_skip_div:

   mov ah, [colour]     ; initial colour shift
   shl ah, cl

   mov cx, si           ; get iterations

   mov si, 08000h       ; initial value for increment

   mov al, [di]         ; get initial graphics byte

   mov bx, 0c050h       ; xor value 

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
   add si, dx           ; inc y?

   jnc line_skip_incy_hu0_0
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu0_0:

line_hu1_0:
   and al, 0cfh
   add si, dx           ; inc y?

   jnc line_skip_incy_hu1_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu1_0:

line_hu2_0:
   and al, 0f3h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu2_0
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu2_0:             

line_hu3_0:
   and al, 0fch
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hu3_0
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, 0c050h       ; adjust ydelta

   inc di
line_skip_incy_hu3_0:             

   mov al, [di]
   loop line_hu0_0
   jmp line_hu_no_iter0

line_hu0_1:
   and al, 03fh         
   or al, 040h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu0_1
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu0_1:

line_hu1_1:
   and al, 0cfh
   or al, 010h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu1_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu1_1:

line_hu2_1:
   and al, 0f3h
   or al, 04h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu2_1
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu2_1:             

line_hu3_1:
   and al, 0fch
   or al, 01h
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hu3_1
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hu3_1:             

   mov al, [di]
   loop line_hu0_1
   mov ah, 040h
   jmp line_hu_no_iter0

line_hu0_2:
   and al, 03fh         
   or al, 080h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu0_2
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu0_2:

line_hu1_2:
   and al, 0cfh
   or al, 020h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu1_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu1_2:

line_hu2_2:
   and al, 0f3h
   or al, 08h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu2_2
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu2_2:             

line_hu3_2:
   and al, 0fch
   or al, 02h
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hu3_2
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   inc di
line_skip_incy_hu3_2:             

   mov al, [di]
   loop line_hu0_2
   mov ah, 080h
   jmp line_hu_no_iter0

line_hu0_3:
   or al, 0c0h         
   add si, dx           ; inc y?

   jnc line_skip_incy_hu0_3
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu0_3:

line_hu1_3:
   or al, 030h
   add si, dx           ; inc y?

   jnc line_skip_incy_hu1_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu1_3:

line_hu2_3:
   or al, 0ch
   add si, dx           ; inc y?

   jnc line_skip_incy_hu2_3
   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

   mov al, [di]
line_skip_incy_hu2_3:             

line_hu3_3:
   or al, 03h
   add si, dx           ; inc y?

   stosb
   
   jnc line_skip_incy_hu3_3
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

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
   add si, dx           ; inc y?

   stosb                ; draw pixel

   jnc line_skip_incy_hu4

   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

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
   add si, dx           ; inc y?

   stosb                ; draw pixel

   jnc line_skip_incy_hu5
 
   add di, bp           ; odd <-> even line (reenigne's trick)
   xor bp, bx           ; adjust ydelta

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