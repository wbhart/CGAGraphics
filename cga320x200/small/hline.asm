   DOSSEG
   .MODEL small
   .CODE
   
   PUBLIC _cga_draw_hline
_cga_draw_hline PROC
   ARG buff:DWORD, x0:WORD, x1:WORD, y:WORD, colour:BYTE
   ; draw a line from (x0, y) - (x1, y) including endpoints in the given colour (0-3)
   push bp
	mov bp, sp
   push di

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

   mov ax, [x0]         ; set cl to 2*(x0 mod 4)
   mov cx, ax
   and cx, 3
   shl cx, 1

   mov dx, [x1]         ; set bl to 2*(x1 mod 4)
   mov bx, dx
   and bx, 3
   shl bx, 1

   shr ax, 1            ; add x0/4 to offset
   shr ax, 1
   add di, ax

   shr dx, 1            ; set dx to x1/4 - x0/4 (final offset - initial offset)
   shr dx, 1
   sub dx, ax

   mov al, [colour]     ; put solid colour in ah
   shr al, 1
   sbb ah, ah
   and ah, 055h
   shr al, 1
   sbb al, al
   and al, 0aah
   add ah, al

   mov bh, 0ffh         ; prepare left mask in bh
   shr bh, cl

   mov cl, bl           ; prepare right mask in bl
   mov bl, 0c0h
   sar bl, cl

   mov al, ah           ; copy colour in al

   dec dl               ; if first and last pixels are not in the same byte
   jns hline_long_line

   and bl, bh           ; compute overlapped mask and put masked colour in al
   and al, bl
   not bl

   and bl, es:[di]      ; draw pixels
   or al, bl
   stosb

   pop di
   pop bp
   ret

hline_long_line:
   and al, bh           ; put left hand mask in bh and colour in al
   not bh

   and bh, es:[di]      ; draw pixels on left side of line
   or al, bh
   stosb

   mov al, ah           ; draw full colour bytes
   mov cx, dx

   rep stosb
   
   mov al, ah           ; put right hand mask in bl and colour in al
   and al, bl
   not bl
   
   and bl, es:[di]      ; draw right hand pixels
   or al, bl
   stosb

   pop di
   pop bp
   ret
_cga_draw_hline ENDP

   END
