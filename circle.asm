   DOSSEG
   .MODEL small
   .CODE

   jmp_addr   DW ?
   ydelta_xor DW ?
   sp_save    DW ?

   PUBLIC _cga_draw_circle1
_cga_draw_circle1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8191         ; also compute ydelta and ydelta_xor
   jnc circle1_y_even
   mov sp, -8113
circle1_y_even:
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 56 bytes
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax


   lea si, si + circle1_jump2 ; computed jump into loop
   mov cs:[jmp_addr], si


   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov WORD PTR cs:[circle1_patch4 + 1], ax
   mov WORD PTR cs:[circle1_patch9 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle1_patch2 + 1], ax
   mov WORD PTR cs:[circle1_patch12 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle1_patch1 + 1], ax
   mov WORD PTR cs:[circle1_patch11 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle1_patch3 + 1], ax
   mov WORD PTR cs:[circle1_patch10 + 1], ax


   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle1_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0ffb0h

   jmp cs:[jmp_addr]

circle1_radius_zero:

   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, [colour]
   mov ah, 0fch
   ror al, cl
   ror ah, cl
   and ah, [di]
   or al, ah
   stosb
   
   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret 
                        ; verticalish part of circle
   ALIGN 2
circle1_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0cfcfh
circle1_patch1:
   or ax, 03030h
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x1

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump2
   jmp circle1_donev2   ; done verticalish

circle1_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump2
   jmp circle1_donev2   ; done verticalish
   
   
   ALIGN 2
circle1_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 03f3fh
circle1_patch2:
   or ax, 0c0c0h
   mov [di+bx], ah
   stosb
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x4

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump1
   jmp circle1_donev1   ; done verticalish
   nop

circle1_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump1
   jmp circle1_donev1   ; done verticalish
   

   ALIGN 2
circle1_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0f3f3h
circle1_patch3:
   or ax, 0c0ch
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x2

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump3
   jmp circle1_donev3   ; done verticalish
   nop

circle1_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump3
   jmp circle1_donev3   ; done verticalish


      ALIGN 2
circle1_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0fcfch
circle1_patch4:
   or ax, 0303h
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_x3

   cmp dx, cx           ; check if done verticalish
   jae circle1_jump4
   jmp circle1_donev4   ; done verticalish

circle1_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_jump4
                        ; done verticalish

                        ; horizontalish part of circle
circle1_donev4:

   neg si               ; D = -D
   jmp circle1_h4   

circle1_donev1:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h1   

circle1_donev2:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h2   

circle1_donev3:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_h3   


circle1_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle1_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch
circle1_patch9:
   or ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y4
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh1


circle1_h3:
   and ax, 0f3f3h
circle1_patch10:
   or ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh1


circle1_h2:
   and ax, 0cfcfh
circle1_patch11:
   or ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh2


circle1_h1:
   and ax, 03f3fh
circle1_patch12:
   or ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle1_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle1_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_doneh2_skip ; skip extra byte

   jmp circle1_h4


circle1_doneh2:

   mov [di+bx], ah
   mov [di], al

circle1_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle1 ENDP

   PUBLIC _cga_draw_circle1_00
_cga_draw_circle1_00 PROC
   ARG x0:WORD, y0:WORD, r:WORD
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle1_00_y_even
   mov sp, -8112
circle1_00_y_even:
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle1_00_jump2 ; computed jump into loop
   add si, 3                     ; don't double first pixel
   mov cs:[jmp_addr], si


   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle1_00_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle1_00_radius_zero:

   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 0fch
   ror al, cl
   and [di], al
   
   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret    
                        ; verticalish part of circle
   ALIGN 2
circle1_00_jump2:
   and BYTE PTR [di+bx], 0cfh    ; draw pixel above axis
   and BYTE PTR [di], 0cfh       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_00_x1

   cmp dx, cx           ; check if done verticalish
   jae circle1_00_jump2
   jmp circle1_00_donev2   ; done verticalish

circle1_00_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_00_jump2
   jmp circle1_00_donev2   ; done verticalish
   
   
   ALIGN 2
circle1_00_jump1:
   and BYTE PTR [di+bx], 03fh    ; draw pixel above axis
   and BYTE PTR [di], 03fh       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_00_x4

   cmp dx, cx           ; check if done verticalish
   jae circle1_00_jump1
   jmp circle1_00_donev1   ; done verticalish

circle1_00_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_00_jump1
   jmp circle1_00_donev1   ; done verticalish
   

   ALIGN 2
circle1_00_jump3:
   and BYTE PTR [di+bx], 0f3h    ; draw pixel above axis
   and BYTE PTR [di], 0f3h       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_00_x2

   cmp dx, cx           ; check if done verticalish
   jae circle1_00_jump3
   jmp circle1_00_donev3   ; done verticalish

circle1_00_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_00_jump3
   jmp circle1_00_donev3   ; done verticalish


      ALIGN 2
