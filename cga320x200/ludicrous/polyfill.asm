   DOSSEG
   .MODEL small
   .CODE

   line_offset DW 0, 80, 160, 240, 320, 400, 480, 560, 640, 720
               DW 800, 880, 960, 1040, 1120, 1200, 1280, 1360, 1440, 1520
               DW 1600, 1680, 1760, 1840, 1920, 2000, 2080, 2160, 2240, 2320
               DW 2400, 2480, 2560, 2640, 2720, 2800, 2880, 2960, 3040, 3120
               DW 3200, 3280, 3360, 3440, 3520, 3600, 3680, 3760, 3840, 3920
               DW 4000, 4080, 4160, 4240, 4320, 4400, 4480, 4560, 4640, 4720
               DW 4800, 4880, 4960, 5040, 5120, 5200, 5280, 5360, 5440, 5520
               DW 5600, 5680, 5760, 5840, 5920, 6000, 6080, 6160, 6240, 6320
               DW 6400, 6480, 6560, 6640, 6720, 6800, 6880, 6960, 7040, 7120
               DW 7200, 7280, 7360, 7440, 7520, 7600, 7680, 7760, 7840, 7920

   PUBLIC _cga_poly_fill
_cga_poly_fill PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, colour:BYTE
   ; fill a polygon with top point at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i].
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; final span, at line y + len, are omitted.
   push bp
	mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov ch, [colour]     ; put solid colour in ch

   mov bx, [y]          ; set dx to offset of CGA bank (odd/even)
	shr bx, 1
   jnc poly_fill_even_y
   add di, 8192
   ror ch, 1            ; adjust colour pattern for odd line
   ror ch, 1
poly_fill_even_y:

   shl bx, 1
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   mov WORD PTR cs:[inc_patch1+2], ax
   mov WORD PTR cs:[inc_patch2+2], ax

   mov ax, [x1]
   mov dx, [x2]
   dec dx               ; rightmost pixel is not drawn

   mov bp, [len]        ; get number of horizontal lines
                        ; last line is not drawn

   inc si               ; skip first increments
   
   push ax
   push dx
   push di

poly_fill_short_loop:
   cmp ax, dx           ; lines of non-positive length are skipped
   ja poly_fill_skip_line

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
   jns poly_fill_long_line
poly_fill_short_line:

   and bl, bh           ; compute overlapped mask and put masked colour in al
   and al, bl
   not bl

   and bl, es:[di]      ; draw pixels
   or al, bl
   stosb
   
poly_fill_skip_line:

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
inc_patch1:
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

   dec bp
   jnz poly_fill_short_loop

   pop di
   pop dx
   pop ax

   pop si
   pop di
   pop bp
   ret

poly_fill_long_loop:
   cmp ax, dx           ; lines of non-positive length are skipped
   ja poly_fill_skip_line

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
   js poly_fill_short_line

poly_fill_long_line:
   and al, bh           ; put left hand mask in bh and colour in al
   not bh

   and bh, es:[di]      ; draw pixels on left side of line
   or al, bh
   stosb

   mov al, ah           ; draw full colour bytes
   mov cx, dx
   shr cx, 1
   jnc poly_fill_even_iter
   stosb
poly_fill_even_iter:
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

   mov bx, ax           ; get next increments
inc_patch2:
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

   dec bp
   jnz poly_fill_long_loop
   
   pop di
   pop dx
   pop ax

   pop si
   pop di
   pop bp
   ret
_cga_poly_fill ENDP

   END
