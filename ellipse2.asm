   DOSSEG
   .MODEL small

   EXTRN _cga_draw_hline:NEAR, _cga_draw_vline:NEAR

   .DATA

   ncorr DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 255, 0, 0, 0, 0, 0, 0, 0, 0
         DB 255, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 255, 0, 0, 0
         DB 0, 0, 0, 255, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 255, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
         DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

   cmp1 DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 93, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 53, 0, 59, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 29, 0, 0

   cmp2 DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 39, 0, 0, 33, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 3, 96, 0, 0, 0, 0
        DB 0, 0, 29, 0, 0, 0, 0, 0, 39, 0
        DB 0, 57, 0, 0, 33, 0, 0, 0, 0, 0
        DB 0, 0, 63, 36, 0, 12, 0, 100, 0, 0
        DB 0, 0, 0, 17, 0, 0, 0, 0, 0, 0
        DB 0, 18, 0, 0, 0, 0, 0, 0, 0, 0
        DB 31, 0, 38, 0, 0, 52, 0, 0, 0, 0
        DB 0, 84, 83, 0, 0, 0, 10, 0, 3, 0
        DB 96, 0, 0, 0, 0, 0, 31, 0, 43, 0
        
   .CODE

   jmp_addr1   DW ?
   jmp_addr2   DW ?
   sp_save     DW ?
   ss_save     DW ?

   PUBLIC _cga_draw_ellipse
_cga_draw_ellipse PROC
   ARG buff:DWORD, x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
   ; ellipse with centre (x0, y0) and semiradius in the x-direction of r
   ; and semiradius in the y-direction of s
   ; draws only the right side of the ellipse
   ; di, di+bx offsets of points above and below axis, ah:pixels
   ; dx:deltax (hi16), bp:deltay (hi16),
   ; al: deltax (lo8), ch: D (lo8), cl: deltay (lo8), si: D (hi16)
   ; The idea to use the high 16 bits for branches is due to Reenigne
   push bp
   mov bp, sp

   cmp [r], 0           ; if r == 0 call vline
   jne ellipse_rn0
   mov al, colour
   push ax
   mov ax, [y0]
   mov bx, [s]
   add ax, bx
   push ax
   shl bx, 1
   sub ax, bx
   push ax
   mov ax, [x0]
   push ax
   mov ax, WORD PTR [buff+2]
   push ax
   mov ax, WORD PTR [buff]
   push ax
   call _cga_draw_vline
   mov sp, bp
   pop bp
   ret
ellipse_rn0:
   cmp [s], 0
   jne ellipse_sn0
   mov al, colour
   push ax
   mov ax, [y0]
   push ax
   mov ax, [x0]
   mov bx, [r]
   add ax, bx
   push ax
   shl bx, 1
   sub ax, bx
   push ax
   mov ax, WORD PTR [buff+2]
   push ax
   mov ax, WORD PTR [buff]
   push ax
   call _cga_draw_hline
   mov sp, bp
   pop bp
   ret
ellipse_sn0:

   push di
   push si
   push ds

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
   add di, WORD PTR [buff]

   mov dx, [x0]         ; adjust offset for column x0 + r
   sub dx, [r]
   mov ax, dx
   shr dx, 1            
   shr dx, 1
   add di, dx

   push di              ; save for ellipse2

                        ; compute jump offset    
   xor si, si
   and ax, 3            ; deal with scrambled layout
   jnz ellipse2_j1
   mov si, OFFSET ellipse2_jump_check1
   mov WORD PTR cs:[jmp_addr2], si
   jmp ellipse2_jump_done
ellipse2_j1:
   dec ax
   jnz ellipse2_j2
   mov si, OFFSET ellipse2_jump_check2
   mov WORD PTR cs:[jmp_addr2], si
   jmp ellipse2_jump_done
ellipse2_j2:
   dec ax
   jnz ellipse2_j3
   mov si, OFFSET ellipse2_jump_check3
   mov WORD PTR cs:[jmp_addr2], si
   jmp ellipse2_jump_done
ellipse2_j3:
   mov si, OFFSET ellipse2_jump_check4
   mov WORD PTR cs:[jmp_addr2], si