circle1_00_jump4:
   and BYTE PTR [di+bx], 0fch    ; draw pixel above axis
   and BYTE PTR [di], 0fch       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_00_x3

   cmp dx, cx           ; check if done verticalish
   jae circle1_00_jump4
   jmp circle1_00_donev4   ; done verticalish

circle1_00_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_00_jump4
                        ; done verticalish

                        ; horizontalish part of circle
circle1_00_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle1_00_h4   

circle1_00_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_00_h1   

circle1_00_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_00_h2   

circle1_00_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_00_h3   


circle1_00_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle1_00_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_00_skip_y4
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_00_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_00_doneh1


circle1_00_h3:
   and ax, 0f3f3h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_00_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_00_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_00_doneh1


circle1_00_h2:
   and ax, 0cfcfh

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_00_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_00_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_00_doneh2


circle1_00_h1:
   and ax, 03f3fh

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle1_00_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle1_00_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_00_doneh2_skip ; skip extra byte

   jmp circle1_00_h4


circle1_00_doneh2:

   mov [di+bx], ah
   mov [di], al

circle1_00_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle1_00 ENDP

   PUBLIC _cga_draw_circle1_11
_cga_draw_circle1_11 PROC
   ARG x0:WORD, y0:WORD, r:WORD
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle1_11_y_even
   mov sp, -8112
circle1_11_y_even:
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle1_11_jump2 ; computed jump into loop
   add si, 3                     ; don't double first pixel
   mov cs:[jmp_addr], si


   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle1_11_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle1_11_radius_zero:

   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, 3
   ror al, cl
   or [di], al
   
   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
                        ; verticalish part of circle
   ALIGN 2
circle1_11_jump2:
   or BYTE PTR [di+bx], 030h     ; draw pixel above axis
   or BYTE PTR [di], 030h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_11_x1

   cmp dx, cx           ; check if done verticalish
   jae circle1_11_jump2
   jmp circle1_11_donev2   ; done verticalish

circle1_11_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_11_jump2
   jmp circle1_11_donev2   ; done verticalish
   
   
   ALIGN 2
circle1_11_jump1:
   or BYTE PTR [di+bx], 0c0h     ; draw pixel above axis
   or BYTE PTR [di], 0c0h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_11_x4

   cmp dx, cx           ; check if done verticalish
   jae circle1_11_jump1
   jmp circle1_11_donev1   ; done verticalish

circle1_11_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_11_jump1
   jmp circle1_11_donev1   ; done verticalish
   

   ALIGN 2
circle1_11_jump3:
   or BYTE PTR [di+bx], 0ch      ; draw pixel above axis
   or BYTE PTR [di], 0ch         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_11_x2

   cmp dx, cx           ; check if done verticalish
   jae circle1_11_jump3
   jmp circle1_11_donev3   ; done verticalish

circle1_11_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_11_jump3
   jmp circle1_11_donev3   ; done verticalish


      ALIGN 2
circle1_11_jump4:
   or BYTE PTR [di+bx], 03h    ; draw pixel above axis
   or BYTE PTR [di], 03h       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle1_11_x3

   cmp dx, cx           ; check if done verticalish
   jae circle1_11_jump4
   jmp circle1_11_donev4   ; done verticalish

circle1_11_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle1_11_jump4
                        ; done verticalish

                        ; horizontalish part of circle
circle1_11_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle1_11_h4   

circle1_11_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_11_h1   

circle1_11_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_11_h2   

circle1_11_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle1_11_h3   


circle1_11_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle1_11_h4:
   mov ah, [di+bx]
   mov al, [di]
   or ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_11_skip_y4
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_11_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_11_doneh1


circle1_11_h3:
   or ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_11_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_11_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_11_doneh1


circle1_11_h2:
   or ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle1_11_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle1_11_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_11_doneh2


circle1_11_h1:
   or ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle1_11_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle1_11_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle1_11_doneh2_skip ; skip extra byte

   jmp circle1_11_h4


circle1_11_doneh2:

   mov [di+bx], ah
   mov [di], al

circle1_11_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle1_11 ENDP

   PUBLIC _cga_draw_circle_xor1
_cga_draw_circle_xor1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle_xor1_y_even
   mov sp, -8112
