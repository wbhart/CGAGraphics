   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _cga_draw_line_wide
_cga_draw_line_wide PROC
   ARG buff:DWORD, x:WORD, y:WORD, incs:WORD, w:WORD, len:WORD, colour:BYTE
   ; draw a line with starting point (x, y) and other starting point at
   ; (x + w, y) (where w may be negative), with increments in the
   ; x direction in inc[i]. Requires width != 0.
   push bp
	mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov ch, [colour]     ; put solid colour in ch
   mov al, ch
   shl al, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add ch, al

   xor dx, dx
   mov ax, [y]          ; set dx to offset of CGA bank (odd/even)
	shr ax, 1
   jnc line_wide_even_y
   mov dx, 8192
   ror ch, 1            ; adjust colour for odd/even starting line
   ror ch, 1
line_wide_even_y:

   shl ax, 1            ; set di to offset address of line y
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   shl ax, 1
   add dx, ax
	add di, dx

   mov si, [incs]       ; get address of increments buffer

   mov ax, [x]
   mov dx, [w]
   dec dx               ; rightmost pixel not drawn
   jns line_wide_pos
   inc dx
   dec ax
line_wide_pos:
   add dx, ax

   mov bp, [len]        ; get number of horizontal lines
                        ; last line is not drawn

   inc si
   
   push ax
   push dx
   push di

line_wide_short_loop:
   mov cl, al           ; set cl to 2*(x0 mod 4)
   and cl, 3
   shl cl, 1

   mov bl, dl           ; set bl to 2*(x1 mod 4)
   and bl, 3
   shl bl, 1

   shr ax, 1            ; add x0/4 to offset
   shr ax, 1
   add di, ax

   shr dx, 1            ; set dx to x1/4 - x0/4 (final offset - initial offset)
   shr dx, 1
   sub dx, ax

   mov bh, 0ffh         ; prepare left mask in bh
   shr bh, cl

   mov cl, bl           ; prepare right mask in bl
   mov bl, 0c0h
   sar bl, cl

   mov al, ch           ; copy colour in al and ah
   mov ah, ch

   dec dl               ; if first and last pixels are not in the same byte
   jns line_wide_long_line

   and bl, bh           ; compute overlapped mask and put masked colour in al
   and al, bl
   not bl

   and bl, es:[di]      ; draw pixels
   or al, bl
   stosb
   
   ror ch, 1
   ror ch, 1

   pop di
   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop dx
   pop ax

   mov bx, ax
   mov al, BYTE PTR [si]
   cbw
   add dx, ax
   add ax, bx

   inc si

   push ax
   push dx
   push di

   dec bp
   jnz line_wide_short_loop

   pop di
   pop dx
   pop ax

   pop si
   pop di
   pop bp
   ret

line_wide_long_loop:
   mov cl, al           ; set cl to 2*(x0 mod 4)
   and cl, 3
   shl cl, 1

   mov bl, dl           ; set bl to 2*(x1 mod 4)
   and bl, 3
   shl bl, 1

   shr ax, 1            ; add x0/4 to offset
   shr ax, 1
   add di, ax

   shr dx, 1            ; set dx to x1/4 - x0/4 - 1 (final offset - initial offset - 1)
   shr dx, 1
   sub dx, ax

   mov bh, 0ffh         ; prepare left mask in bh
   shr bh, cl

   mov cl, bl           ; prepare right mask in bl
   mov bl, 0c0h
   sar bl, cl

   mov al, ch           ; put colour into al and ah
   mov ah, ch

   dec dx               ; get iterations

line_wide_long_line:
   and al, bh           ; put left hand mask in bh and colour in al
   not bh

   and bh, es:[di]      ; draw pixels on left side of line
   or al, bh
   stosb

   mov al, ah           ; draw full colour bytes
   mov cx, dx
   shr cx, 1
   jnc line_wide_even_iter
   stosb
line_wide_even_iter:
   rep stosw
              
   and al, bl           ; put right hand mask in bl and colour in al
   not bl
   
   and bl, es:[di]      ; draw right hand pixels
   or al, bl
   stosb

   mov ch, ah           ; save colour

   ror ch, 1
   ror ch, 1

   pop di
   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop dx
   pop ax

   mov bx, ax
   mov al, BYTE PTR [si]
   cbw
   add dx, ax
   add ax, bx

   inc si
   push ax
   push dx
   push di

   dec bp
   jnz line_wide_long_loop
   
   pop di
   pop dx
   pop ax

   pop si
   pop di
   pop bp
   ret
_cga_draw_line_wide ENDP

   END