ellipse2_jump_done:

   sub di, dx
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
   mov si, OFFSET ellipse1_jump_check1
   mov WORD PTR cs:[jmp_addr1], si
   jmp ellipse1_jump_done
ellipse1_j1:
   dec ax
   jnz ellipse1_j2
   mov si, OFFSET ellipse1_jump_check2
   mov WORD PTR cs:[jmp_addr1], si
   jmp ellipse1_jump_done
ellipse1_j2:
   dec ax
   jnz ellipse1_j3
   mov si, OFFSET ellipse1_jump_check3
   mov WORD PTR cs:[jmp_addr1], si
   jmp ellipse1_jump_done
ellipse1_j3:
   mov si, OFFSET ellipse1_jump_check4
   mov WORD PTR cs:[jmp_addr1], si
ellipse1_jump_done:

   mov ah, [colour]     ; patch colours in
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch23 + 2], al
   mov BYTE PTR cs:[ellipse1_patch24 + 2], al
   mov WORD PTR cs:[ellipse1_patch37 + 2], ax
   mov BYTE PTR cs:[ellipse2_patch32 + 2], al
   mov BYTE PTR cs:[ellipse2_patch33 + 2], al
   mov WORD PTR cs:[ellipse2_patch58 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch32 + 2], al
   mov BYTE PTR cs:[ellipse1_patch33 + 2], al
   mov WORD PTR cs:[ellipse1_patch58 + 2], ax
   mov BYTE PTR cs:[ellipse2_patch23 + 2], al
   mov BYTE PTR cs:[ellipse2_patch24 + 2], al
   mov WORD PTR cs:[ellipse2_patch37 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah
   mov BYTE PTR cs:[ellipse1_patch1 + 2], al
   mov BYTE PTR cs:[ellipse1_patch2 + 2], al
   mov WORD PTR cs:[ellipse1_patch51 + 2], ax
   mov BYTE PTR cs:[ellipse2_patch10 + 2], al
   mov BYTE PTR cs:[ellipse2_patch11 + 2], al
   mov WORD PTR cs:[ellipse2_patch44 + 2], ax
   ror ah, 1
   ror ah, 1
   mov al, ah 
   mov BYTE PTR cs:[ellipse1_patch10 + 2], al
   mov BYTE PTR cs:[ellipse1_patch11 + 2], al
   mov WORD PTR cs:[ellipse1_patch44 + 2], ax
   mov BYTE PTR cs:[ellipse2_patch1 + 2], al
   mov BYTE PTR cs:[ellipse2_patch2 + 2], al
   mov WORD PTR cs:[ellipse2_patch51 + 2], ax

   mov ax, [s]          ; si = c = s^2
   mul al               
   mov si, ax          
   
   shl ax, 1            ; cl:bx = deltax = 2c*r
   mov cx, [r] 
   mul cx
   mov bx, ax

   push bx              ; compute corrections
   xor ah, ah
   mov bx, OFFSET ncorr
   mov al, cl
   xlat
   mov BYTE PTR cs:[ellipse1_patchn + 1], al
   mov bx, OFFSET cmp1
   mov al, cl
   xlat
   mov dh, 07eh
   cmp ax, [s]
   jne ellipse1_skip_jl
   sub dh, 2
ellipse1_skip_jl:
   mov BYTE PTR cs:[ellipse1_patchjl1], dh
   mov BYTE PTR cs:[ellipse1_patchjl2], dh
   mov BYTE PTR cs:[ellipse1_patchjl3], dh
   mov BYTE PTR cs:[ellipse1_patchjl4], dh
   mov BYTE PTR cs:[ellipse2_patchjl1], dh
   mov BYTE PTR cs:[ellipse2_patchjl2], dh
   mov BYTE PTR cs:[ellipse2_patchjl3], dh
   mov BYTE PTR cs:[ellipse2_patchjl4], dh
   mov bx, OFFSET cmp2
   mov al, cl
   xlat
   mov dh, 07dh
   cmp ax, [s]
   jne ellipse1_skip_jg
   add dh, 2
ellipse1_skip_jg:
   mov BYTE PTR cs:[ellipse1_patchjg1], dh
   mov BYTE PTR cs:[ellipse1_patchjg2], dh
   mov BYTE PTR cs:[ellipse1_patchjg3], dh
   mov BYTE PTR cs:[ellipse1_patchjg4], dh
   mov BYTE PTR cs:[ellipse2_patchjg1], dh
   mov BYTE PTR cs:[ellipse2_patchjg2], dh
   mov BYTE PTR cs:[ellipse2_patchjg3], dh
   mov BYTE PTR cs:[ellipse2_patchjg4], dh
   mov ax, WORD PTR [buff + 2]       ; set DS to segment buff
   mov ds, ax
   pop bx

   mov ax, cx
   mov cl, dl

   mul al
   shl ax, 1
   mov dx, [s]          ; bp = 2a = 2r^2
   mov bp, ax
   mul dx               ; dl:ax = 2a*s

   or ax, bx
   or dl, cl

ellipse1_patchn:
   mov dh, 012h

ellipse1_compute_n:     ; count leading zeros
   inc dh
   shl ax, 1
   rcl dl, 1
   jnc ellipse1_compute_n
   sub dh, 3
   mov ah, dh           ; ah = n = 22 - maxbits(2a*s, 2c*r)

   mov dh, cl           ; deltax = dx:al = 2c*r
   mov dl, bh
   mov al, bl

   mov bx, bp           ; bp:cl = 2a = 2r^2
   mov cl, bl
   mov bl, bh
   xor bh, bh
   mov bp, bx

   mov bx, si           ; bx:ch = c = s^2
   mov ch, bl
   mov bl, bh
   xor bh, bh

   cmp ah, 0
   jle ellipse1_done_shift ; deal with n == -1, 0
ellipse1_shift_loop:
   shl al, 1
   rcl dx, 1
   shl cl, 1
   rcl bp, 1
   shl ch, 1
   rcl bx, 1
   dec ah
   jnz ellipse1_shift_loop
ellipse1_done_shift:

   mov BYTE PTR cs:[ellipse1_patch6 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch8 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch15 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch17 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch19 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch21 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch28 + 1], ch
   mov BYTE PTR cs:[ellipse1_patch30 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch6 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch8 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch15 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch17 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch19 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch21 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch28 + 1], ch
   mov BYTE PTR cs:[ellipse2_patch30 + 1], ch

   mov BYTE PTR cs:[ellipse1_patch38 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch42 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch45 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch49 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch52 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch56 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch59 + 2], ch
   mov BYTE PTR cs:[ellipse1_patch63 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch38 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch42 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch45 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch49 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch52 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch56 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch59 + 2], ch
   mov BYTE PTR cs:[ellipse2_patch63 + 2], ch

   mov WORD PTR cs:[ellipse1_patch7 + 2], bx
   mov WORD PTR cs:[ellipse1_patch9 + 2], bx
   mov WORD PTR cs:[ellipse1_patch16 + 2], bx
   mov WORD PTR cs:[ellipse1_patch18 + 2], bx
   mov WORD PTR cs:[ellipse1_patch20 + 2], bx
   mov WORD PTR cs:[ellipse1_patch22 + 2], bx
   mov WORD PTR cs:[ellipse1_patch29 + 2], bx
   mov WORD PTR cs:[ellipse1_patch31 + 2], bx
   mov WORD PTR cs:[ellipse2_patch7 + 2], bx
   mov WORD PTR cs:[ellipse2_patch9 + 2], bx
   mov WORD PTR cs:[ellipse2_patch16 + 2], bx
   mov WORD PTR cs:[ellipse2_patch18 + 2], bx
   mov WORD PTR cs:[ellipse2_patch20 + 2], bx
   mov WORD PTR cs:[ellipse2_patch22 + 2], bx
   mov WORD PTR cs:[ellipse2_patch29 + 2], bx
   mov WORD PTR cs:[ellipse2_patch31 + 2], bx

   mov WORD PTR cs:[ellipse1_patch39 + 1], bx
   mov WORD PTR cs:[ellipse1_patch43 + 1], bx
   mov WORD PTR cs:[ellipse1_patch46 + 1], bx
   mov WORD PTR cs:[ellipse1_patch50 + 1], bx
   mov WORD PTR cs:[ellipse1_patch53 + 1], bx
   mov WORD PTR cs:[ellipse1_patch57 + 1], bx
   mov WORD PTR cs:[ellipse1_patch60 + 1], bx
   mov WORD PTR cs:[ellipse1_patch64 + 1], bx
   mov WORD PTR cs:[ellipse2_patch39 + 1], bx
   mov WORD PTR cs:[ellipse2_patch43 + 1], bx
   mov WORD PTR cs:[ellipse2_patch46 + 1], bx
   mov WORD PTR cs:[ellipse2_patch50 + 1], bx
   mov WORD PTR cs:[ellipse2_patch53 + 1], bx
   mov WORD PTR cs:[ellipse2_patch57 + 1], bx
   mov WORD PTR cs:[ellipse2_patch60 + 1], bx
   mov WORD PTR cs:[ellipse2_patch64 + 1], bx
   
   mov BYTE PTR cs:[ellipse1_patch4 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch13 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch26 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch35 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch40 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch47 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch54 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch61 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch65 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch67 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch69 + 2], cl
   mov BYTE PTR cs:[ellipse1_patch71 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch4 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch13 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch26 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch35 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch40 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch47 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch54 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch61 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch65 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch67 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch69 + 2], cl
   mov BYTE PTR cs:[ellipse2_patch71 + 2], cl

   mov WORD PTR cs:[ellipse1_patch5 + 2], bp
   mov WORD PTR cs:[ellipse1_patch14 + 2], bp
   mov WORD PTR cs:[ellipse1_patch27 + 2], bp
   mov WORD PTR cs:[ellipse1_patch36 + 2], bp
   mov WORD PTR cs:[ellipse1_patch41 + 2], bp
   mov WORD PTR cs:[ellipse1_patch48 + 2], bp
   mov WORD PTR cs:[ellipse1_patch55 + 2], bp
   mov WORD PTR cs:[ellipse1_patch62 + 2], bp
   mov WORD PTR cs:[ellipse1_patch66 + 2], bp
   mov WORD PTR cs:[ellipse1_patch68 + 2], bp
   mov WORD PTR cs:[ellipse1_patch70 + 2], bp
   mov WORD PTR cs:[ellipse1_patch72 + 2], bp
   mov WORD PTR cs:[ellipse2_patch5 + 2], bp
   mov WORD PTR cs:[ellipse2_patch14 + 2], bp
   mov WORD PTR cs:[ellipse2_patch27 + 2], bp
   mov WORD PTR cs:[ellipse2_patch36 + 2], bp
   mov WORD PTR cs:[ellipse2_patch41 + 2], bp
   mov WORD PTR cs:[ellipse2_patch48 + 2], bp
   mov WORD PTR cs:[ellipse2_patch55 + 2], bp
   mov WORD PTR cs:[ellipse2_patch62 + 2], bp
   mov WORD PTR cs:[ellipse2_patch66 + 2], bp
   mov WORD PTR cs:[ellipse2_patch68 + 2], bp
   mov WORD PTR cs:[ellipse2_patch70 + 2], bp
   mov WORD PTR cs:[ellipse2_patch72 + 2], bp

   shr bp, 1            ; bp:cl = a = r^2
   rcr cl, 1
   
   xor si, si           ; si:ch = D = 0
   xor ch, ch
   xor bx, bx           ; distance between lines above and below axis
   
   push ax
   push cx
   push dx
   push bp

   jmp cs:[jmp_addr1] 
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse1_patch4:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch5:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse1_patchjl2:
   jle ellipse1_x1

ellipse1_jump_check2:
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump2
   jmp ellipse1_donev2  ; done verticalish

ellipse1_x2:
ellipse1_patch6: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch7: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse1_patch13:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch14:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse1_patchjl3:
   jle ellipse1_x2

ellipse1_jump_check3:
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump3
   jmp ellipse1_donev3  ; done verticalish

ellipse1_x1:
ellipse1_patch15: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch16: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
   sbb si, dx
ellipse1_patch17: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch18: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse1_jump1
   jmp ellipse1_donev1

ellipse1_x3:
ellipse1_patch19: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch20: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse1_patch26:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch27:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse1_patchjl4:
   jle ellipse1_x3

ellipse1_jump_check4:
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump4
   jmp ellipse1_donev4  ; done verticalish


ellipse1_x4:
   dec di
ellipse1_patch28: 
   sub al, 012h         ; dx -= s^2
ellipse1_patch29: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse1_patch35:          
   add cl, 012h         ; dy += 2r^2
ellipse1_patch36:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse1_patchjl1:
   jle ellipse1_x4

ellipse1_jump_check1:
   cmp dx, bp           ; check if done verticalish
   jae ellipse1_jump1
   jmp ellipse1_donev1  ; done verticalish

                        ; horizontalish part of ellipse
ellipse1_donev4:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse1_skip_adjust4
   mov ax, es
ellipse1_patch65:
   sub al, 012h         ; dy -= 2r^2
ellipse1_patch66:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse1_skip_adjust4:
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse1_h4   

ellipse1_donev1:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse1_skip_adjust1
   mov ax, es
ellipse1_patch67:
   sub al, 012h         ; dy -= 2r^2
ellipse1_patch68:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse1_skip_adjust1:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h1   

ellipse1_donev2:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse1_skip_adjust2
   mov ax, es
ellipse1_patch69:
   sub al, 012h         ; dy -= 2r^2
ellipse1_patch70:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse1_skip_adjust2:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h2   

ellipse1_donev3:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse1_skip_adjust3
   mov ax, es
ellipse1_patch71:
   sub al, 012h         ; dy -= 2r^2
ellipse1_patch72:
   sbb bp, 01234h
   sub ch, al           ; D -= 2dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse1_skip_adjust3:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse1_h3   

ellipse1_doneh1:

   jmp ellipse1_doneh2

   ; di, di+bx offsets of points above and below axis, ax: pixels
   ; al: deltay (lo8), dx: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltax (lo8), si: D (hi16)
   ; es: dy (hi16) temp

ellipse1_h4:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 0fcfch
ellipse1_patch37:
   or ax, 0303h

ellipse1_patch38:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch39:
   sbb sx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, sx                     
   add ch, cl
   adc si, sx                     

   cmp bp, si           ; if dy < D, increment y
ellipse1_patchjg4:
   jge ellipse1_skip_y4
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse1_patch40:
   add al, 012h         ; dy += 2r^2
ellipse1_patch41:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]