circle_xor1_y_even:
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle_xor1_jump2 ; computed jump into loop
   add si, 3            ; adjust for double xor of first point
   mov cs:[jmp_addr], si

   mov al, [colour]
   mov ah, al
   mov BYTE PTR cs:[circle_xor1_patch7+2], al
   mov BYTE PTR cs:[circle_xor1_patch8+2], al
   mov WORD PTR cs:[circle_xor1_patch9+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor1_patch3+2], al
   mov BYTE PTR cs:[circle_xor1_patch4+2], al
   mov WORD PTR cs:[circle_xor1_patch12+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor1_patch1+2], al
   mov BYTE PTR cs:[circle_xor1_patch2+2], al
   mov WORD PTR cs:[circle_xor1_patch11+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor1_patch5+2], al
   mov BYTE PTR cs:[circle_xor1_patch6+2], al
   mov WORD PTR cs:[circle_xor1_patch10+1], ax

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle_xor1_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle_xor1_radius_zero:

   mov cx, [x0]
   and cl, 3
   inc cl
   shl cl, 1
   mov al, [colour]
   ror al, cl
   xor [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
                        ; verticalish part of circle
   ALIGN 2
circle_xor1_jump2:
circle_xor1_patch1:
   xor BYTE PTR [di+bx], 030h     ; draw pixel above axis
circle_xor1_patch2:
   xor BYTE PTR [di], 030h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_xor1_x1

   cmp dx, cx           ; check if done verticalish
   jae circle_xor1_jump2
   jmp circle_xor1_donev2   ; done verticalish

circle_xor1_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor1_jump2
   jmp circle_xor1_donev2   ; done verticalish
   
   
   ALIGN 2
circle_xor1_jump1:
circle_xor1_patch3:
   xor BYTE PTR [di+bx], 0c0h     ; draw pixel above axis
circle_xor1_patch4:
   xor BYTE PTR [di], 0c0h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_xor1_x4

   cmp dx, cx           ; check if done verticalish
   jae circle_xor1_jump1
   jmp circle_xor1_donev1   ; done verticalish

circle_xor1_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor1_jump1
   jmp circle_xor1_donev1   ; done verticalish
   

   ALIGN 2
circle_xor1_jump3:
circle_xor1_patch5:
   xor BYTE PTR [di+bx], 0ch      ; draw pixel above axis
circle_xor1_patch6:
   xor BYTE PTR [di], 0ch         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_xor1_x2

   cmp dx, cx           ; check if done verticalish
   jae circle_xor1_jump3
   jmp circle_xor1_donev3   ; done verticalish

circle_xor1_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor1_jump3
   jmp circle_xor1_donev3   ; done verticalish


      ALIGN 2
circle_xor1_jump4:
circle_xor1_patch7:
   xor BYTE PTR [di+bx], 03h    ; draw pixel above axis
circle_xor1_patch8:
   xor BYTE PTR [di], 03h       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_xor1_x3

   cmp dx, cx           ; check if done verticalish
   jae circle_xor1_jump4
   jmp circle_xor1_donev4   ; done verticalish

circle_xor1_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor1_jump4
                        ; done verticalish

                        ; horizontalish part of circle
circle_xor1_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_xor1_h4   

circle_xor1_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor1_h1   

circle_xor1_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor1_h2   

circle_xor1_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor1_h3   


circle_xor1_doneh1:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle_xor1_h4:
   mov ah, [di+bx]
   mov al, [di]
circle_xor1_patch9:
   xor ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor1_skip_y4
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor1_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_xor1_doneh1


circle_xor1_h3:
circle_xor1_patch10:
   xor ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor1_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor1_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_xor1_doneh1


circle_xor1_h2:
circle_xor1_patch11:
   xor ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor1_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor1_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_xor1_doneh2


circle_xor1_h1:
circle_xor1_patch12:
   xor ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle_xor1_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_xor1_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_xor1_doneh2_skip ; skip extra byte

   jmp circle_xor1_h4


circle_xor1_doneh2:

   mov [di+bx], ah
   mov [di], al

circle_xor1_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle_xor1 ENDP

   PUBLIC _cga_draw_circle_blank1
_cga_draw_circle_blank1 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the right side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle_blank1_y_even
   mov sp, -8112
circle_blank1_y_even:
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
   and ax, 3            ; deal with 2, 1, 3, 4 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 1         
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle_blank1_jump2 ; computed jump into loop
   add si, 3            ; adjust for double xor of first point
   mov cs:[jmp_addr], si

   mov al, [colour]     ; duplicate colour 4 times in byte
   mov ah, al
   shl ah, 1
   shl ah, 1
   add al, ah
   mov ah, al
   shl ah, 1
   shl ah, 1
   shl ah, 1
   shl ah, 1
   add al, ah

   mov BYTE PTR cs:[circle_blank1_patch1 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch2 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch3 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch4 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch5 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch6 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch7 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch8 + 2], al
   mov BYTE PTR cs:[circle_blank1_patch9 + 1], al
   mov BYTE PTR cs:[circle_blank1_patch10 + 1], al
   mov BYTE PTR cs:[circle_blank1_patch11 + 1], al
   mov BYTE PTR cs:[circle_blank1_patch12 + 1], al

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle_blank1_radius_zero
   mov cx, dx
   shl cx, 1
   shl cx, 1
   shl cx, 1
   add dx, cx
   shl cx, 1
   add dx, cx


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle_blank1_radius_zero:

   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
                        ; verticalish part of circle
   ALIGN 2
circle_blank1_jump2:
circle_blank1_patch1:
   mov BYTE PTR [di+bx], 0     ; draw pixel above axis
circle_blank1_patch2:
   mov BYTE PTR [di], 0        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_blank1_x1

   cmp dx, cx           ; check if done verticalish
   jae circle_blank1_jump2
   jmp circle_blank1_donev2   ; done verticalish

circle_blank1_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank1_jump2
   jmp circle_blank1_donev2   ; done verticalish
   
   
   ALIGN 2
circle_blank1_jump1:
circle_blank1_patch3:
   mov BYTE PTR [di+bx], 0     ; draw pixel above axis
circle_blank1_patch4:
   mov BYTE PTR [di], 0        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_blank1_x4

   cmp dx, cx           ; check if done verticalish
   jae circle_blank1_jump1
   jmp circle_blank1_donev1   ; done verticalish

circle_blank1_x1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank1_jump1
   jmp circle_blank1_donev1   ; done verticalish
   

   ALIGN 2
circle_blank1_jump3:
circle_blank1_patch5:
   mov BYTE PTR [di+bx], 0      ; draw pixel above axis
circle_blank1_patch6:
   mov BYTE PTR [di], 0         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_blank1_x2

   cmp dx, cx           ; check if done verticalish
   jae circle_blank1_jump3
   jmp circle_blank1_donev3   ; done verticalish

circle_blank1_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank1_jump3
   jmp circle_blank1_donev3   ; done verticalish


      ALIGN 2
circle_blank1_jump4:
circle_blank1_patch7:
   mov BYTE PTR [di+bx], 0    ; draw pixel above axis
circle_blank1_patch8:
   mov BYTE PTR [di], 0       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, decrement x
   shr ax, 1
   cmp ax, si
   jle circle_blank1_x3

   cmp dx, cx           ; check if done verticalish
   jae circle_blank1_jump4
   jmp circle_blank1_donev4   ; done verticalish

circle_blank1_x4:
   dec di               ; dec offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank1_jump4
                        ; done verticalish

                        ; horizontalish part of circle
circle_blank1_donev4:

circle_blank1_patch9:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank1_h4   

circle_blank1_donev1:

circle_blank1_patch10:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank1_h1   

circle_blank1_donev2:

circle_blank1_patch11:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank1_h2   

circle_blank1_donev3:

circle_blank1_patch12:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank1_h3   


circle_blank1_doneh1:

   mov [di+bx], al
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle_blank1_h4:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank1_skip_y4
   
   mov [di+bx], al
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank1_skip_y4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_blank1_doneh1


circle_blank1_h3:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank1_skip_y3
   
   mov [di+bx], al
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank1_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_blank1_doneh1


circle_blank1_h2:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank1_skip_y2
   
   mov [di+bx], al
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank1_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_blank1_doneh2


circle_blank1_h1:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], al
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle_blank1_skip_y1
   
   inc di
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank1_skip_y1:
   dec di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jl circle_blank1_doneh2_skip ; skip extra byte

   jmp circle_blank1_h4


