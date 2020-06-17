   DOSSEG
   .MODEL small
   .CODE

   salc macro
      db 0d6h
   endm

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

   mov ax, [x0]         ; set cl to 4*(x0 mod 2)
   shr ax, 1
   sbb bh, bh
   and bh, 0f0h

   mov dx, [x1]         ; set bl to 4*(x1 mod 2)
   shr dx, 1
   sbb bl, bl

   add di, ax           ; add x0/2 to offset

   sub dx, ax           ; set dx to x1/2 - x0/2 (final offset - initial offset)

   mov ah, [colour]     ; put solid colour in ah
   shr ah, 1
   salc
   and al, 055h
   shr ah, 1
   sbb ah, ah
   and ah, 0aah
   add ah, al

   xor bh, 0ffh         ; prepare left mask in bh

   or bl, 0f0h          ; prepare right mask in bl

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
   shr cx, 1
   jnc hline_even_iter
   stosb
hline_even_iter:
   rep stosw
   
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