ellipse1_skip_y4:          
   
ellipse1_patch42:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch43:
   sbb dx, 01234h
ellipse1_doneh1_check:
   jl ellipse1_doneh1


ellipse1_h3:
   and ax, 0f3f3h
ellipse1_patch44:
   or ax, 0c0ch

ellipse1_patch45:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch46:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx                     
   add ch, cl
   adc si, dx                     

   cmp bp, si           ; if dy < D, increment y
ellipse1_patchjg3:
   jge ellipse1_skip_y3
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse1_patch47:
   add al, 012h         ; dy += 2r^2
ellipse1_patch48:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
ellipse1_skip_y3:
 
ellipse1_patch49:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch50:
   sbb dx, 01234h
   jl ellipse1_doneh1_check


ellipse1_h2:
   and ax, 0cfcfh
ellipse1_patch51:
   or ax, 03030h

ellipse1_patch52:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch53:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx
   add ch, cl
   adc si, dx

   cmp bp, si           ; if dy < D, increment y
ellipse1_patchjg2:
   jge ellipse1_skip_y2
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse1_patch54:
   add al, 012h         ; dy += 2r^2
ellipse1_patch55:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]
ellipse1_skip_y2:
 
ellipse1_patch56:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch57:
   sbb dx, 01234h
   jl ellipse1_doneh2