circle_blank1_doneh2:

   mov [di+bx], al
   mov [di], al

circle_blank1_doneh2_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle_blank1 ENDP

   PUBLIC _cga_draw_circle2
_cga_draw_circle2 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the left side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8191         ; also compute ydelta and ydelta_xor
   jnc circle2_y_even
   mov sp, -8113
circle2_y_even:
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
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3          
   shl al, 1            ; multiply x mod 4 by 56 bytes
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax
   shl al, 1
   add si, ax


   lea si, si + circle2_jump3 ; computed jump into loop
   mov cs:[jmp_addr], si


   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov WORD PTR cs:[circle2_patch2 + 1], ax
   mov WORD PTR cs:[circle2_patch9 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle2_patch4 + 1], ax
   mov WORD PTR cs:[circle2_patch12 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle2_patch3 + 1], ax
   mov WORD PTR cs:[circle2_patch11 + 1], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov WORD PTR cs:[circle2_patch1 + 1], ax
   mov WORD PTR cs:[circle2_patch10 + 1], ax
   

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle2_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0ffb0h

   jmp cs:[jmp_addr]

circle2_radius_zero:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret

                        ; verticalish part of circle
   ALIGN 2
circle2_jump3:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0f3f3h
circle2_patch1:
   or ax, 0c0ch
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_x4

   cmp dx, cx           ; check if done verticalish
   jae circle2_jump3
   jmp circle2_donev3   ; done verticalish

circle2_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_jump3
   jmp circle2_donev3   ; done verticalish


      ALIGN 2
circle2_jump4:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0fcfch
circle2_patch2:
   or ax, 0303h
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_x1

   cmp dx, cx           ; check if done verticalish
   jae circle2_jump4
   jmp circle2_donev4   ; done verticalish
   nop

circle2_x4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_jump4
   jmp circle2_donev4   ; done verticalish


   ALIGN 2
circle2_jump2:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 0cfcfh
circle2_patch3:
   or ax, 03030h
   mov [di+bx], ah
   stosb
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_x3

   cmp dx, cx           ; check if done verticalish
   jae circle2_jump2
   jmp circle2_donev2   ; done verticalish

circle2_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_jump2
   jmp circle2_donev2   ; done verticalish
   
   
   ALIGN 2
circle2_jump1:
   mov ah, [di+bx]      ; draw pixel above axis
   mov al, [di]         ; draw pixel below axis
   and ax, 03f3fh
