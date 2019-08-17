	DOSSEG
	.MODEL small
	.CODE
   
   PUBLIC _cga_draw_line1
_cga_draw_line1 PROC
   LOCAL yinc:WORD, ycorr:WORD=AUTO_SIZE
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
	; line from (x0, y0) - (xend, ?) including endpoints
   ; AX: Acc, BX: 2*dx, DX: 2*dy, CX: Loop,
   ; SI: D, DI: Offset, DS: Colour/Mask, ES: B800
   push bp
	mov bp, sp
   sub sp, AUTO_SIZE
   push di
   push si
   push ds

   mov ax, 0b800h       ; set segment for CGA memory
   mov es, ax

   xor di, di           ; compute offset for raster y0
   mov ax, [y0]
   shr ax, 1
   sbb di, 0
   and di, 8192
   mov cl, 4        
   shl ax, cl
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov bx, xdiff        ; compute 2*dx
   shl bx, 1

   mov dx, ydiff        ; compute 2*dy
   shl dx, 1

   mov [yinc], 8112     ; set up y increment
   mov [ycorr], 16304
   cmp dx, 0       
   jge line1_yinc
   add [yinc], 80
   add [ycorr], 160
   neg dx
line1_yinc:

   mov si, D            ; store D

   mov cx, [x0]         ; set up colour and mask
   mov ah, [colour] 
   inc cl
   and cl, 3
   shl cl, 1
   ror ah, cl
   mov al, 0fch
   ror al, cl
   mov ds, ax

   mov ax, [x0]         ; get x0
   
   mov cx, [xend]       ; compute loop iterations
   sub cx, ax
   inc cx

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   sub di, dx           ; compensate for first addition of 2*dy

   mov ax, ds           ; get colour and mask information

line1_loop:          
   and al, es:[di]      ; draw pixel at x, y
   or al, ah
   stosb

   add si, dx           ; D += 2*dy
   jle line1_skip_inc_y

   xor ax, ax           ; increment y
   sub di, yinc
   sbb ax, ax
   and ax, ycorr
   add di, ax

   sub si, bx           ; D -= 2*dx
line1_skip_inc_y   
   mov ax, ds           ; increment x
   ror ah, 1
   ror ah, 1
   ror al, 1
   ror al, 1
   sbb di, 0            ; adjust offset
   mov ds, ax           ; store updated colour and mask

   loop line1_loop

   pop ds
   pop si
   pop di
   add sp, AUTO_SIZE
   pop bp
   ret
_cga_draw_line1 ENDP
