   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _cga_draw_vline
_cga_draw_vline PROC
	ARG buff:DWORD, x:WORD, y0:WORD, y1:WORD, colour:BYTE
	; draw a line from (x, y0) - (x, y1) including endpoints in the give colour (0-3)
   push bp
   mov bp, sp
   push di
   push si
   push ds

   les di, buff         ; get buffer address in es:di

   mov ax, es           ; mirror in ds
   mov ds, ax

   mov ax, [y0]         ; get y0 coordinate
   inc ax            
   shr ax, 1            ; set ax = (y0 + 1)/2
   cmc
   sbb bx, bx           ; bx = -1 if y0 is odd, else bx = 0

   mov dx, [y1]         ; get y1 coordinate
   shr dx, 1            ; y1/2
   cmc
   sbb cx, cx           ; cx = -1 if y1 even, else cx = 0       

   sub dx, ax           ; dx = even line iterations
   inc dx

   mov si, dx           ; si = odd line iterations     
   add si, cx
   sub si, bx

   and bx, -80          ; bx = -80 if y0 is odd, else bx = 0
        
   shl ax, 1            ; set di to 80*(y0 + 1)/2 = first even line
   shl ax, 1
   shl ax, 1
   shl ax, 1
   add di, ax          
   shl ax, 1
   shl ax, 1
   add di, ax

   add bx, di           ; set bx to 8192 + 80*(y0/2) = first odd line
   add bh, 020h

   mov ax, [x]          ; get x coordinate
   mov cl, al
   shr ax, 1
   shr ax, 1            ; compute byte of pixel at coord x
   add di, ax           ; add it to offset of first even line
   add bx, ax           ; add it to offset of first odd line

   mov ah, [colour]     ; shift colour (ah) and mask (dl) into correct bitfields
   inc cl
   and cl, 3
   shl cl, 1
   ror ah, cl
   mov al, 0fch        
   ror al, cl

   mov cx, dx           ; get iterations

   mov dl, al           
   
   shr cx, 1
   jnc vline_even_iters

   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb  

   add di, 79           ; jump to next odd line

vline_even_iters:

   cmp cx, 0            ; check for zero iterations
   je vline_done_even

vline_even:             ; display pixels on even lines (unroll by 2)
   
   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, 79           ; jump to next even line
      
   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, 79           ; jump to next even line
   loop vline_even      ; loop

vline_done_even:
   
   mov di, bx           ; load offset of first odd line

   mov cx, si           ; get iterations

   shr cx, 1            ; unroll by 2
   jnc vline_odd_iters

   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, 79           ; jump to next odd line

vline_odd_iters:

   cmp cx, 0            ; check for zero iterations
   je vline_done_odd

vline_odd:              ; display pixels on odd lines (unroll by 2)

   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, 79           ; jump to next odd line

   mov al, dl           ; write pixel
   and al, [di]
   or al, ah
   stosb     

   add di, 79           ; jump to next odd line
   loop vline_odd       ; loop

vline_done_odd: 

   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_vline ENDP

   END