circle2_patch4:
   or ax, 0c0c0h
   mov [di+bx], ah
   stosb

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_x2

   cmp dx, cx           ; check if done verticalish
   jae circle2_jump1
   jmp circle2_donev1   ; done verticalish
   nop
   
circle2_x1:
   inc di               ; inc offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_jump1

                        ; horizontalish part of circle
circle2_donev1:

   neg si               ; D = -D
   jmp circle2_h1   

circle2_donev2:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_h2   

circle2_donev3:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_h3   

circle2_donev4:

   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_h4   


circle2_doneh2:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle2_h1:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 03f3fh
circle2_patch12:
   or ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle2_skip_y1

   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_skip_y1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_doneh2 ; don't double last pixel


circle2_h2:
   and ax, 0cfcfh
circle2_patch11:
   or ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_doneh2 ; don't double last pixel
   
   
circle2_h3:
   and ax, 0f3f3h
circle2_patch10:
   or ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_doneh1 ; don't double last pixel


circle2_h4:
   and ax, 0fcfch
circle2_patch9:
   or ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_skip_y4
   
   inc di

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle2_skip_y4:
   inc di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_doneh1_skip ; skip extra byte and doubled pixel

   jmp circle2_h1

circle2_doneh1:

   mov [di+bx], ah
   mov [di], al

circle2_doneh1_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle2 ENDP

   PUBLIC _cga_draw_circle2_00
_cga_draw_circle2_00 PROC
   ARG x0:WORD, y0:WORD, r:WORD
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the left side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle2_00_y_even
   mov sp, -8112
circle2_00_y_even:
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
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3          
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle2_00_jump3 ; computed jump into loop
   add si, 3                     ; don't double first pixel
   mov cs:[jmp_addr], si
   

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle2_00_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle2_00_radius_zero:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret

                        ; verticalish part of circle
   ALIGN 2
circle2_00_jump3:
   and BYTE PTR [di+bx], 0f3h    ; draw pixel above axis
   and BYTE PTR [di], 0f3h       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_00_x4

   cmp dx, cx           ; check if done verticalish
   jae circle2_00_jump3
   jmp circle2_00_donev3   ; done verticalish

circle2_00_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_00_jump3
   jmp circle2_00_donev3   ; done verticalish


      ALIGN 2
circle2_00_jump4:
   and BYTE PTR [di+bx], 0fch    ; draw pixel above axis
   and BYTE PTR [di], 0fch       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_00_x1

   cmp dx, cx           ; check if done verticalish
   jae circle2_00_jump4
   jmp circle2_00_donev4   ; done verticalish

circle2_00_x4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_00_jump4
   jmp circle2_00_donev4   ; done verticalish


   ALIGN 2
circle2_00_jump2:
   and BYTE PTR [di+bx], 0cfh    ; draw pixel above axis
   and BYTE PTR [di], 0cfh       ; draw pixel below axis
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_00_x3

   cmp dx, cx           ; check if done verticalish
   jae circle2_00_jump2
   jmp circle2_00_donev2   ; done verticalish

circle2_00_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_00_jump2
   jmp circle2_00_donev2   ; done verticalish
   
   
   ALIGN 2
circle2_00_jump1:
   and BYTE PTR [di+bx], 03fh    ; draw pixel above axis
   and BYTE PTR [di], 03fh       ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_00_x2

   cmp dx, cx           ; check if done verticalish
   jae circle2_00_jump1
   jmp circle2_00_donev1   ; done verticalish
   
circle2_00_x1:
   inc di               ; inc offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_00_jump1

                        ; horizontalish part of circle
circle2_00_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle2_00_h1   

circle2_00_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_00_h2   

circle2_00_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_00_h3   

circle2_00_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_00_h4   


circle2_00_doneh2:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle2_00_h1:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 03f3fh

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle2_00_skip_y1

   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_00_skip_y1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_00_doneh2 ; don't double last pixel


circle2_00_h2:
   and ax, 0cfcfh

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_00_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_00_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_00_doneh2 ; don't double last pixel
   
   
circle2_00_h3:
   and ax, 0f3f3h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_00_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_00_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_00_doneh1 ; don't double last pixel


circle2_00_h4:
   and ax, 0fcfch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_00_skip_y4
   
   inc di

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle2_00_skip_y4:
   inc di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_00_doneh1_skip ; skip extra byte and doubled pixel

   jmp circle2_00_h1

circle2_00_doneh1:

   mov [di+bx], ah
   mov [di], al

circle2_00_doneh1_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle2_00 ENDP

   PUBLIC _cga_draw_circle2_11
_cga_draw_circle2_11 PROC
   ARG x0:WORD, y0:WORD, r:WORD
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the left side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle2_11_y_even
   mov sp, -8112
circle2_11_y_even:
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
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3          
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle2_11_jump3 ; computed jump into loop
   add si, 3                     ; don't double first pixel
   mov cs:[jmp_addr], si
   

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle2_11_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle2_11_radius_zero:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret

                        ; verticalish part of circle
   ALIGN 2
