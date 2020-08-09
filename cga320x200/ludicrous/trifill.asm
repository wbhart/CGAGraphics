   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _cga_draw_triangle_1u2d
_cga_draw_triangle_1u2d PROC
   ARG buff:DWORD, x:WORD, y:WORD, incs:WORD, len:WORD, colour:BYTE
   ; draw a filled triangle with top point at (x, y), with bottom coords on
   ; the same line and increments in the x direction in inc[i] and (inc+200)[i]
   push bp
	mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov ax, [y]          ; set dx to offset of CGA bank (odd/even)
	shr ax, 1
   sbb dx, dx
	and dx, 8192

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

   mov ch, [colour]     ; put solid colour in ch
   mov al, ch
   shl al, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add ch, al

   mov ax, [x]
   mov dx, ax
   dec dx               ; rightmost pixel is not drawn

   mov bp, [len]        ; get number of horizontal lines
   dec bp               ; last line is not drawn

trifill_skip_loop:      ; lines of length 0 skipped
   mov bx, ax
   mov al, BYTE PTR [si+200]
   cbw
   add dx, ax
   mov al, BYTE PTR [si]
   cbw
   add ax, bx

   inc si

   ror ch, 1

   sub di, 8112         ; increment y
   sbb bx, bx
   and bx, 16304
   add di, bx
   
   cmp al, dl
   jbe trifill_first
   dec bp
   jnz trifill_skip_loop

   pop si
   pop di
   pop bp
   ret

trifill_short_loop:
   mov bx, ax
   mov al, BYTE PTR [si+200]
   cbw
   add dx, ax
   mov al, BYTE PTR [si]
   cbw
   add ax, bx

   inc si

trifill_first:
   push ax
   push dx
   push di

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
   jns trifill_long_line
trifill_short_line:

   and bl, bh           ; compute overlapped mask and put masked colour in al
   and al, bl
   not bl

   and bl, es:[di]      ; draw pixels
   or al, bl
   stosb
   
   ror ch, 1

   pop di
   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop dx
   pop ax
   dec bp
   jnz trifill_short_loop

   pop si
   pop di
   pop bp
   ret

trifill_long_loop:
   mov bx, ax
   mov al, BYTE PTR [si+200]
   cbw
   add dx, ax
   mov al, BYTE PTR [si]
   cbw
   add ax, bx
   
   inc si
   push ax
   push dx
   push di

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

   dec dx
   js trifill_short_line

trifill_long_line:
   and al, bh           ; put left hand mask in bh and colour in al
   not bh

   and bh, es:[di]      ; draw pixels on left side of line
   or al, bh
   stosb

   mov al, ah           ; draw full colour bytes
   mov cx, dx
   shr cx, 1
   jnc trifill_even_iter
   stosb
trifill_even_iter:
   rep stosw
              
   and al, bl           ; put right hand mask in bl and colour in al
   not bl
   
   and bl, es:[di]      ; draw right hand pixels
   or al, bl
   stosb

   mov ch, ah           ; save colour

   ror ch, 1

   pop di
   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop dx
   pop ax
   dec bp
   jnz trifill_long_loop
   
   pop si
   pop di
   pop bp
   ret
_cga_draw_triangle_1u2d ENDP

   END
