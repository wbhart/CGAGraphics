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
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; dx:deltax (hi16), sp:yinc, bp:deltay (hi16),
   ; al: deltax (lo8), ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   cli                  ; save and free up sp and ss
   mov WORD PTR cs:[sp_save], sp
   mov ax, ss
   mov WORD PTR cs:[ss_save], ax

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta
   jnc ellipse1_y_even
   mov sp, -8112
ellipse1_y_even:
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
   mov WORD PTR cs:[ellipse1_patch37 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch32 + 2], al
   mov BYTE PTR cs:[ellipse1_patch33 + 2], al
   mov WORD PTR cs:[ellipse1_patch58 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch1 + 2], al
   mov BYTE PTR cs:[ellipse1_patch2 + 2], al
   mov WORD PTR cs:[ellipse1_patch51 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov BYTE PTR cs:[ellipse1_patch10 + 2], al
   mov BYTE PTR cs:[ellipse1_patch11 + 2], al
   mov WORD PTR cs:[ellipse1_patch44 + 1], ax


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

   mov WORD PTR cs:[ellipse1_patch39 + 2], bx
   mov WORD PTR cs:[ellipse1_patch43 + 2], bx
   mov WORD PTR cs:[ellipse1_patch46 + 2], bx
   mov WORD PTR cs:[ellipse1_patch50 + 2], bx
   mov WORD PTR cs:[ellipse1_patch53 + 2], bx
   mov WORD PTR cs:[ellipse1_patch57 + 2], bx
   mov WORD PTR cs:[ellipse1_patch60 + 2], bx
   mov WORD PTR cs:[ellipse1_patch64 + 2], bx

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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse1_h4   

ellipse1_donev1:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h1   

ellipse1_donev2:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h2   

ellipse1_donev3:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h3   


ellipse1_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   mov WORD PTR ss, cs:[ss_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret   

   ; di, di+bx offsets of points above and below axis, ax: pixels
   ; dl: deltax (lo8), sp: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; es: dy (hi16) temp, ss: yinc

ellipse1_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch
ellipse1_patch37:
   or ax, 0303h

ellipse1_patch38:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch39:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y4
   
   mov [di+bx], ah
   mov [di], al

   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse1_patch40:
   add cl, 012h         ; dy += 2r^2
ellipse1_patch41:
   adc bp, 01234h
   
   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse1_skip_y4:          

ellipse1_patch42:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch43:
   sbb sp, 01234h
ellipse1_doneh1_check:
   jl ellipse1_doneh1


ellipse1_h3:
   and ax, 0f3f3h
ellipse1_patch44:
   or ax, 0c0ch

ellipse1_patch45:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch46:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y3
   
   mov [di+bx], ah
   mov [di], al

   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse1_patch47:
   add cl, 012h         ; dy += 2r^2
ellipse1_patch48:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse1_skip_y3:
 
ellipse1_patch49:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch50:
   sbb sp, 01234h
   jl ellipse1_doneh1_check


ellipse1_h2:
   and ax, 0cfcfh
ellipse1_patch51:
   or ax, 03030h

ellipse1_patch52:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch53:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y2
   
   mov [di+bx], ah
   mov [di], al
   
   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse1_patch54:
   add cl, 012h         ; dy += 2r^2
ellipse1_patch55:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse1_skip_y2:
 
ellipse1_patch56:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch57:
   sbb sp, 01234h
   jl ellipse1_doneh2


ellipse1_h1:
   and ax, 03f3fh
ellipse1_patch58:
   or ax, 0c0c0h

ellipse1_patch59:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch60:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp

   mov [di+bx], ah
   mov [di], al

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse1_skip_y1
   
   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse1_patch61:
   add cl, 012h         ; dy += 2r^2
ellipse1_patch62:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines

   mov es, bp
ellipse1_skip_y1:
   dec di
 
ellipse1_patch63:
   sub dl, 012h         ; dx -= s^2
ellipse1_patch64:
   sbb sp, 01234h
   jl ellipse1_doneh2_skip ; skip extra byte

   jmp ellipse1_h4


ellipse1_doneh2:

   mov [di+bx], ah
   mov [di], al

ellipse1_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   mov WORD PTR ss, cs:[ss_save]
   sti

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
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; dx:deltax (hi16), sp:yinc, bp:deltay (hi16),
   ; al: deltax (lo8), ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set DS to segment for CGA memory
   mov ds, ax

   cli                  ; save and free up sp and ss
   mov WORD PTR cs:[sp_save], sp
   mov ax, ss
   mov WORD PTR cs:[ss_save], ax

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta
   jnc ellipse2_y_even
   mov sp, -8112
ellipse2_y_even:
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
   mov WORD PTR cs:[ellipse2_patch58 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse2_patch23 + 2], al
   mov BYTE PTR cs:[ellipse2_patch24 + 2], al
   mov WORD PTR cs:[ellipse2_patch37 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse2_patch10 + 2], al
   mov BYTE PTR cs:[ellipse2_patch11 + 2], al
   mov WORD PTR cs:[ellipse2_patch44 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov BYTE PTR cs:[ellipse2_patch1 + 2], al
   mov BYTE PTR cs:[ellipse2_patch2 + 2], al
   mov WORD PTR cs:[ellipse2_patch51 + 1], ax


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

   mov WORD PTR cs:[ellipse2_patch39 + 2], bx
   mov WORD PTR cs:[ellipse2_patch43 + 2], bx
   mov WORD PTR cs:[ellipse2_patch46 + 2], bx
   mov WORD PTR cs:[ellipse2_patch50 + 2], bx
   mov WORD PTR cs:[ellipse2_patch53 + 2], bx
   mov WORD PTR cs:[ellipse2_patch57 + 2], bx
   mov WORD PTR cs:[ellipse2_patch60 + 2], bx
   mov WORD PTR cs:[ellipse2_patch64 + 2], bx

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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   add di, sp           ; update offset
   xor sp, 0c050h       ; update offset update for odd<->even
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

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse2_h1   

ellipse2_donev4:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h4 

ellipse2_donev3:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h3   

ellipse2_donev2:

   mov ss, sp
   mov es, bp
   mov sp, dx
   mov dl, al
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h2   


ellipse2_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   mov WORD PTR ss, cs:[ss_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret   

   ; di, di+bx offsets of points above and below axis, ax: pixels
   ; dl: deltax (lo8), sp: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; es: dy (hi16) temp, ss: yinc

ellipse2_h1:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 03f3fh
ellipse2_patch37:
   or ax, 0c0c0h

ellipse2_patch38:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch39:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y1
   
   mov [di+bx], ah
   mov [di], al

   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse2_patch40:
   add cl, 012h         ; dy += 2r^2
ellipse2_patch41:
   adc bp, 01234h
   
   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse2_skip_y1:          

ellipse2_patch42:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch43:
   sbb sp, 01234h
ellipse2_doneh1_check:
   jl ellipse2_doneh1


ellipse2_h2:
   and ax, 0cfcfh
ellipse2_patch44:
   or ax, 0303h

ellipse2_patch45:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch46:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp                     

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y2
   
   mov [di+bx], ah
   mov [di], al

   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse2_patch47:
   add cl, 012h         ; dy += 2r^2
ellipse2_patch48:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse2_skip_y2:
 
ellipse2_patch49:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch50:
   sbb sp, 01234h
   jl ellipse2_doneh1_check


ellipse2_h3:
   and ax, 0f3f3h
ellipse2_patch51:
   or ax, 0c0ch

ellipse2_patch52:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch53:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y3
   
   mov [di+bx], ah
   mov [di], al
   
   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse2_patch54:
   add cl, 012h         ; dy += 2r^2
ellipse2_patch55:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]
   mov es, bp
ellipse2_skip_y3:
 
ellipse2_patch56:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch57:
   sbb sp, 01234h
   jl ellipse2_doneh2


ellipse2_h4:
   and ax, 0fcfch
ellipse2_patch58:
   or ax, 0303h

ellipse2_patch59:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch60:
   sbb sp, 01234h
   add ch, dl           ; D += dx
   adc si, sp

   mov [di+bx], ah
   mov [di], al

   mov bp, es
   shr bp, 1            ; if dy/2 < D, increment y
   cmp bp, si
   jge ellipse2_skip_y4
   
   mov bp, es
   sub ch, cl           ; D -= dy
   sbb si, bp
ellipse2_patch61:
   add cl, 012h         ; dy += 2r^2
ellipse2_patch62:
   adc bp, 01234h

   mov ax, ss           ; update offset
   add di, ax
   xor ax, 0c050h       ; update offset update for odd<->even
   mov ss, ax
   sub bx, 80           ; decrement/increment y lines

   mov es, bp
ellipse2_skip_y4:
   inc di
 
ellipse2_patch63:
   sub dl, 012h         ; dx -= s^2
ellipse2_patch64:
   sbb sp, 01234h
   jle ellipse2_doneh2_skip ; skip extra byte and doubled pixel

   jmp ellipse2_h1


ellipse2_doneh2:

   mov [di+bx], ah
   mov [di], al

ellipse2_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   mov WORD PTR ss, cs:[ss_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse2 ENDP

   _ellipse_data DB 7, 5, 0, 8, 34, 74, 85, 237, 190, 10, 6, 8, 16, 41, 85, 173, 109, 119, 223, 223, 255

   PUBLIC _cga_draw_ellipse_precomp1
_cga_draw_ellipse_precomp1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
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

   xor bx, bx           ; distance between lines above and below axis
   xor ch, ch           ; loop uses cx, not cl

   lea bp, _ellipse_data

   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp 

   jmp cs:[jmp_addr] 
                        ; part of horizontalish part moved to shorten jump
ellipse_precomp1_donev3:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp1_donev3  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp1_donev4  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp1_donev2  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp1_donev1  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
   inc bp
   jmp ellipse_precomp1_jump1

                        ; horizontalish part of ellipse
   
ellipse_precomp1_donev4:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp
   jmp ellipse_precomp1_h4   

ellipse_precomp1_donev2:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp1_h2   

ellipse_precomp1_donev1:

   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp1_doneh1  ; done horizontalish
   jmp ellipse_precomp1_h3

ellipse_precomp1_byte3:
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp1_doneh1  ; done horizontalish
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
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp1_doneh2  ; done horizontalish
   jmp ellipse_precomp1_h1

ellipse_precomp1_byte1:
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp1_doneh2_skip  ; done horizontalish
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
   ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
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

   xor bx, bx           ; distance between lines above and below axis
   xor ch, ch           ; loop uses cx, not cl

   lea bp, _ellipse_data

   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp 

   jmp cs:[jmp_addr] 
                        ; part of horizontalish part moved to shorten jump
ellipse_precomp2_donev3:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp2_donev3  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp2_donev4  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp2_donev2  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   dec dh                      ; check if done verticalish
   jz ellipse_precomp2_donev1  ; done verticalish
   mov dl, BYTE PTR cs:[bp]
   inc bp
   jmp ellipse_precomp2_jump1

                        ; horizontalish part of ellipse
   
ellipse_precomp2_donev4:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp2_h4   

ellipse_precomp2_donev2:
   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
   inc bp
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse_precomp2_h2   

ellipse_precomp2_donev1:

   mov dh, BYTE PTR cs:[bp]
   inc bp
   mov cl, BYTE PTR cs:[bp]
   inc bp
   mov dl, BYTE PTR cs:[bp]
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
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp2_doneh1  ; done horizontalish
   jmp ellipse_precomp2_h1

ellipse_precomp2_byte2:
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp2_doneh1  ; done horizontalish
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
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp2_doneh2  ; done horizontalish
   jmp ellipse_precomp2_h4
   

ellipse_precomp2_byte4:
   mov cl, 8
   mov dl, BYTE PTR cs:[bp]
   inc bp
   dec dh                      ; check if done horizontalish
   jz ellipse_precomp2_doneh2_skip  ; done horizontalish
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

   END