circle2_11_jump3:
   or BYTE PTR [di+bx], 0ch     ; draw pixel above axis
   or BYTE PTR [di], 0ch        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_11_x4

   cmp dx, cx           ; check if done verticalish
   jae circle2_11_jump3
   jmp circle2_11_donev3   ; done verticalish

circle2_11_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_11_jump3
   jmp circle2_11_donev3   ; done verticalish


      ALIGN 2
circle2_11_jump4:
   or BYTE PTR [di+bx], 03h      ; draw pixel above axis
   or BYTE PTR [di], 03h         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_11_x1

   cmp dx, cx           ; check if done verticalish
   jae circle2_11_jump4
   jmp circle2_11_donev4   ; done verticalish
  
circle2_11_x4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_11_jump4
   jmp circle2_11_donev4   ; done verticalish


   ALIGN 2
circle2_11_jump2:
   or BYTE PTR [di+bx], 030h     ; draw pixel above axis
   or BYTE PTR [di], 030h        ; draw pixel below axis
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_11_x3

   cmp dx, cx           ; check if done verticalish
   jae circle2_11_jump2
   jmp circle2_11_donev2   ; done verticalish

circle2_11_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_11_jump2
   jmp circle2_11_donev2   ; done verticalish

   
   ALIGN 2
circle2_11_jump1:
   or BYTE PTR [di+bx], 0c0h     ; draw pixel above axis
   or BYTE PTR [di], 0c0h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle2_11_x2

   cmp dx, cx           ; check if done verticalish
   jae circle2_11_jump1
   jmp circle2_11_donev1   ; done verticalish
   
circle2_11_x1:
   inc di               ; inc offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle2_11_jump1

                        ; horizontalish part of circle
circle2_11_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle2_11_h1   

circle2_11_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_11_h2   

circle2_11_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_11_h3   

circle2_11_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle2_11_h4   


circle2_11_doneh2:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle2_11_h1:
   mov ah, [di+bx]
   mov al, [di]
   or ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle2_11_skip_y1

   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_11_skip_y1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_11_doneh2 ; don't double last pixel


circle2_11_h2:
   or ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_11_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_11_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_11_doneh2 ; don't double last pixel
   
   
circle2_11_h3:
   or ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_11_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle2_11_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_11_doneh1 ; don't double last pixel


circle2_11_h4:
   or ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle2_11_skip_y4
   
   inc di

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle2_11_skip_y4:
   inc di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle2_11_doneh1_skip ; skip extra byte and doubled pixel

   jmp circle2_11_h1

circle2_11_doneh1:

   mov [di+bx], ah
   mov [di], al

circle2_11_doneh1_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle2_11 ENDP

   PUBLIC _cga_draw_circle_xor2
_cga_draw_circle_xor2 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the left side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle_xor2_y_even
   mov sp, -8112
circle_xor2_y_even:
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
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3          
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle_xor2_jump3 ; computed jump into loop
   add si, 3            ; compensate for double xor of first point
   mov cs:[jmp_addr], si

   mov al, [colour]
   mov ah, al
   mov BYTE PTR cs:[circle_xor2_patch3+2], al
   mov BYTE PTR cs:[circle_xor2_patch4+2], al
   mov WORD PTR cs:[circle_xor2_patch12+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor2_patch7+2], al
   mov BYTE PTR cs:[circle_xor2_patch8+2], al
   mov WORD PTR cs:[circle_xor2_patch9+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor2_patch5+2], al
   mov BYTE PTR cs:[circle_xor2_patch6+2], al
   mov WORD PTR cs:[circle_xor2_patch10+1], ax
   ror al, 1
   ror al, 1
   mov ah, al
   mov BYTE PTR cs:[circle_xor2_patch1+2], al
   mov BYTE PTR cs:[circle_xor2_patch2+2], al
   mov WORD PTR cs:[circle_xor2_patch11+1], ax
   

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle_xor2_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax


   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle_xor2_radius_zero:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   

                        ; verticalish part of circle
   ALIGN 2
circle_xor2_jump3:
circle_xor2_patch1:
   xor BYTE PTR [di+bx], 0ch     ; draw pixel above axis
circle_xor2_patch2:
   xor BYTE PTR [di], 0ch        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_xor2_x4

   cmp dx, cx           ; check if done verticalish
   jae circle_xor2_jump3
   jmp circle_xor2_donev3   ; done verticalish

circle_xor2_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor2_jump3
   jmp circle_xor2_donev3   ; done verticalish


      ALIGN 2
circle_xor2_jump4:
circle_xor2_patch3:
   xor BYTE PTR [di+bx], 03h      ; draw pixel above axis
circle_xor2_patch4:
   xor BYTE PTR [di], 03h         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_xor2_x1

   cmp dx, cx           ; check if done verticalish
   jae circle_xor2_jump4
   jmp circle_xor2_donev4   ; done verticalish
  
circle_xor2_x4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor2_jump4
   jmp circle_xor2_donev4   ; done verticalish


   ALIGN 2