ellipse1_h1:
   and ax, 03f3fh
ellipse1_patch58:
   or ax, 0c0c0h

ellipse1_patch59:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch60:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx
   add ch, cl
   adc si, dx

   mov [di+bx], ah
   mov [di], al
 
   cmp bp, si           ; if dy < D, increment y
ellipse1_patchjg1:
   jge ellipse1_skip_y1

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse1_patch61:
   add al, 012h         ; dy += 2r^2
ellipse1_patch62:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines

ellipse1_skip_y1:
   dec di
 
ellipse1_patch63:
   sub cl, 012h         ; dx -= s^2
ellipse1_patch64:
   sbb dx, 01234h
   jl ellipse1_doneh2_skip ; skip extra byte

   jmp ellipse1_h4


ellipse1_doneh2:

   mov [di+bx], ah
   mov [di], al

ellipse1_doneh2_skip:
   
   xor si, si           ; si:ch = D = 0
   xor bx, bx           ; distance between lines above and below axis
   
   pop bp
   pop dx
   pop cx
   pop ax
   pop di

   jmp cs:[jmp_addr2] 
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse2_patch4:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch5:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse2_patchjl3:
   jle ellipse2_x4

ellipse2_jump_check3:
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump3
   jmp ellipse2_donev3  ; done verticalish
   
