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

   mov si, [x0]         ; compute 2*(x0 mod 4)
   and si, 3
   shl si, 1

   mov cx, 6            ; compute colour shift
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
   
   jb line_hd
   jmp line_vd   

line_hd:                ; horizontalish, down

   mov ax, dx           ; compute iterations
   inc ax
   push ax              ; save high byte of iterations
   shr ax, 1            ; we unroll by 2

   mov ah, [colour]     ; compute initial colour information
   shl ah, cl
   mov ch, 0fch
   shl ch, cl           ; compute initial mask

   shl bx, 1            ; compute 2*dy
   xor si, si           ; D = -dx
   sub si, dx
   shl dx, 1            ; compute 2*dx

   mov bp, [y0]         ; compute initial even/odd offset diff
   shr bp, 1
   mov bp, 8192
   jnc line_hd_even
   sub bp, 16304
line_hd_even:

   mov cl, al           ; get iterations

   cmp cl, 0            ; check for zero iterations
   je line_hd_no_iter

line_hd_begin:
   add si, dx           ; if D <= 0
   jg line_hd_Dgt0

   mov al, ch           ; get mask
   ror ch, 1            ; rotate mask
   ror ch, 1

   jnc line_hd_3mod4    ; if 0, 1, 2 mod 4

   and al, ch           ; and pixel with mask 
   and al, [di] 
   or al, ah            ; or with colour
   ror ah, 1            ; rotate colour
   ror ah, 1
   jmp line_hd_Dcmp_end

line_hd_3mod4:          ; else if 3 mod 4
   and al, [di]         ; and with mask
   or al, ah            ; or with colour
   stosb                ; write out

   ror ah, 1            ; rotate colour
   ror ah, 1
   
   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   jmp line_hd_Dcmp_end

line_hd_Dgt0:           ; else if D > 0
   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

   add di, bp           ; increase y coord
   xor bp, -16304
        
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1

   sbb di, 0            ; if not 3 mod 4 reset offset

   mov al, ch           ; get mask
   and al, [di]         ; and with pixel

   sub si, bx           ; D -= dy        
line_hd_Dcmp_end:

   or al, ah            ; or with colour
   stosb                ; write out

   add si, dx           ; D += dx

   jle line_hd_no_inc   ; if D < 0

   add di, bp           ; increase y coord
   xor bp, -16304
   
   sub si, bx           ; D -= dy

line_hd_no_inc:         ; else D >= 0
   ror ah, 1            ; rotate colour
   ror ah, 1
   ror ch, 1            ; rotate mask
   ror ch, 1
   
   sbb di, 0            ; if not 3 mod 4 reset offset

   dec cl
   jnz line_hd_begin

line_hd_no_iter:

   pop bx               ; if iterations is odd
   test bl, 1
   jz line_hd_done

   mov al, ch           ; get mask
   and al, [di]         ; and with pixel
   or al, ah            ; or with colour
   stosb                ; write out

line_hd_done:

line_vd:
line_vu:
line_hu:

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line ENDP

        PUBLIC _cga_draw_line2
_cga_draw_line2 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
	; line from (x0, y0) - (xend, ?) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax
        std

        xor di, di
        mov ax, [y0]
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
        mov ax, [xend]
        sub ax, bx
        neg ax
        inc ax
        push ax
        shr ax, 1
        push bp
        push ax
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
        sub si, dx

        pop bp
        cmp bp, 0
        je line2_end2

line2_begin2:
        add si, dx
        jg line2_Dgt0_1
        mov al, cl
        rol cl, 1
        rol cl, 1
        jnc line2_ine3
        and al, cl
        and al, es:[di]
        or al, ch
        rol ch, 1
        rol ch, 1
        jmp line2_Dcmp_end_1
line2_ine3:
        and al, es:[di]
        or al, ch
        stosb
        rol ch, 1
        rol ch, 1
        mov al, cl
        and al, es:[di]
        jmp line2_Dcmp_end_1
line2_Dgt0_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        adc di, 0
        mov al, cl
        and al, es:[di]
        sub si, bx        
line2_Dcmp_end_1:
        or al, ch
        stosb
        add si, dx
        jle line2_no_inc
        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        sub si, bx        
line2_no_inc:
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        adc di, 0
        dec bp
        jnz line2_begin2
line2_end2:
        pop bp

        pop ax
        test al, 1
        jz line2_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line2_done:

        cld
        pop si
        pop di
        pop bp
        ret
_cga_draw_line2 ENDP

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

