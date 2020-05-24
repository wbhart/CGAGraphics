   PUBLIC _cga_draw_vline
_cga_draw_vline PROC
	ARG x:WORD, y0:WORD, y1:WORD, colour:BYTE
	; draw a line from (x, y0) - (x, y1) including endpoints in the give colour (0-3)
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set segment reg to B800
   mov es, ax
   mov ds, ax           ; mirror in ds

   mov ax, [y0]         ; get y0 coordinate
   inc ax            
   shr ax, 1            ; set ax = (y0 + 1)/2
   cmc
   sbb bx, bx
   and bx, -80          ; bx = -80 if y0 is odd, else bx = 0
        
   shl ax, 1            ; set di to 80*(y0 + 1)/2 = first even line
   shl ax, 1
   shl ax, 1
   shl ax, 1
   mov di, ax          
   shl ax, 1
   shl ax, 1
   add di, ax

   add bx, di           ; set bx to 8192 + 80*(y0/2) = first odd line
   add bh, 020h

   mov ax, [y1]         ; get y1 coordinate
   shr ax, 1            ; y1/2
   cmc
   sbb ch, ch          
   and ch, 80           ; ch = 80 if y1 even, else ch = 0

   shl ax, 1            ; set dx = 80*(y1/2)
   shl ax, 1
   shl ax, 1
   shl ax, 1
   mov dx, ax
   shl ax, 1
   shl ax, 1
   add dx, ax

   mov ax, [x]          ; get x coordinate
   mov cl, al
   shr ax, 1
   shr ax, 1            ; compute byte of pixel at coord x
   add di, ax           ; add it to offset of first even line
   add dx, ax           ; add it to offset of y1 line
   add bx, ax           ; add it to offset of first odd line

   mov ah, [colour]     ; shift colour (ah) and mask (cl) into correct bitfields
   inc cl
   and cl, 3
   shl cl, 1
   ror ah, cl
   mov al, 0fch        
   ror al, cl
   mov cl, al

   mov si, 79           ; set si = offset increment
   
vline_even:             ; display pixels on even lines (unroll by 2)
   cmp di, dx
   ja vline_done_even   ; check if done
   
   mov al, cl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, si           ; jump to next even line
   
   cmp di, dx
   ja vline_done_even   ; check if done
   
   mov al, cl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, si           ; jump to next even line
   jmp vline_even       ; loop

vline_done_even:
   
   mov di, bx           ; load offset of first odd line
   xor dh, 20h          ; update y1 offset to an odd line
   sub dl, ch           ; adjust by one odd line if last line is even
   sbb dh, 0

vline_odd:              ; display pixels on odd lines (unroll by 2)
   cmp di, dx
   ja vline_done_odd    ; check if done
   
   mov al, cl           ; write pixel
   and al, [di]
   or al, ah
   stosb

   add di, si           ; jump to next odd line

   cmp di, dx
   ja vline_done_odd    ; check if done

   mov al, cl
   and al, [di]
   or al, ah
   stosb                ; write pixel

   add di, si          ; jump to next odd line
   jmp vline_odd       ; loop

vline_done_odd: 

   pop si
   pop di
   pop bp
   ret
_cga_draw_vline ENDP