ellipse2_x3:
ellipse2_patch6: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch7: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse2_patch13:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch14:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse2_patchjl2:
   jle ellipse2_x3

ellipse2_jump_check2:
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump2
   jmp ellipse2_donev2  ; done verticalish
   

ellipse2_x4:
ellipse2_patch15: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch16: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
   sbb si, dx
ellipse2_patch17: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch18: 
   sbb dx, 01234h

   cmp dx, bp           ; check if done verticalish 
   jae ellipse2_jump4
   jmp ellipse2_donev4


ellipse2_x2:
ellipse2_patch19: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch20: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse2_patch26:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch27:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse2_patchjl1:
   jle ellipse2_x2

ellipse2_jump_check1:
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump1
   jmp ellipse2_donev1  ; done verticalish


ellipse2_x1:
   inc di
ellipse2_patch28: 
   sub al, 012h         ; dx -= s^2
ellipse2_patch29: 
   sbb dx, 01234h
   sub ch, al           ; D -= 2*dx
   sbb si, dx
   sub ch, al
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

   mov es, ax

   sub di, 8112         ; update offset
   sbb ax, ax
   and ax, 16304
   add di, ax

   mov ax, es

   sub bx, 80           ; decrement/increment y lines 

   add ch, cl           ; D += 2*dy
   adc si, bp
   add ch, cl
   adc si, bp
