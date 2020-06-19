   DOSSEG
   .MODEL small
   .CODE

   jmp_addr   DW ?
   sp_save    DW ?
   ss_save    DW ?

   PUBLIC _cga_draw_ellipse1
_cga_draw_ellipse1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
   ; ellipse with centre (x0, y0) and semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; draws only the right side of the ellipse
   ; di, di+bx offsets of points above and below axis, ah:pixels
   ; dx:deltax (hi16), bp:deltay (hi16),
   ; al: deltax (lo8), ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; The idea to use the high 16 bits for branches is due to Reenigne
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   mov ax, [y0]         ; compute offset for line y0           
   shr ax, 1
   sbb di, di
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov dx, [x0]         ; adjust offset for column x0 + r
   add dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx


                        ; compute jump offset    
   xor si, si
   and ax, 3            ; deal with scrambled layout
   jnz ellipse1_j1
   lea si, ellipse1_jump1
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse1_jump_done
ellipse1_j1:
   dec ax
   jnz ellipse1_j2
   lea si, ellipse1_jump2
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse1_jump_done
ellipse1_j2:
   dec ax
   jnz ellipse1_j3
   lea si, ellipse1_jump3
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse1_jump_done
ellipse1_j3:
   lea si, ellipse1_jump4
   mov WORD PTR cs:[jmp_addr], si
   