circle_xor2_jump2:
circle_xor2_patch5:
   xor BYTE PTR [di+bx], 030h     ; draw pixel above axis
circle_xor2_patch6:
   xor BYTE PTR [di], 030h        ; draw pixel below axis
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_xor2_x3

   cmp dx, cx           ; check if done verticalish
   jae circle_xor2_jump2
   jmp circle_xor2_donev2   ; done verticalish

circle_xor2_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor2_jump2
   jmp circle_xor2_donev2   ; done verticalish

   
   ALIGN 2
circle_xor2_jump1:
circle_xor2_patch7:
   xor BYTE PTR [di+bx], 0c0h     ; draw pixel above axis
circle_xor2_patch8:
   xor BYTE PTR [di], 0c0h        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_xor2_x2

   cmp dx, cx           ; check if done verticalish
   jae circle_xor2_jump1
   jmp circle_xor2_donev1   ; done verticalish
   
circle_xor2_x1:
   inc di               ; inc offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_xor2_jump1

                        ; horizontalish part of circle
circle_xor2_donev1:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_xor2_h1   

circle_xor2_donev2:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor2_h2   

circle_xor2_donev3:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor2_h3   

circle_xor2_donev4:

   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   mov ah, [di+bx]
   mov al, [di]
   jmp circle_xor2_h4   


circle_xor2_doneh2:

   mov [di+bx], ah
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle_xor2_h1:
   mov ah, [di+bx]
   mov al, [di]
circle_xor2_patch9:
   xor ax, 0c0c0h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle_xor2_skip_y1

   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor2_skip_y1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_xor2_doneh2  ; don't double last pixel


circle_xor2_h2:
circle_xor2_patch10:
   xor ax, 03030h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor2_skip_y2
   
   mov [di+bx], ah
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor2_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_xor2_doneh2 ; don't double last pixel
   
   
circle_xor2_h3:
circle_xor2_patch11:
   xor ax, 0c0ch

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor2_skip_y3
   
   mov [di+bx], ah
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
circle_xor2_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_xor2_doneh1 ; don't double last pixel


circle_xor2_h4:
circle_xor2_patch12:
   xor ax, 0303h

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], ah
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_xor2_skip_y4
   
   inc di

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_xor2_skip_y4:
   inc di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_xor2_doneh1_skip ; skip extra bytes and doubled pixel

   jmp circle_xor2_h1

circle_xor2_doneh1:

   mov [di+bx], ah
   mov [di], al

circle_xor2_doneh1_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle_xor2 ENDP

        PUBLIC _cga_draw_circle_blank2
_cga_draw_circle_blank2 PROC
   ARG x0:WORD, y0:WORD, r:WORD, colour:BYTE
   ; circle with centre (x0, y0) and radius in the x-direction of r
   ; draws only the left side of the circle
   ; pixel aspect ratio is 1.2 i.e. r' = 6, s' = 5
   ; di, di+bx offsets of points above and below axis, ah:accum
   ; cx: deltay, dx:deltax, sp:yinc, bp:yinc_xor
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set ES to segment for CGA memory
   mov es, ax
   mov ds, ax           ; reflect in DS

   cli                  ; save and free up sp
   mov WORD PTR cs:[sp_save], sp

   mov ax, [y0]         ; compute offset for line y0
   xor di, di           
   shr ax, 1
   mov sp, 8192         ; also compute ydelta and ydelta_xor
   jnc circle_blank2_y_even
   mov sp, -8112
circle_blank2_y_even:
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
   and ax, 3            ; deal with 3, 4, 2, 1 layout
   mov dl, al  
   shr dl, 1
   xor al, dl
   xor al, 3          
   shl al, 1            ; multiply x mod 4 by 48 bytes
   shl al, 1
   shl al, 1
   shl al, 1
   mov si, ax
   shl al, 1
   add si, ax


   lea si, si + circle_blank2_jump3 ; computed jump into loop
   add si, 3            ; compensate for double xor of first point
   mov cs:[jmp_addr], si  

   mov dx, [r]          ; deltax = 2c*r = 2*s'^2*r = 50*r
   shl dx, 1
   jz circle_blank2_radius_zero
   mov ax, dx
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add dx, ax
   shl ax, 1
   add dx, ax

   mov al, [colour]     ; duplicate colour 4 times in byte
   mov ah, al
   shl ah, 1
   shl ah, 1
   add al, ah
   mov ah, al
   shl ah, 1
   shl ah, 1
   shl ah, 1
   shl ah, 1
   add al, ah

   mov BYTE PTR cs:[circle_blank2_patch1 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch2 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch3 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch4 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch5 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch6 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch7 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch8 + 2], al
   mov BYTE PTR cs:[circle_blank2_patch9 + 1], al
   mov BYTE PTR cs:[circle_blank2_patch10 + 1], al
   mov BYTE PTR cs:[circle_blank2_patch11 + 1], al
   mov BYTE PTR cs:[circle_blank2_patch12 + 1], al

   mov cx, 36           ; deltay = r'^2 = 36
   xor si, si           ; D = 0
   xor bx, bx           ; distance between lines above and below axis


   mov bp, 0c050h

   jmp cs:[jmp_addr]