ellipse2_patch35:          
   add cl, 012h         ; dy += 2r^2
ellipse2_patch36:
   adc bp, 01234h

   cmp dx, si           ; if dx <= D, decrement x
ellipse2_patchjl4:
   jle ellipse2_x1

ellipse2_jump_check4:
   cmp dx, bp           ; check if done verticalish
   jae ellipse2_jump4
   jmp ellipse2_donev4  ; done verticalish


                        ; horizontalish part of ellipse
ellipse2_donev1:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse2_skip_adjust1
   mov ax, es
ellipse2_patch65:
   sub al, 012h         ; dy -= 2r^2
ellipse2_patch66:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse2_skip_adjust1:
   neg ch               ; D = -D
   adc si, 0
   neg si
   jmp ellipse2_h1   

ellipse2_donev4:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse2_skip_adjust4
   mov ax, es
ellipse2_patch67:
   sub al, 012h         ; dy -= 2r^2
ellipse2_patch68:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse2_skip_adjust4:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h4 

ellipse2_donev3:

   mov es, cx
   mov cl, al
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse2_skip_adjust3
   mov ax, es
ellipse2_patch69:
   sub al, 012h         ; dy -= 2r^2
ellipse2_patch70:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse2_skip_adjust3:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h3   

ellipse2_donev2:

   mov es, cx
   mov cl, al 
   cmp bp, si           ; if dy < D, decrement y
   jge ellipse2_skip_adjust2
   mov ax, es
ellipse2_patch71:
   sub al, 012h         ; dy -= 2r^2
