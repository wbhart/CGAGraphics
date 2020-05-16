   DOSSEG
   .MODEL small
   .CODE
   
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
   xor di, di         
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

   mov cx, [x0]         ; compute 2*(x0 mod 4)
   inc cx
   and cx, 3
   shl cx, 1

   mov bx, [y1]         ; compute dy
   sub bx, [y0]
   jae line_down
   
   neg bx
   cmp bx, dx

   mov si, 8111

   jbe line_goto_hu

   mov WORD PTR cs:[line_v_xor1 + 2], -16304
   mov WORD PTR cs:[line_v_xor2 + 2], -16304
   jmp line_vu   
line_goto_hu:
   mov WORD PTR cs:[line_h_xor1 + 2], -16304
   mov WORD PTR cs:[line_h_xor2 + 2], -16304
   jmp line_hu

line_down:

   cmp bx, dx

   mov si, 8191

   jb line_hd
   jmp line_vd   

line_hd:                ; horizontalish, down
   mov WORD PTR cs:[line_h_xor1 + 2], -80
   mov WORD PTR cs:[line_h_xor2 + 2], -80 

line_hu:                ; horizontalish, up

   mov ax, dx           ; compute iterations
   inc ax
   push ax              ; save iterations
   shr ax, 1            ; we unroll by 2

   mov ah, [colour]     ; compute initial colour information
   ror ah, cl
   mov ch, 0fch
   ror ch, cl           ; compute initial mask

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, si
   jnc line_h_even
   sub bp, 16304
line_h_even:

   shl bx, 1            ; compute 2*dy
   xor si, si           ; D = -dx
   sub si, dx
   shl dx, 1            ; compute 2*dx

   mov cl, al           ; get iterations

   mov al, [di]         ; get first pixel

   cmp cl, 0            ; check for zero iterations
   je line_h_no_iter

line_h_begin:
   add si, bx           ; D += 2*dy
   jg line_h_Dgt0       ; if D <= 0

   and al, ch           ; and with mask
   ror ch, 1            ; rotate mask
   ror ch, 1

   jnc line_h_3mod4     ; if 0, 1, 2 mod 4

   and al, ch           ; and with mask 
   or al, ah            ; or with colour
   ror ah, 1            ; rotate colour
   ror ah, 1
   jmp line_h_Dcmp_end

line_h_3mod4:           ; else if 3 mod 4
   or al, ah            ; or with colour
   stosb                ; write out

   ror ah, 1            ; rotate colour
   ror ah, 1
   
   mov al, [di]
   and al, ch           ; and with mask
   jmp line_h_Dcmp_end

line_h_Dgt0:            ; else if D > 0
   and al, ch           ; and with mask
   or al, ah            ; or with colour
   stosb                ; write out

   add di, bp           ; increase y coord
line_h_xor1:
   xor bp, 01234h
        
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1

   sbb di, -1            ; if 3 mod 4 increment offset

   mov al, [di]         ; get pixel
   and al, ch           ; and with mask
   
   sub si, dx           ; D -= 2*dx

line_h_Dcmp_end:

   or al, ah            ; or with colour

   add si, bx           ; D += 2*dy

   jle line_h_no_inc    ; if D < 0

   stosb

   add di, bp           ; increase y coord
line_h_xor2:
   xor bp, 01234h

   sub si, dx           ; D -= 2*dx

   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1
    
   sbb di, -1           ; if 3 mod 4 increment offset

   mov al, [di]         ; get pixel

   dec cl
   jnz line_h_begin

   jmp line_h_no_iter
line_h_no_inc:          ; else D >= 0

   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1

   jc line_h_skip_write
   stosb                ; write out
   mov al, [di]         ; get pixel
line_h_skip_write:

   dec cl
   jnz line_h_begin

line_h_no_iter:

   pop bx               ; if iterations is odd
   test bl, 1
   jz line_h_done

   and al, ch           ; and with mask
   or al, ah            ; or with colour

line_h_done:
   stosb                ; write out

   pop ds
   pop si
   pop di
   pop bp
   ret

line_vd:
   mov WORD PTR cs:[line_v_xor1 + 2], -80
   mov WORD PTR cs:[line_v_xor2 + 2], -80
line_vu:

   mov ax, bx           ; compute iterations
   inc ax
   push ax              ; save iterations
   shr ax, 1            ; we unroll by 2

   mov ah, [colour]     ; compute initial colour information
   ror ah, cl
   mov ch, 0fch
   ror ch, cl           ; compute initial mask

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, si
   jnc line_v_even
   sub bp, 16304
line_v_even:

   shl dx, 1            ; compute 2*dx
   xor si, si           ; D = -dy
   sub si, bx
   shl bx, 1            ; compute 2*dy

   mov cl, al           ; get iterations

   cmp cl, 0            ; check for zero iterations
   je line_v_no_iter

line_v_begin:
   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

   add di, bp
line_v_xor1:
   xor bp, 01234h

   add si, dx           ; D -= 2*dx
   jng line_v_Dcmp_end

   inc di
   
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1
        
   jnc line_v_3mod4     ; if 0, 1, 2 mod 4
   dec di
line_v_3mod4:

   sub si, bx           ; D -= 2*dy 

line_v_Dcmp_end:

   mov al, ch           ; get mask
   and al, [di]         ; and pixel
   or al, ah            ; or colour
   stosb                ; write out

   add di, bp           ; increment y
line_v_xor2:
   xor bp, 01234h

   add si, dx           ; D += 2*dx

   jle line_v_no_inc    ; if D >= 0

   inc di
   
   sub si, bx           ; D -= 2*dy

   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1

   jnc line_v_no_inc    ; if 3 mod 4
   dec di
line_v_no_inc:
   
   dec cl
   jnz line_v_begin

line_v_no_iter:

   pop bx
   test bl, 1
   jz line_v_done

   mov al, ch           ; get mask
   and al, [di]         ; and pixel
   or al, ah            ; or colour
   stosb                ; write out

line_v_done:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line ENDP

   END