ellipse1_jump_done:

   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch23 + 2], al
   mov BYTE PTR cs:[ellipse1_patch24 + 2], al
   mov WORD PTR cs:[ellipse1_patch37 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch32 + 2], al
   mov BYTE PTR cs:[ellipse1_patch33 + 2], al
   mov WORD PTR cs:[ellipse1_patch58 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch1 + 2], al
   mov BYTE PTR cs:[ellipse1_patch2 + 2], al
   mov WORD PTR cs:[ellipse1_patch51 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov BYTE PTR cs:[ellipse1_patch10 + 2], al
   mov BYTE PTR cs:[ellipse1_patch11 + 2], al
   mov WORD PTR cs:[ellipse1_patch44 + 2], ax


   mov ax, [r]          ; n = max(1, 7 - (r + s + 1)/32)
   add ax, [s]
   inc ax
   mov cl, 5
   shr ax, cl
   mov cx, 7
   sub cl, al
   adc cl, 0            ; n = max(1, n)
   sub cl, 1
   adc cl, 1

   mov ax, [s]          ; c = s^2
   mul al               
   mov bl, ah           ; c << n in bx:al
   xor bh, bh
   mov dl, cl           ; save n
ellipse1_n1:
   shl al, 1
   rcl bx, 1
   loop ellipse1_n1

   mov BYTE PTR cs:[ellipse1_patch6 + 1], al
   mov BYTE PTR cs:[ellipse1_patch8 + 1], al
   mov BYTE PTR cs:[ellipse1_patch15 + 1], al
   mov BYTE PTR cs:[ellipse1_patch17 + 1], al
   mov BYTE PTR cs:[ellipse1_patch19 + 1], al
   mov BYTE PTR cs:[ellipse1_patch21 + 1], al
   mov BYTE PTR cs:[ellipse1_patch28 + 1], al
   mov BYTE PTR cs:[ellipse1_patch30 + 1], al

   mov BYTE PTR cs:[ellipse1_patch38 + 2], al
   mov BYTE PTR cs:[ellipse1_patch42 + 2], al
   mov BYTE PTR cs:[ellipse1_patch45 + 2], al
   mov BYTE PTR cs:[ellipse1_patch49 + 2], al
   mov BYTE PTR cs:[ellipse1_patch52 + 2], al
   mov BYTE PTR cs:[ellipse1_patch56 + 2], al
   mov BYTE PTR cs:[ellipse1_patch59 + 2], al
   mov BYTE PTR cs:[ellipse1_patch63 + 2], al

   mov WORD PTR cs:[ellipse1_patch7 + 2], bx
   mov WORD PTR cs:[ellipse1_patch9 + 2], bx
   mov WORD PTR cs:[ellipse1_patch16 + 2], bx
   mov WORD PTR cs:[ellipse1_patch18 + 2], bx
   mov WORD PTR cs:[ellipse1_patch20 + 2], bx
   mov WORD PTR cs:[ellipse1_patch22 + 2], bx
   mov WORD PTR cs:[ellipse1_patch29 + 2], bx
   mov WORD PTR cs:[ellipse1_patch31 + 2], bx

   mov WORD PTR cs:[ellipse1_patch39 + 1], bx
   mov WORD PTR cs:[ellipse1_patch43 + 1], bx
   mov WORD PTR cs:[ellipse1_patch46 + 1], bx
   mov WORD PTR cs:[ellipse1_patch50 + 1], bx
   mov WORD PTR cs:[ellipse1_patch53 + 1], bx
   mov WORD PTR cs:[ellipse1_patch57 + 1], bx
   mov WORD PTR cs:[ellipse1_patch60 + 1], bx
   mov WORD PTR cs:[ellipse1_patch64 + 1], bx

   mov cx, [r]          ; deltax = 2c*r = 2*(s^2 << n)*r 
   mul cl
   mov si, ax
   mov ax, cx
   mov cl, dl
   mul bx
   mov dx, ax
   mov bx, si
   add dl, bh
   adc dh, 0
   shl bl, 1
   rcl dx, 1            ; dx:bl = deltax
   
   mov ax, [r]          ; ax:bh = 2a
   mul al
   mov bh, al
   mov al, ah
   xor ah, ah
   inc cl
ellipse1_n2:
   shl bh, 1
   rcl ax, 1
   loop ellipse1_n2

   mov BYTE PTR cs:[ellipse1_patch4 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch13 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch26 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch35 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch40 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch47 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch54 + 2], bh
   mov BYTE PTR cs:[ellipse1_patch61 + 2], bh

   mov WORD PTR cs:[ellipse1_patch5 + 2], ax
   mov WORD PTR cs:[ellipse1_patch14 + 2], ax
   mov WORD PTR cs:[ellipse1_patch27 + 2], ax
   mov WORD PTR cs:[ellipse1_patch36 + 2], ax
   mov WORD PTR cs:[ellipse1_patch41 + 2], ax
   mov WORD PTR cs:[ellipse1_patch48 + 2], ax
   mov WORD PTR cs:[ellipse1_patch55 + 2], ax
   mov WORD PTR cs:[ellipse1_patch62 + 2], ax

   shr ax, 1
   rcr bh, 1
   mov bp, ax
   mov cl, bh           ; bp:cl = delta y = a
   mov al, bl           ; dx:al = delta x
   
   xor si, si           ; si:ch = D = 0
   xor ch, ch
   xor bx, bx           ; distance between lines above and below axis
   
   jmp cs:[jmp_addr] 
                        ; verticalish part of ellipse
   ALIGN 2
ellipse1_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0cfh
ellipse1_patch1:
   or ah, 030h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0cfh
ellipse1_patch2:
   or ah, 030h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse1_patch4:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch5:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse1_x1

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump2
   jmp ellipse1_donev2  ; done verticalish

ellipse1_x2:
   sahf
   rcl dx, 1
ellipse1_patch6: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch7: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse1_patch8: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch9: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse1_jump2
   jmp ellipse1_donev2  ; done verticalish
   

   ALIGN 2
ellipse1_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0f3h
ellipse1_patch10:
   or ah, 0ch
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0f3h
ellipse1_patch11:
   or ah, 0ch
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse1_patch13:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch14:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse1_x2

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump3
   jmp ellipse1_donev3  ; done verticalish

ellipse1_x1:
   sahf
   rcl dx, 1
ellipse1_patch15: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch16: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse1_patch17: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch18: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse1_jump1
   jmp ellipse1_donev1  ; done verticalish


ellipse1_x3:
   sahf
   rcl dx, 1
ellipse1_patch19: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch20: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse1_patch21: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch22: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse1_jump3
   jmp ellipse1_donev3  ; done verticalish

   ALIGN 2
ellipse1_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0fch
ellipse1_patch23:
   or ah, 03h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0fch
ellipse1_patch24:
   or ah, 03h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse1_patch26:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch27:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse1_x3

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump4
   jmp ellipse1_donev4  ; done verticalish


ellipse1_x4:
   dec di
   sahf
   rcl dx, 1
ellipse1_patch28: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch29: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse1_patch30: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch31: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse1_jump4
   jmp ellipse1_donev4  ; done verticalish

   ALIGN 2
ellipse1_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 03fh
ellipse1_patch32:
   or ah, 0c0h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 03fh
ellipse1_patch33:
   or ah, 0c0h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse1_patch35:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch36:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse1_x4

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump1
   jmp ellipse1_donev1  ; done verticalish



                        ; horizontalish part of ellipse
ellipse1_donev4:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse1_h4   

ellipse1_donev1:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse1_h1   

ellipse1_donev2:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse1_h2   

ellipse1_donev3:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse1_h3   

  

   ; di, di+bx offsets of points above and below axis, dx: pixels
   ; dl: deltay (lo8), ax: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; es: dy (hi16) temp

ellipse1_h4:
   mov dh, [di+bx]
   mov dl, [di]
   and dx, 0fcfch
ellipse1_patch37:
   or dx, 0303h

ellipse1_patch38:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch39:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y

   cmp bp, si
   jge ellipse1_skip_y4
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse1_patch40:
   add dl, 012h         ; dy += 2r^2
ellipse1_patch41:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines 

   mov dh, [di+bx]
   mov dl, [di]

   mov es, bp
ellipse1_skip_y4:          
   
ellipse1_patch42:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch43:
   sbb ax, 01234h
ellipse1_doneh1_check:
   jl ellipse1_doneh1


ellipse1_h3:
   and dx, 0f3f3h
ellipse1_patch44:
   or dx, 0c0ch

ellipse1_patch45:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch46:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y3
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse1_patch47:
   add dl, 012h         ; dy += 2r^2
ellipse1_patch48:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines 

   mov dh, [di+bx]
   mov dl, [di]
   mov es, bp
ellipse1_skip_y3:
 
ellipse1_patch49:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch50:
   sbb ax, 01234h
   jl ellipse1_doneh1_check


ellipse1_h2:
   and dx, 0cfcfh
ellipse1_patch51:
   or dx, 03030h

ellipse1_patch52:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch53:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y2
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse1_patch54:
   add dl, 012h         ; dy += 2r^2
ellipse1_patch55:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines

   mov dh, [di+bx]
   mov dl, [di]
   mov es, bp
ellipse1_skip_y2:
 
ellipse1_patch56:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch57:
   sbb ax, 01234h
   jl ellipse1_doneh2


ellipse1_h1:
   and dx, 03f3fh
ellipse1_patch58:
   or dx, 0c0c0h

ellipse1_patch59:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch60:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax

   mov [di+bx], dh
   mov [di], dl

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y1

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse1_patch61:
   add dl, 012h         ; dy += 2r^2
ellipse1_patch62:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines

   mov es, bp
ellipse1_skip_y1:
   dec di
 
ellipse1_patch63:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch64:
   sbb ax, 01234h
   jl ellipse1_doneh2_skip ; skip extra byte

   jmp ellipse1_h4


ellipse1_doneh2:

   mov [di+bx], dh
   mov [di], dl

ellipse1_doneh2_skip:

   pop dx

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse1 ENDP

   PUBLIC _cga_draw_ellipse2
_cga_draw_ellipse2 PROC
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
   ; ellipse with centre (x0, y0) and semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; draws only the left side of the ellipse
   ; di, di+bx offsets of points above and below axis, ah:pixels
   ; dx:deltax (hi16), bp:deltay (hi16),
   ; al: deltax (lo8), ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; The idea to use the high 16 bits for branches is due to Reenigne
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   mov ax, [y0]         ; compute offset for line y0
   shr ax, 1
   sbb di, di
   and di, 8192
   shl ax, 1            
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov dx, [x0]         ; adjust offset for column x0 - r
   sub dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx


                        ; compute jump offset    
   xor si, si
   and ax, 3            ; deal with scrambled layout
   jnz ellipse2_j1
   lea si, ellipse2_jump1
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse2_jump_done
ellipse2_j1:
   dec ax
   jnz ellipse2_j2
   lea si, ellipse2_jump2
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse2_jump_done
ellipse2_j2:
   dec ax
   jnz ellipse2_j3
   lea si, ellipse2_jump3
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse2_jump_done
ellipse2_j3:
   lea si, ellipse2_jump4
   mov WORD PTR cs:[jmp_addr], si
   

ellipse2_jump_done:

   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov BYTE PTR cs:[ellipse2_patch32 + 2], al
   mov BYTE PTR cs:[ellipse2_patch33 + 2], al
   mov WORD PTR cs:[ellipse2_patch58 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse2_patch23 + 2], al
   mov BYTE PTR cs:[ellipse2_patch24 + 2], al
   mov WORD PTR cs:[ellipse2_patch37 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse2_patch10 + 2], al
   mov BYTE PTR cs:[ellipse2_patch11 + 2], al
   mov WORD PTR cs:[ellipse2_patch44 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov BYTE PTR cs:[ellipse2_patch1 + 2], al
   mov BYTE PTR cs:[ellipse2_patch2 + 2], al
   mov WORD PTR cs:[ellipse2_patch51 + 2], ax


   mov ax, [r]          ; n = max(1, 7 - (r + s + 1)/32)
   add ax, [s]
   inc ax
   mov cl, 5
   shr ax, cl
   mov cx, 7
   sub cl, al
   adc cl, 0            ; n = max(1, n)
   sub cl, 1
   adc cl, 1

   mov ax, [s]          ; c = s^2
   mul al               
   mov bl, ah           ; c << n in bx:al
   xor bh, bh
   mov dl, cl           ; save n
ellipse2_n1:
   shl al, 1
   rcl bx, 1
   loop ellipse2_n1

   mov BYTE PTR cs:[ellipse2_patch6 + 1], al
   mov BYTE PTR cs:[ellipse2_patch8 + 1], al
   mov BYTE PTR cs:[ellipse2_patch15 + 1], al
   mov BYTE PTR cs:[ellipse2_patch17 + 1], al
   mov BYTE PTR cs:[ellipse2_patch19 + 1], al
   mov BYTE PTR cs:[ellipse2_patch21 + 1], al
   mov BYTE PTR cs:[ellipse2_patch28 + 1], al
   mov BYTE PTR cs:[ellipse2_patch30 + 1], al

   mov BYTE PTR cs:[ellipse2_patch38 + 2], al
   mov BYTE PTR cs:[ellipse2_patch42 + 2], al
   mov BYTE PTR cs:[ellipse2_patch45 + 2], al
   mov BYTE PTR cs:[ellipse2_patch49 + 2], al
   mov BYTE PTR cs:[ellipse2_patch52 + 2], al
   mov BYTE PTR cs:[ellipse2_patch56 + 2], al
   mov BYTE PTR cs:[ellipse2_patch59 + 2], al
   mov BYTE PTR cs:[ellipse2_patch63 + 2], al

   mov WORD PTR cs:[ellipse2_patch7 + 2], bx
   mov WORD PTR cs:[ellipse2_patch9 + 2], bx
   mov WORD PTR cs:[ellipse2_patch16 + 2], bx
   mov WORD PTR cs:[ellipse2_patch18 + 2], bx
   mov WORD PTR cs:[ellipse2_patch20 + 2], bx
   mov WORD PTR cs:[ellipse2_patch22 + 2], bx
   mov WORD PTR cs:[ellipse2_patch29 + 2], bx
   mov WORD PTR cs:[ellipse2_patch31 + 2], bx

   mov WORD PTR cs:[ellipse2_patch39 + 1], bx
   mov WORD PTR cs:[ellipse2_patch43 + 1], bx
   mov WORD PTR cs:[ellipse2_patch46 + 1], bx
   mov WORD PTR cs:[ellipse2_patch50 + 1], bx
   mov WORD PTR cs:[ellipse2_patch53 + 1], bx
   mov WORD PTR cs:[ellipse2_patch57 + 1], bx
   mov WORD PTR cs:[ellipse2_patch60 + 1], bx
   mov WORD PTR cs:[ellipse2_patch64 + 1], bx

   mov cx, [r]          ; deltax = 2c*r = 2*(s^2 << n)*r 
   mul cl
   mov si, ax
   mov ax, cx
   mov cl, dl
   mul bx
   mov dx, ax
   mov bx, si
   add dl, bh
   adc dh, 0
   shl bl, 1
   rcl dx, 1            ; dx:bl = deltax
   
   mov ax, [r]          ; ax:bh = 2a
   mul al
   mov bh, al
   mov al, ah
   xor ah, ah
   inc cl
ellipse2_n2:
   shl bh, 1
   rcl ax, 1
   loop ellipse2_n2

   mov BYTE PTR cs:[ellipse2_patch4 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch13 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch26 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch35 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch40 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch47 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch54 + 2], bh
   mov BYTE PTR cs:[ellipse2_patch61 + 2], bh

   mov WORD PTR cs:[ellipse2_patch5 + 2], ax
   mov WORD PTR cs:[ellipse2_patch14 + 2], ax
   mov WORD PTR cs:[ellipse2_patch27 + 2], ax
   mov WORD PTR cs:[ellipse2_patch36 + 2], ax
   mov WORD PTR cs:[ellipse2_patch41 + 2], ax
   mov WORD PTR cs:[ellipse2_patch48 + 2], ax
   mov WORD PTR cs:[ellipse2_patch55 + 2], ax
   mov WORD PTR cs:[ellipse2_patch62 + 2], ax

   shr ax, 1
   rcr bh, 1
   mov bp, ax
   mov cl, bh           ; bp:cl = delta y = a
   mov al, bl           ; dx:al = delta x
   
   xor si, si           ; si:ch = D = 0
   xor ch, ch
   xor bx, bx           ; distance between lines above and below axis
   
   jmp cs:[jmp_addr] 
                        ; verticalish part of ellipse
   ALIGN 2
ellipse2_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0f3h
ellipse2_patch1:
   or ah, 0ch
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0f3h
ellipse2_patch2:
   or ah, 0ch
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse2_patch4:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch5:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse2_x4

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump3
   jmp ellipse2_donev3  ; done verticalish

ellipse2_x3:
   sahf
   rcl dx, 1
ellipse2_patch6: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch7: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse2_patch8: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch9: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse2_jump3
   jmp ellipse2_donev3  ; done verticalish
   

   ALIGN 2
ellipse2_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0cfh
ellipse2_patch10:
   or ah, 030h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0cfh
ellipse2_patch11:
   or ah, 020h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse2_patch13:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch14:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse2_x3

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump2
   jmp ellipse2_donev2  ; done verticalish

ellipse2_x4:
   sahf
   rcl dx, 1
ellipse2_patch15: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch16: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse2_patch17: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch18: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse2_jump4
   jmp ellipse2_donev4  ; done verticalish


ellipse2_x2:
   sahf
   rcl dx, 1
ellipse2_patch19: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch20: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse2_patch21: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch22: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse2_jump2
   jmp ellipse2_donev2  ; done verticalish

   ALIGN 2
ellipse2_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 03fh
ellipse2_patch23:
   or ah, 0c0h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 03fh
ellipse2_patch24:
   or ah, 0c0h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse2_patch26:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch27:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse2_x2

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump1
   jmp ellipse2_donev1  ; done verticalish


ellipse2_x1:
   inc di
   sahf
   rcl dx, 1
ellipse2_patch28: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch29: 
   sbb dx, 01234h
   sub ch, al           ; D -= dx
   sbb si, dx
ellipse2_patch30: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch31: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse2_jump1
   jmp ellipse2_donev1  ; done verticalish

   ALIGN 2
ellipse2_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   and ah, 0fch
ellipse2_patch32:
   or ah, 03h
   mov [di+bx], ah
   mov ah, [di]         ; draw pixel below axis
   and ah, 0fch
ellipse2_patch33:
   or ah, 03h
   mov [di], ah

   push ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   pop ax

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += dy
   adc si, bp
ellipse2_patch35:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch36:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse2_x1

   sahf
   rcl dx, 1
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump4
   jmp ellipse2_donev4  ; done verticalish



                        ; horizontalish part of ellipse
ellipse2_donev1:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse2_h1   

ellipse2_donev4:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse2_h4 

ellipse2_donev3:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse2_h3   

ellipse2_donev2:

   mov es, bp
   push cx
   mov cl, al
   mov ax, dx
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov dh, [di+bx]
   mov dl, [di]
   jmp ellipse2_h2   
  

   ; di, di+bx offsets of points above and below axis, dx: pixels
   ; dl: deltay (lo8), ax: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; es: dy (hi16) temp

ellipse2_h1:
   mov dh, [di+bx]
   mov dl, [di]
   and dx, 03f3fh
ellipse2_patch37:
   or dx, 0c0c0h

ellipse2_patch38:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch39:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y

   cmp bp, si
   jge ellipse2_skip_y1
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse2_patch40:
   add dl, 012h         ; dy += 2r^2
ellipse2_patch41:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines 

   mov dh, [di+bx]
   mov dl, [di]

   mov es, bp
ellipse2_skip_y1:          

ellipse2_patch42:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch43:
   sbb ax, 01234h
ellipse2_doneh1_check:
   jl ellipse2_doneh1


ellipse2_h2:
   and dx, 0cfcfh
ellipse2_patch44:
   or dx, 0303h

ellipse2_patch45:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch46:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y2
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse2_patch47:
   add dl, 012h         ; dy += 2r^2
ellipse2_patch48:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines 

   mov dh, [di+bx]
   mov dl, [di]
   mov es, bp
ellipse2_skip_y2:
 
ellipse2_patch49:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch50:
   sbb ax, 01234h
   jl ellipse2_doneh1_check


ellipse2_h3:
   and dx, 0f3f3h
ellipse2_patch51:
   or dx, 0c0ch

ellipse2_patch52:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch53:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y3
   
   mov [di+bx], dh
   mov [di], dl

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse2_patch54:
   add dl, 012h         ; dy += 2r^2
ellipse2_patch55:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines

   mov dh, [di+bx]
   mov dl, [di]
   mov es, bp
ellipse2_skip_y3:
 
ellipse2_patch56:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch57:
   sbb ax, 01234h
   jl ellipse2_doneh2


ellipse2_h4:
   and dx, 0fcfch
ellipse2_patch58:
   or dx, 0303h

ellipse2_patch59:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch60:
   sbb ax, 01234h
   add ch, cl           ; D += dx
   adc si, ax

   mov [di+bx], dh
   mov [di], dl

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y4

   pop dx

   mov bp, es
   sub ch, dl           ; D -= dy
   sbb si, bp
ellipse2_patch61:
   add dl, 012h         ; dy += 2r^2
ellipse2_patch62:
   adc bp, 01234h

   push dx

   sub di, 8112         ; update offset of odd <-> even
   sbb dx, dx
   and dx, 16304
   add di, dx

   sub bx, 80           ; decrement/increment y lines

   mov es, bp
ellipse2_skip_y4:
   inc di
 
ellipse2_patch63:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch64:
   sbb ax, 01234h
   jle ellipse2_doneh2_skip ; skip extra byte and doubled pixel

   jmp ellipse2_h1


ellipse2_doneh2:

   mov [di+bx], dh
   mov [di], dl

ellipse2_doneh2_skip:

   pop dx

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse2 ENDP

   ; precomputed ellipse data in format
   ; m, n, b1, b2, b3, ..., bm, b, q, r, c1, c2, c3, ..., cq, c
   ; if the number of pixels in the verticalish part of the ellipse if s then
   ; s - 1 = 8*m + n where n lies in [1, 8]
   ; if the number of pixels in the horizontalish part of the ellipse is t then
   ; t = 8*q + r where r lies in [1, 8]
   ; the bits of the bi are used first, finally the low n bits of b are used last 
   ; always starting with the least significant bit
   ; the bits specify when a move should be made horizontally, for each pixel in
   ; the verticalish part, after the first pixel is drawn
   ; then the horizontalish part is specified with the the bits of the ci being
   ; used, then the low r bits of c being used
   ; the bits specify when a vertical move is NOT made in the horizontalish part
   ; starting with the first pixel of the horizontalish part 

   _ellipse_data DB 6, 5, 0, 65, 68, 169, 170, 221, 23, 9, 6, 8, 68, 74, 85, 107, 219, 221, 247, 247, 63

   PUBLIC _get_ellipse_data
_get_ellipse_data PROC
   ARG i:WORD
   push bp
   mov bp, sp
   lea bx, _ellipse_data
   add bx, [i]
   mov al, BYTE PTR cs:[bx]
   xor ah, ah
   pop bp
   ret
_get_ellipse_data ENDP

   PUBLIC _cga_draw_ellipse_precomp1
_cga_draw_ellipse_precomp1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE, arr:WORD
   ; ellipse with centre (x0, y0) and semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; draws only the right side of the ellipse
   ; di, di+bx offsets of points above and below axis, ax: accum
   ; sp: yinc, dh: iter/8, cx: iter upto 8, bp: index into cs array
   ; dl: direction bits 
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, ds           ; use ES for array to support small memory model
   mov es, ax

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   cli                  ; save and free up sp and ss
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta
   jnc ellipse_precomp1_y_even
   mov sp, -8112
ellipse_precomp1_y_even:
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

   mov dx, [x0]         ; adjust offset for column x0 + r
   add dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx

                        ; compute jump offset    
   and ax, 3            ; deal with scrambled layout
   jnz ellipse_precomp1_j1
   lea si, ellipse_precomp1_jump1
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp1_jump_done
ellipse_precomp1_j1:
   dec ax
   jnz ellipse_precomp1_j2
   lea si, ellipse_precomp1_jump2
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp1_jump_done
ellipse_precomp1_j2:
   dec ax
   jnz ellipse_precomp1_j3
   lea si, ellipse_precomp1_jump3
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp1_jump_done
ellipse_precomp1_j3:
   lea si, ellipse_precomp1_jump4
   mov WORD PTR cs:[jmp_addr], si
   

ellipse_precomp1_jump_done:

   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp1_patch3 + 1], ax
   mov WORD PTR cs:[ellipse_precomp1_patch5 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp1_patch4 + 1], ax
   mov WORD PTR cs:[ellipse_precomp1_patch8 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp1_patch1 + 1], ax
   mov WORD PTR cs:[ellipse_precomp1_patch7 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov WORD PTR cs:[ellipse_precomp1_patch2 + 1], ax
   mov WORD PTR cs:[ellipse_precomp1_patch6 + 1], ax

   mov bp, [arr]

   mov dh, BYTE PTR es:[bp] ; outer loop
   inc bp

   mov bx, bp
   add bl, dh
   adc bh, 0
   mov cl, BYTE PTR es:[bx + 3] ; inner loop horizontalish
   mov BYTE PTR cs:[ellipse_precomp1_patch13 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch14 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch15 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch16 + 1], cl

   mov cl, BYTE PTR es:[bp] ; inner loop verticalish
   mov BYTE PTR cs:[ellipse_precomp1_patch9 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch10 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch11 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp1_patch12 + 1], cl
   
   cmp dh, 0
   je ellipse_precomp1_skip8v
   mov cl, 8
ellipse_precomp1_skip8v:

   inc bp
   mov dl, BYTE PTR es:[bp] ; first byte of data
   inc bp 

   xor bx, bx           ; distance between lines above and below axis
   xor ch, ch           ; loop uses cx, not cl

   jmp cs:[jmp_addr] 
                        ; part of horizontalish part moved to shorten jump
ellipse_precomp1_donev3:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp1_skip8h1
   mov cl, 8
ellipse_precomp1_skip8h1:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp1_h3   

                        ; verticalish part of ellipse

   ALIGN 2
ellipse_precomp1_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0f3f3h
ellipse_precomp1_patch2:
   or ax, 0c0ch
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp1_x2

ellipse_precomp1_x3:
   loop ellipse_precomp1_jump3
   dec dh                      ; check if done verticalish
   jl ellipse_precomp1_donev3  ; done verticalish
ellipse_precomp1_patch9:
   mov cl, 012h
   jz ellipse_precomp1_skip8_1
   mov cl, 8
ellipse_precomp1_skip8_1:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp1_jump3

   ALIGN 2
ellipse_precomp1_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0fcfch
ellipse_precomp1_patch3:
   or ax, 0303h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp1_x3
   inc di

ellipse_precomp1_x4:
   dec di
   loop ellipse_precomp1_jump4
   dec dh                      ; check if done verticalish
   jl ellipse_precomp1_donev4  ; done verticalish
ellipse_precomp1_patch10:
   mov cl, 012h
   jz ellipse_precomp1_skip8_2
   mov cl, 8
ellipse_precomp1_skip8_2:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp1_jump4

   ALIGN 2
ellipse_precomp1_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0cfcfh
ellipse_precomp1_patch1:
   or ax, 03030h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp1_x1

ellipse_precomp1_x2:
   loop ellipse_precomp1_jump2
   dec dh                      ; check if done verticalish
   jl ellipse_precomp1_donev2  ; done verticalish
ellipse_precomp1_patch11:
   mov cl, 012h
   jz ellipse_precomp1_skip8_3
   mov cl, 8
ellipse_precomp1_skip8_3:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp1_jump2

   ALIGN 2
ellipse_precomp1_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 03f3fh
ellipse_precomp1_patch4:
   or ax, 0c0c0h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp1_x4

ellipse_precomp1_x1:
   loop ellipse_precomp1_jump1
   dec dh                      ; check if done verticalish
   jl ellipse_precomp1_donev1  ; done verticalish
ellipse_precomp1_patch12:
   mov cl, 012h
   jz ellipse_precomp1_skip8_4
   mov cl, 8
ellipse_precomp1_skip8_4:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp1_jump1

                        ; horizontalish part of ellipse
   
ellipse_precomp1_donev4:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp1_skip8h2
   mov cl, 8
ellipse_precomp1_skip8h2:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp1_h4   

ellipse_precomp1_donev2:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp1_skip8h3
   mov cl, 8
ellipse_precomp1_skip8h3:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp1_h2   

ellipse_precomp1_donev1:

   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp1_skip8h4
   mov cl, 8
ellipse_precomp1_skip8h4:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp1_h1   


ellipse_precomp1_doneh1:
   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret   


ellipse_precomp1_byte4:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp1_doneh1  ; done horizontalish
ellipse_precomp1_patch13:
   mov cl, 012h
   jz ellipse_precomp1_skip8_5
   mov cl, 8
ellipse_precomp1_skip8_5:
   jmp ellipse_precomp1_h3

ellipse_precomp1_byte3:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp1_doneh1  ; done horizontalish
ellipse_precomp1_patch14:
   mov cl, 012h
   jz ellipse_precomp1_skip8_6
   mov cl, 8
ellipse_precomp1_skip8_6:
   jmp ellipse_precomp1_h2


ellipse_precomp1_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch
ellipse_precomp1_patch5:
   or ax, 0303h                     

   shr dl, 1
   jc ellipse_precomp1_skip_y4
   
   mov [di+bx], ah
   mov [di], al
   
   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp1_skip_y4:          
   dec cl
   jz ellipse_precomp1_byte4


ellipse_precomp1_h3:
   and ax, 0f3f3h
ellipse_precomp1_patch6:
   or ax, 0c0ch                     

   shr dl, 1
   jc ellipse_precomp1_skip_y3
   
   mov [di+bx], ah
   mov [di], al

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp1_skip_y3:
   dec cl
   jz ellipse_precomp1_byte3


ellipse_precomp1_h2:
   and ax, 0cfcfh
ellipse_precomp1_patch7:
   or ax, 03030h

   shr dl, 1
   jc ellipse_precomp1_skip_y2
   
   mov [di+bx], ah
   mov [di], al

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp1_skip_y2:
   dec cl
   jz ellipse_precomp1_byte2


ellipse_precomp1_h1:
   and ax, 03f3fh
ellipse_precomp1_patch8:
   or ax, 0c0c0h

   mov [di+bx], ah
   mov [di], al

   shr dl, 1
   jc ellipse_precomp1_skip_y1

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines

ellipse_precomp1_skip_y1:
   dec di
   dec cl
   jz ellipse_precomp1_byte1 ; skip extra byte
   jmp ellipse_precomp1_h4


ellipse_precomp1_byte2:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp1_doneh2  ; done horizontalish
ellipse_precomp1_patch15:
   mov cl, 012h
   jz ellipse_precomp1_skip8_7
   mov cl, 8
ellipse_precomp1_skip8_7:
   jmp ellipse_precomp1_h1

ellipse_precomp1_byte1:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp1_doneh2_skip  ; done horizontalish
ellipse_precomp1_patch16:
   mov cl, 012h
   jz ellipse_precomp1_skip8_8
   mov cl, 8
ellipse_precomp1_skip8_8:
   jmp ellipse_precomp1_h4


ellipse_precomp1_doneh2:
   mov [di+bx], ah
   mov [di], al

ellipse_precomp1_doneh2_skip:
   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse_precomp1 ENDP

   PUBLIC _cga_draw_ellipse_precomp2
_cga_draw_ellipse_precomp2 PROC
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE, arr:WORD
   ; ellipse with centre (x0, y0) and semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; draws only the right side of the ellipse
   ; di, di+bx offsets of points above and below axis, ax: accum
   ; sp: yinc, dh: iter/8, cx: iter upto 8, bp: index into cs array
   ; dl: direction bits 
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, ds           ; use ES for array to support small memory model
   mov es, ax

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   cli                  ; save and free up sp and ss
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta
   jnc ellipse_precomp2_y_even
   mov sp, -8112
ellipse_precomp2_y_even:
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

   mov dx, [x0]         ; adjust offset for column x0 + r
   sub dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx

                        ; compute jump offset    
   and ax, 3            ; deal with scrambled layout
   jnz ellipse_precomp2_j1
   lea si, ellipse_precomp2_jump1
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp2_jump_done
ellipse_precomp2_j1:
   dec ax
   jnz ellipse_precomp2_j2
   lea si, ellipse_precomp2_jump2
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp2_jump_done
ellipse_precomp2_j2:
   dec ax
   jnz ellipse_precomp2_j3
   lea si, ellipse_precomp2_jump3
   mov WORD PTR cs:[jmp_addr], si
   jmp ellipse_precomp2_jump_done
ellipse_precomp2_j3:
   lea si, ellipse_precomp2_jump4
   mov WORD PTR cs:[jmp_addr], si
   

ellipse_precomp2_jump_done:

   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp2_patch3 + 1], ax
   mov WORD PTR cs:[ellipse_precomp2_patch5 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp2_patch4 + 1], ax
   mov WORD PTR cs:[ellipse_precomp2_patch8 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[ellipse_precomp2_patch1 + 1], ax
   mov WORD PTR cs:[ellipse_precomp2_patch7 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov WORD PTR cs:[ellipse_precomp2_patch2 + 1], ax
   mov WORD PTR cs:[ellipse_precomp2_patch6 + 1], ax

   mov bp, [arr]

   mov dh, BYTE PTR es:[bp]
   inc bp

   mov bx, bp
   add bl, dh
   adc bh, 0
   mov cl, BYTE PTR es:[bx + 3] ; inner loop horizontalish
   mov BYTE PTR cs:[ellipse_precomp2_patch13 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch14 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch15 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch16 + 1], cl

   mov cl, BYTE PTR es:[bp] ; inner loop verticalish
   mov BYTE PTR cs:[ellipse_precomp2_patch9 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch10 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch11 + 1], cl
   mov BYTE PTR cs:[ellipse_precomp2_patch12 + 1], cl
   
   cmp dh, 0
   je ellipse_precomp2_skip8v
   mov cl, 8
ellipse_precomp2_skip8v:

   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp 

   xor bx, bx           ; distance between lines above and below axis
   xor ch, ch           ; loop uses cx, not cl

   jmp cs:[jmp_addr] 
                        ; part of horizontalish part moved to shorten jump
ellipse_precomp2_donev3:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp2_skip8h1
   mov cl, 8
ellipse_precomp2_skip8h1:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp2_h3   

                        ; verticalish part of ellipse

   ALIGN 2
ellipse_precomp2_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0f3f3h
ellipse_precomp2_patch2:
   or ax, 0c0ch
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp2_x4

ellipse_precomp2_x3:
   loop ellipse_precomp2_jump3
   dec dh                      ; check if done verticalish
   jl ellipse_precomp2_donev3  ; done verticalish
ellipse_precomp2_patch9:
   mov cl, 012h
   jz ellipse_precomp2_skip8_1
   mov cl, 8
ellipse_precomp2_skip8_1:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp2_jump3

   ALIGN 2
ellipse_precomp2_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0fcfch
ellipse_precomp2_patch3:
   or ax, 0303h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp2_x1

ellipse_precomp2_x4:
   loop ellipse_precomp2_jump4
   dec dh                      ; check if done verticalish
   jl ellipse_precomp2_donev4  ; done verticalish
ellipse_precomp2_patch10:
   mov cl, 012h
   jz ellipse_precomp2_skip8_2
   mov cl, 8
ellipse_precomp2_skip8_2:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp2_jump4

   ALIGN 2
ellipse_precomp2_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0cfcfh
ellipse_precomp2_patch1:
   or ax, 03030h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp2_x3

ellipse_precomp2_x2:
   loop ellipse_precomp2_jump2
   dec dh                      ; check if done verticalish
   jl ellipse_precomp2_donev2  ; done verticalish
ellipse_precomp2_patch11:
   mov cl, 012h
   jz ellipse_precomp2_skip8_3
   mov cl, 8
ellipse_precomp2_skip8_3:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp2_jump2

   ALIGN 2
ellipse_precomp2_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 03f3fh
ellipse_precomp2_patch4:
   or ax, 0c0c0h
   mov [di+bx], ah
   mov [di], al

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   shr dl, 1
   jc ellipse_precomp2_x2
   dec di

ellipse_precomp2_x1:
   inc di
   loop ellipse_precomp2_jump1
   dec dh                      ; check if done verticalish
   jl ellipse_precomp2_donev1  ; done verticalish
ellipse_precomp2_patch12:
   mov cl, 012h
   jz ellipse_precomp2_skip8_4
   mov cl, 8
ellipse_precomp2_skip8_4:
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp2_jump1

                        ; horizontalish part of ellipse
   
ellipse_precomp2_donev4:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp2_skip8h2
   mov cl, 8
ellipse_precomp2_skip8h2:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp2_h4   

ellipse_precomp2_donev2:
   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp2_skip8h3
   mov cl, 8
ellipse_precomp2_skip8h3:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp2_h2   

ellipse_precomp2_donev1:

   mov dh, BYTE PTR es:[bp]
   inc bp
   mov cl, BYTE PTR es:[bp]
   cmp dh, 0
   je ellipse_precomp2_skip8h4
   mov cl, 8
ellipse_precomp2_skip8h4:
   inc bp
   mov dl, BYTE PTR es:[bp]
   inc bp
   jmp ellipse_precomp2_h1   


ellipse_precomp2_doneh1:
   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret   


ellipse_precomp2_byte1:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp2_doneh1  ; done horizontalish
ellipse_precomp2_patch13:
   mov cl, 012h
   jz ellipse_precomp2_skip8_5
   mov cl, 8
ellipse_precomp2_skip8_5:
   jmp ellipse_precomp2_h2

ellipse_precomp2_byte2:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp2_doneh1  ; done horizontalish
ellipse_precomp2_patch14:
   mov cl, 012h
   jz ellipse_precomp2_skip8_6
   mov cl, 8
ellipse_precomp2_skip8_6:
   jmp ellipse_precomp2_h3


ellipse_precomp2_h1:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 03f3fh
ellipse_precomp2_patch8:
   or ax, 0c0c0h

   shr dl, 1
   jc ellipse_precomp2_skip_y1

   mov [di+bx], ah
   mov [di], al

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp2_skip_y1:
   dec cl
   jz ellipse_precomp2_byte1 ; skip extra byte


ellipse_precomp2_h2:
   and ax, 0cfcfh
ellipse_precomp2_patch7:
   or ax, 03030h

   shr dl, 1
   jc ellipse_precomp2_skip_y2
   
   mov [di+bx], ah
   mov [di], al

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp2_skip_y2:
   dec cl
   jz ellipse_precomp2_byte2


ellipse_precomp2_h3:
   and ax, 0f3f3h
ellipse_precomp2_patch6:
   or ax, 0c0ch                     

   shr dl, 1
   jc ellipse_precomp2_skip_y3
   
   mov [di+bx], ah
   mov [di], al

   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]

ellipse_precomp2_skip_y3:
   dec cl
   jz ellipse_precomp2_byte3


ellipse_precomp2_h4:
   and ax, 0fcfch
ellipse_precomp2_patch5:
   or ax, 0303h                     

   mov [di+bx], ah
   mov [di], al
   
   shr dl, 1
   jc ellipse_precomp2_skip_y4
   
   add di, sp
   xor sp, 0c050h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

ellipse_precomp2_skip_y4:
   inc di          
   dec cl
   jz ellipse_precomp2_byte4

   jmp ellipse_precomp2_h1


ellipse_precomp2_byte3:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp2_doneh2  ; done horizontalish
ellipse_precomp2_patch15:
   mov cl, 012h
   jz ellipse_precomp2_skip8_7
   mov cl, 8
ellipse_precomp2_skip8_7:
   jmp ellipse_precomp2_h4
   

ellipse_precomp2_byte4:
   mov dl, BYTE PTR es:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jl ellipse_precomp2_doneh2_skip  ; done horizontalish
ellipse_precomp2_patch16:
   mov cl, 012h
   jz ellipse_precomp2_skip8_8
   mov cl, 8
ellipse_precomp2_skip8_8:
   jmp ellipse_precomp2_h1


ellipse_precomp2_doneh2:
   mov [di+bx], ah
   mov [di], al

ellipse_precomp2_doneh2_skip:
   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse_precomp2 ENDP

   PUBLIC _cga_draw_ellipse_precompute
_cga_draw_ellipse_precompute PROC
   ARG arr:WORD, r:WORD, s:WORD
   ; precompute ellipse with semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; di: offset of array, ch: direction bits, cl: inner loop count,
   ; ah: accum, dx: deltax (hi16), sp: outer loop count, bp: deltay (hi16),
   ; al: deltax (lo8), bh: D (lo8), bl: deltay (lo8), si: D (hi16)
   ; The idea to use the high 16 bits for branches is due to Reenigne
   push bp
   mov bp, sp
   push di
   push si
   push ds

   cli                  ; save and free up sp and ss
   mov WORD PTR cs:[sp_save], sp
   mov ax, ss
   mov WORD PTR cs:[ss_save], ax


   mov ax, [r]          ; n = max(1, 7 - (r + s + 1)/32)
   add ax, [s]
   inc ax
   mov cl, 5
   shr ax, cl
   mov cx, 7
   sub cl, al
   adc cl, 0            ; loop will also repeat at least once

   mov ax, [s]          ; c = s^2
   mul al               
   mov bl, ah           ; c << n in bx:al
   xor bh, bh
   mov dl, cl           ; save n
ellipse_precompute_n1:
   shl al, 1
   rcl bx, 1
   loop ellipse_precompute_n1

   mov BYTE PTR cs:[ellipse_precompute_patch3 + 1], al
   mov BYTE PTR cs:[ellipse_precompute_patch5 + 1], al
   mov BYTE PTR cs:[ellipse_precompute_patch7 + 1], al
   mov BYTE PTR cs:[ellipse_precompute_patch11 + 1], al
   mov BYTE PTR cs:[ellipse_precompute_patch13 + 1], al

   mov WORD PTR cs:[ellipse_precompute_patch4 + 2], bx
   mov WORD PTR cs:[ellipse_precompute_patch6 + 2], bx
   mov WORD PTR cs:[ellipse_precompute_patch8 + 2], bx
   mov WORD PTR cs:[ellipse_precompute_patch12 + 2], bx
   mov WORD PTR cs:[ellipse_precompute_patch14 + 2], bx

   mov cx, [r]          ; deltax = 2c*r = 2*(s^2 << n)*r 
   mul cl
   mov cl, dl
   mov si, ax
   mov ax, [r]
   mul bx
   mov dx, ax
   mov bx, si
   add dl, bh
   adc dh, 0
   shl bl, 1
   rcl dx, 1            ; dx:bl = deltax
   
   mov ax, [r]          ; ax:bh = 2a
   mul al
   mov bh, al
   mov al, ah
   xor ah, ah
   inc cl
ellipse_precompute_n2:
   shl bh, 1
   rcl ax, 1
   loop ellipse_precompute_n2

   mov di, [arr]

   mov BYTE PTR cs:[ellipse_precompute_patch1 + 2], bh
   mov BYTE PTR cs:[ellipse_precompute_patch9 + 2], bh

   mov WORD PTR cs:[ellipse_precompute_patch2 + 2], ax
   mov WORD PTR cs:[ellipse_precompute_patch10 + 2], ax

   shr ax, 1
   rcr bh, 1
   mov bp, ax
   mov al, bl           ; dx:al = delta x
   mov bl, bh           ; bp:cl = delta y = a
   
   xor si, si           ; si:bh = D = 0
   xor bh, bh

   xor sp, sp           ; set up inner/outer loop counters
   mov cl, 8

   xor ch, ch           ; set up direction bits and array pointer
   add di, 2

                        ; verticalish part of ellipse
ellipse_precompute_jump:
   add bh, bl           ; D += dy
   adc si, bp
ellipse_precompute_patch1:          
   add bl, 012h         ; dy += 2r^2
ellipse_precompute_patch2:
   adc bp, 01234h

   shr dx, 1            ; if dx/2 <= D, decrement x
   lahf
   cmp dx, si
   jle ellipse_precompute_x

   sahf
   rcl dx, 1

   clc
   rcr ch, 1

   dec cl
   jnz ellipse_precompute_nosave1

   mov cl, 8
   mov BYTE PTR [di], ch
   inc sp
   inc di

ellipse_precompute_nosave1:

   cmp dx, bp           ; check if done verticalish
   jae ellipse_precompute_jump
   jmp ellipse_precompute_donev  ; done verticalish

ellipse_precompute_x:
   sahf
   rcl dx, 1

   stc
   rcr ch, 1

ellipse_precompute_patch3: 
   sub al, 012h         ; dx -= s^2
ellipse_precompute_patch4: 
   sbb dx, 01234h
   sub bh, al           ; D -= dx
   sbb si, dx
ellipse_precompute_patch5: 
   sub al, 012h         ; dx -= s^2
ellipse_precompute_patch6: 
   sbb dx, 01234h

   dec cl
   jnz ellipse_precompute_nosave2

   mov cl, 8
   mov BYTE PTR [di], ch
   inc sp
   inc di

ellipse_precompute_nosave2:

   cmp dx, bp           ; check if done verticalish 
   jae ellipse_precompute_jump

                        ; horizontalish part of ellipse
ellipse_precompute_donev:
                        ; write final bits, outer and inner loop values

   cmp cl, 8
   jne ellipse_precompute_nz1
   xor cl, cl
   dec sp
   dec di
ellipse_precompute_nz1:
   shr ch, cl
   mov BYTE PTR [di], ch
   
   sub cl, 8
   neg cl
   sub di, sp
   dec di
   mov BYTE PTR [di], cl
   dec di
   mov cx, sp
   mov BYTE PTR [di], cl
   add di, sp
   add di, 5

   xor sp, sp           ; set up inner/outer loop counters
   mov cl, 8

   xor ch, ch           ; set up direction bits and array pointer

   neg bh               ; D = -D
   adc si, 0
   neg si 

ellipse_precompute_h:

ellipse_precompute_patch7:
   sub al, 012h         ; dx -= s^2
ellipse_precompute_patch8:
   sbb dx, 01234h
   add bh, al           ; D += dx
   adc si, dx                     

   shr bp, 1            ; if dy/2 < D, increment y
   lahf
   cmp bp, si
   jge ellipse_precompute_skip_y4
   
   sahf
   rcl bp, 1

   sub bh, bl           ; D -= dy
   sbb si, bp
ellipse_precompute_patch9:
   add bl, 012h         ; dy += 2r^2
ellipse_precompute_patch10:
   adc bp, 01234h

   clc
   rcr ch, 1
   
   dec cl
   jnz ellipse_precompute_nosave3

   mov cl, 8
   mov BYTE PTR [di], ch
   inc sp
   inc di

ellipse_precompute_nosave3:

ellipse_precompute_patch11:
   sub al, 012h         ; dx -= s^2
ellipse_precompute_patch12:
   sbb dx, 01234h
   jge ellipse_precompute_h

ellipse_precompute_skip_y4:          

   sahf
   rcl bp, 1

   stc
   rcr ch, 1

   dec cl
   jnz ellipse_precompute_nosave4

   mov cl, 8
   mov BYTE PTR [di], ch
   inc sp
   inc di

ellipse_precompute_nosave4:

ellipse_precompute_patch13:
   sub al, 012h         ; dx -= s^2
ellipse_precompute_patch14:
   sbb dx, 01234h
   jge ellipse_precompute_h


   cmp cl, 8            ; write final bits, outer and inner loop values
   jne ellipse_precompute_nz2
   xor cl, cl
   dec sp
   dec di
ellipse_precompute_nz2:
   shr ch, cl
   mov BYTE PTR [di], ch
   
   sub cl, 8
   neg cl
   sub di, sp
   dec di
   mov BYTE PTR [di], cl
   dec di
   mov cx, sp
   mov BYTE PTR [di], cl


   mov WORD PTR sp, cs:[sp_save]
   mov WORD PTR ss, cs:[ss_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse_precompute ENDP

   END