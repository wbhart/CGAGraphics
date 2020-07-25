   DOSSEG
   .MODEL small
   .CODE

   salc macro
      db 0d6h
   endm

   ; vd odd jump address before even

   PUBLIC _cga_draw_line_increments
_cga_draw_line_increments PROC
   ARG buff:DWORD, dx:WORD, dy:WORD
   push bp
   mov bp, sp
   push di

   mov ax, ds           ; set segment for table
   mov es, ax

   mov dx, [dx]         ; compute increment = round(65536*dx/dy)
   xor ax, ax
   mov cx, [dy]
   div cx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov di, [buff]       ; get buffer address
   inc                  ; skip first entry

   mov bx, 08000h       ; starting value for increments

   add bx, dx           ; inc x?
   salc
   neg al

   inc cx
   shr cx, 1            ; compute iterations

   jc lineinc_vr_mid
   jz lineinc_vr_no_iter

lineinc_vr_loop:
   stosb

   add bx, dx           ; inc x?
   salc
   neg al

lineinc_vr_mid:
   stosb

   add bx, dx           ; inc x?
   salc
   neg al

   loop lineinv_cd_loop

lineinc_vr_no_iter:

   pop di
   pop bp
   ret
_cga_draw_line_increments ENDP

   END