circle_blank2_radius_zero:

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   

                        ; verticalish part of circle
   ALIGN 2
circle_blank2_jump3:
circle_blank2_patch1:
   mov BYTE PTR [di+bx], 0     ; draw pixel above axiscircle_blank2_patch2:
circle_blank2_patch2:
   mov BYTE PTR [di], 0        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_blank2_x4

   cmp dx, cx           ; check if done verticalish
   jae circle_blank2_jump3
   jmp circle_blank2_donev3   ; done verticalish

circle_blank2_x3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank2_jump3
   jmp circle_blank2_donev3   ; done verticalish


      ALIGN 2
circle_blank2_jump4:
circle_blank2_patch3:
   mov BYTE PTR [di+bx], 0      ; draw pixel above axis
circle_blank2_patch4:
   mov BYTE PTR [di], 0         ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_blank2_x1

   cmp dx, cx           ; check if done verticalish
   jae circle_blank2_jump4
   jmp circle_blank2_donev4   ; done verticalish
  
circle_blank2_x4:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank2_jump4
   jmp circle_blank2_donev4   ; done verticalish


   ALIGN 2
circle_blank2_jump2:
circle_blank2_patch5:
   mov BYTE PTR [di+bx], 0     ; draw pixel above axis
circle_blank2_patch6:
   mov BYTE PTR [di], 0        ; draw pixel below axis
   
   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_blank2_x3

   cmp dx, cx           ; check if done verticalish
   jae circle_blank2_jump2
   jmp circle_blank2_donev2   ; done verticalish

circle_blank2_x2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank2_jump2
   jmp circle_blank2_donev2   ; done verticalish

   
   ALIGN 2
circle_blank2_jump1:
circle_blank2_patch7:
   mov BYTE PTR [di+bx], 0     ; draw pixel above axis
circle_blank2_patch8:
   mov BYTE PTR [di], 0        ; draw pixel below axis

   add di, sp           ; update offset
   xor sp, bp           ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

   add si, cx           ; D += dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   mov ax, dx           ; if dx/2 <= D, increment x
   shr ax, 1
   cmp ax, si
   jle circle_blank2_x2

   cmp dx, cx           ; check if done verticalish
   jae circle_blank2_jump1
   jmp circle_blank2_donev1   ; done verticalish
   
circle_blank2_x1:
   inc di               ; inc offset byte
   sub dx, 25           ; dx -= s'^2 (= 25)
   sub si, dx           ; D -= dx
   sub dx, 25           ; dx -= s'^2 (= 25)

   cmp dx, cx           ; check if done verticalish 
   jae circle_blank2_jump1

                        ; horizontalish part of circle
circle_blank2_donev1:

circle_blank2_patch9:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank2_h1   

circle_blank2_donev2:

circle_blank2_patch10:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank2_h2   

circle_blank2_donev3:

circle_blank2_patch11:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank2_h3   

circle_blank2_donev4:

circle_blank2_patch12:
   mov al, 0
   dec sp
   mov bp, 0ffb0h
   neg si               ; D = -D
   jmp circle_blank2_h4   


circle_blank2_doneh2:

   mov [di+bx], al
   mov [di], al

   mov WORD PTR sp, cs:[sp_save]
   sti

   pop ds
   pop si
   pop di
   pop bp
   ret   


circle_blank2_h1:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si

   jge circle_blank2_skip_y1

   mov [di+bx], al
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank2_skip_y1:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_blank2_doneh2  ; don't double last pixel


circle_blank2_h2:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank2_skip_y2
   
   mov [di+bx], al
   stosb
   
   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank2_skip_y2:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_blank2_doneh2 ; don't double last pixel
   
   
circle_blank2_h3:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank2_skip_y3
   
   mov [di+bx], al
   stosb

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank2_skip_y3:
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_blank2_doneh1 ; don't double last pixel


circle_blank2_h4:

   sub dx, 25           ; dx -= s'^2 (= 25)
   add si, dx           ; D += dx

   mov [di+bx], al
   stosb
   dec di

   mov bp, cx           ; if dy/2 < D, increment y
   shr bp, 1
   cmp bp, si
   jge circle_blank2_skip_y4
   
   inc di

   sub si, cx           ; D -= dy
   add cx, 72           ; dy += 2r'^2 (= 72)

   add di, sp           ; update offset
   xor sp, 0ffb0h       ; update offset update for odd<->even
   sub bx, 80           ; decrement/increment y lines 

circle_blank2_skip_y4:
   inc di
   sub dx, 25           ; dx -= s'^2 (= 25)
   jle circle_blank2_doneh1_skip ; skip extra bytes and doubled pixel

   jmp circle_blank2_h1

circle_blank2_doneh1:

   mov [di+bx], al
   mov [di], al

circle_blank2_doneh1_skip:

   mov WORD PTR sp, cs:[sp_save]
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_circle_blank2 ENDP

   END