ellipse2_patch72:
   sbb bp, 01234h
   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
   mov es, ax
   sub di, 8192         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax
   add bx, 80           ; decrement/increment y lines 
ellipse2_skip_adjust2:
   neg ch               ; D = -D
   adc si, 0
   neg si
   mov ah, [di+bx]
   mov al, [di]
   jmp ellipse2_h2   
  

ellipse2_doneh1:

   mov [di+bx], ah
   mov [di], al

   pop ds
   pop si
   pop di
   pop bp
   ret

   ; di, di+bx offsets of points above and below axis, dx: pixels
   ; dl: deltay (lo8), ax: deltax (hi16), bp: deltay (hi16),
   ; ch: D (lo8), cl: deltax (lo8), si: D (hi16)
   ; es: dy (hi16) temp

ellipse2_h1:
   mov ah, [di+bx]
   mov al, [di]
   and ax, 03f3fh
ellipse2_patch37:
   or ax, 0c0c0h

ellipse2_patch38:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch39:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx                     
   add ch, cl
   adc si, dx                     

   cmp bp, si           ; if dy < D, increment y
ellipse2_patchjg1:
   jge ellipse2_skip_y1
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse2_patch40:
   add al, 012h         ; dy += 2r^2
ellipse2_patch41:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
ellipse2_skip_y1:          

ellipse2_patch42:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch43:
   sbb dx, 01234h
ellipse2_doneh1_check:
   jl ellipse2_doneh1


ellipse2_h2:
   and ax, 0cfcfh
ellipse2_patch44:
   or ax, 0303h

ellipse2_patch45:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch46:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx                     
   add ch, cl
   adc si, dx                     
 
   cmp bp, si           ; if dy < D, increment y
ellipse2_patchjg2:
   jge ellipse2_skip_y2
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse2_patch47:
   add al, 012h         ; dy += 2r^2
ellipse2_patch48:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines 

   mov ah, [di+bx]
   mov al, [di]
ellipse2_skip_y2:
 
ellipse2_patch49:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch50:
   sbb dx, 01234h
   jl ellipse2_doneh1_check


ellipse2_h3:
   and ax, 0f3f3h
ellipse2_patch51:
   or ax, 0c0ch

ellipse2_patch52:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch53:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx
   add ch, cl
   adc si, dx
 
   cmp bp, si           ; if dy < D, increment y
ellipse2_patchjg3:
   jge ellipse2_skip_y3
   
   mov [di+bx], ah
   mov [di], al

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse2_patch54:
   add al, 012h         ; dy += 2r^2
ellipse2_patch55:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines

   mov ah, [di+bx]
   mov al, [di]
ellipse2_skip_y3:
 
ellipse2_patch56:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch57:
   sbb ax, 01234h
   jl ellipse2_doneh2


ellipse2_h4:
   and ax, 0fcfch
ellipse2_patch58:
   or ax, 0303h

ellipse2_patch59:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch60:
   sbb dx, 01234h
   add ch, cl           ; D += 2*dx
   adc si, dx
   add ch, cl
   adc si, dx

   mov [di+bx], ah
   mov [di], al
 
   cmp bp, si           ; if dy < D, increment y
ellipse2_patchjg4:
   jge ellipse2_skip_y4

   mov ax, es

   sub ch, al           ; D -= 2*dy
   sbb si, bp
   sub ch, al
   sbb si, bp
ellipse2_patch61:
   add al, 012h         ; dy += 2r^2
ellipse2_patch62:
   adc bp, 01234h

   mov es, ax

   sub di, 8112         ; update offset of odd <-> even
   sbb ax, ax
   and ax, 16304
   add di, ax

   sub bx, 80           ; decrement/increment y lines
ellipse2_skip_y4:
   inc di
 
ellipse2_patch63:
   sub cl, 012h         ; dx -= s^2
ellipse2_patch64:
   sbb dx, 01234h
   jl ellipse2_doneh2_skip ; skip extra byte and doubled pixel

   jmp ellipse2_h1


ellipse2_doneh2:

   mov [di+bx], ah
   mov [di], al

ellipse2_doneh2_skip:

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_draw_ellipse ENDP

   END