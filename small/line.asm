	DOSSEG
	.MODEL small
	.CODE
   
        PUBLIC _cga_draw_line
_cga_draw_line PROC
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
   
   jbe line_goto_hu
   mov si, 8111

   mov WORD PTR cs:[line_v_xor1+2], 16304
   mov WORD PTR cs:[line_v_xor2+2], 16304
   jmp line_vu   
line_goto_hu:
   mov si, 8112

   mov WORD PTR cs:[line_h_xor1 + 2], -80
   mov WORD PTR cs:[line_h_xor2 + 2], -80 

   jmp line_hu

line_down:

   cmp bx, dx
   
   jb line_hd
   jmp line_vd   

line_hd:                ; horizontalish, down
   mov si, 8192

   mov WORD PTR cs:[line_h_xor1 + 2], -16304
   mov WORD PTR cs:[line_h_xor2 + 2], -16304 

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

   cmp cl, 0            ; check for zero iterations
   je line_h_no_iter

line_h_begin:
   add si, bx           ; D += 2*dy
   jg line_h_Dgt0       ; if D <= 0

   mov al, ch           ; get mask
   ror ch, 1            ; rotate mask
   ror ch, 1

   jnc line_h_3mod4     ; if 0, 1, 2 mod 4

   and al, ch           ; and with mask 
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   ror ah, 1            ; rotate colour
   ror ah, 1
   jmp line_h_Dcmp_end

line_h_3mod4:           ; else if 3 mod 4
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

   ror ah, 1            ; rotate colour
   ror ah, 1
   
   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   jmp line_h_Dcmp_end

line_h_Dgt0:            ; else if D > 0
   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

   add di, bp           ; increase y coord
line_h_xor1:
   xor bp, 01234h
        
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1

   sbb di, 0            ; if not 3 mod 4 reset offset

   mov al, ch           ; get mask
   and al, [di]         ; and with pixel

   sub si, dx           ; D -= 2*dx

line_h_Dcmp_end:

   or al, ah            ; or with colour
   stosb                ; write out

   add si, bx           ; D += 2*dy

   jle line_h_no_inc    ; if D < 0

   add di, bp           ; increase y coord
line_h_xor2:
   xor bp, 01234h
   
   sub si, dx           ; D -= 2*dx

line_h_no_inc:          ; else D >= 0
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1
   
   sbb di, 0            ; if not 3 mod 4 reset offset

   dec cl
   jnz line_h_begin

line_h_no_iter:

   pop bx               ; if iterations is odd
   test bl, 1
   jz line_h_done

   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

line_h_done:

   pop ds
   pop si
   pop di
   pop bp
   ret

line_vd:
   mov si, 8191

   mov WORD PTR cs:[line_v_xor1+2], -80
   mov WORD PTR cs:[line_v_xor2+2], -80
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

        PUBLIC _cga_draw_line3
_cga_draw_line3 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
	; line from (x0, y0) - (?, yend) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        mov bx, [yend]
        sub bx, ax
        inc bx
        push bx
        shr bx, 1
        push bp
        push bx
        shr ax, 1
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

        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, bx

        pop bp
        cmp bp, 0
        je line3_end2

line3_begin2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jng line3_Dcmp_end_1
        inc di
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        jnc line3_ine3
        dec di
line3_ine3:
        sub si, dx        
line3_Dcmp_end_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jle line3_no_inc
        inc di
        sub si, dx
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        jnc line3_no_inc
        dec di
line3_no_inc:
        dec bp
        jnz line3_begin2
line3_end2:
        pop bp

        pop ax
        test al, 1
        jz line3_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line3_done:

        pop si
        pop di
        pop bp
        ret
_cga_draw_line3 ENDP

        PUBLIC _cga_draw_line4
_cga_draw_line4 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
	; line from (x0, y0) - (?, yend) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        mov bx, [yend]
        sub bx, ax
        inc bx
        push bx
        shr bx, 1
        push bp
        push bx
        shr ax, 1
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

        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, bx

        pop bp
        cmp bp, 0
        je line4_end2

line4_begin2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jng line4_Dcmp_end_1
        dec di
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        jnc line4_ine3
        inc di
line4_ine3:
        sub si, dx        
line4_Dcmp_end_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jle line4_no_inc
        dec di
        sub si, dx
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        jnc line4_no_inc
        inc di
line4_no_inc:
        dec bp
        jnz line4_begin2
line4_end2:
        pop bp

        pop ax
        test al, 1
        jz line4_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line4_done:

        pop si
        pop di
        pop bp
        ret
_cga_draw_line4 ENDP

   END

