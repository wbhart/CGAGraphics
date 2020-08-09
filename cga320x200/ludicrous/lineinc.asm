   DOSSEG
   .MODEL small
   .CODE

   salc macro
      db 0d6h
   endm
   
   PUBLIC _get_line_increments
_get_line_increments PROC
   ARG buff:WORD, deltax:WORD, deltay:WORD
   push bp
   mov bp, sp
   push di

   mov ax, ds           ; set segment for table
   mov es, ax

   mov di, [buff]       ; get buffer address
   inc di               ; skip first entry

   mov dx, [deltax]
   mov cx, [deltay]

   cmp dx, 0
   jl lineinc_left

   cmp dx, cx
   jb lineinc_vr
   jmp lineinc_hr

lineinc_vr:
   xor ax, ax           ; compute increment = round(65536*dx/dy)
   div cx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov bx, 08000h       ; starting value for increments

   add bx, dx           ; inc x?
   salc
   neg al

   inc cx
   shr cx, 1            ; compute iterations

   jnc lineinc_vr_mid
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

   loop lineinc_vr_loop

lineinc_vr_no_iter:

   pop di
   pop bp
   ret

lineinc_hr:
   mov ax, dx           ; compute q = dx/dy
   div cl
   mov bh, al
   mov dl, ah
   xor dh, dh

   xor ax, ax           ; compute increment = round(65536*dx/dy)
   div cx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov ah, bh           ; get q

   mov bx, 08000h       ; starting value for increments

   add bx, dx           ; extra inc x?
   salc
   neg al
   add al, ah

   inc cx
   shr cx, 1            ; compute iterations

   jnc lineinc_hr_mid
   jz lineinc_hr_no_iter

lineinc_hr_loop:
   stosb

   add bx, dx           ; extra inc x?
   salc
   neg al
   add al, ah

lineinc_hr_mid:
   stosb

   add bx, dx           ; extra inc x?
   salc
   neg al
   add al, ah

   loop lineinc_hr_loop

lineinc_hr_no_iter:

   pop di
   pop bp
   ret

lineinc_left:

   neg dx               ; make deltax positive

   cmp dx, cx
   jb lineinc_vl
   jmp lineinc_hl

lineinc_vl:
   xor ax, ax           ; compute increment = round(65536*dx/dy)
   div cx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov bx, 08000h       ; starting value for increments

   add bx, dx           ; inc x?
   salc

   inc cx
   shr cx, 1            ; compute iterations

   jnc lineinc_vl_mid
   jz lineinc_vl_no_iter

lineinc_vl_loop:
   stosb

   add bx, dx           ; inc x?
   salc

lineinc_vl_mid:
   stosb

   add bx, dx           ; inc x?
   salc

   loop lineinc_vl_loop

lineinc_vl_no_iter:

   pop di
   pop bp
   ret

lineinc_hl:
   mov ax, dx           ; compute q = dx/dy
   div cl
   mov bh, al
   mov dl, ah
   xor dh, dh

   xor ax, ax           ; compute increment = round(65536*dx/dy)
   div cx
   shl dx, 1
   adc ax, 0
   mov dx, ax

   mov ah, bh           ; get q

   mov bx, 08000h       ; starting value for increments

   add bx, dx           ; extra inc x?
   salc
   sub al, ah

   inc cx
   shr cx, 1            ; compute iterations

   jnc lineinc_hl_mid
   jz lineinc_hl_no_iter

lineinc_hl_loop:
   stosb

   add bx, dx           ; extra inc x?
   salc
   sub al, ah

lineinc_hl_mid:
   stosb

   add bx, dx           ; extra inc x?
   salc
   sub al, ah

   loop lineinc_hl_loop

lineinc_hl_no_iter:

   pop di
   pop bp
   ret

_get_line_increments ENDP

   END
