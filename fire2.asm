   DOSSEG
   .MODEL small
   .CODE

   jmp_addr   DW ?
   sp_save    DW ?
   ss_save    DW ?

      PUBLIC _cga_fire2
_cga_fire2 PROC
   ARG fire_arr:WORD, rand_arr:WORD
   ; al, ah, dl, dh: vals, bx: offset to next line
   ; di: cga offset, bp: temp, cl: shift, ch: loop
   ; si: offset into fire array
   ; rand_array is 160*32 = 5120 bytes of random values in [0, 31]
   ; fire_arr is a zeroed array of 160*23 = 3680 bytes
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov si, [rand_arr]
   mov bx, si
   add bx, 5120
   mov di, [fire_arr]
   add di, 3520

   mov cx, 1000

cga_fire2_loop:
   push cx
   push bx
   push di

   cmp si, bx
   jne cga_fire2_more_rand
   sub si, 5120
cga_fire2_more_rand:

   mov ax, ds            ; copy random values in final row of array
   mov es, ax
   mov cx, 80
   rep movsw
   
   push si
   
   sub si, 3521         ; move to start of fire array

   mov ax, 0b800h       ; set up CGA segment and offset
   mov es, ax
   mov di, 7120
   
   lodsw                ; load initial al, ah, dl, dh values
   mov dx, [si]

   mov cl, 4            ; used for shifts by a nibble

   mov ch, 15
cga_fire2_loop15:       ; 15 lines for which overflow is impossible
   push cx

   mov ch, 80           ; 160 "pixels" / 2 pixels at a time
cga_fire2_loop80_15:

   add ah, dl           ; compute (a+b+c)*5/16 values
   add al, ah
   add ah, dh
   mov bp, ax           ; multiply by 5
   shl ax, 1
   shl ax, 1
   add ax, bp
   shr ax, cl
   and al, 31
   mov [si-159], ax     ; write values
   shr al, 1
   shr ah, 1
   shl al, cl
   add al, ah
   stosb                ; draw pixel

   lodsw                ; load values

   xchg ax, dx

   dec ch
   jnz cga_fire2_loop80_15

   sub di, 8192          ; next CGA line
   jnc cga_fire2_odd15
   add di, 16304
cga_fire2_odd15:

   pop cx
   dec ch
   jnz cga_fire2_loop15


   mov ch, 5
cga_fire2_loop5:         ; 5 lines for which only overflow for last add possible
   push cx

   mov ch, 80           ; 160 "pixels" / 2 pixels at a time
cga_fire2_loop80_5:

   add ah, dl           ; compute (a+b+c)*5/16 values
   add al, ah
   add ah, dh
   push cx
   mov cx, ax           ; multiply by 5
   shl ax, 1
   add cx, ax
   add al, cl
   rcr al, 1            ; may have been overflow
   add ah, ch
   rcr al, 1            ; may have been overflow
   shr ax, 1
   shr ax, 1
   shr ax, 1
   and al, 31
   mov [si-159], ax     ; write values
   shr al, 1
   shr ah, 1
   pop cx
   shl al, cl
   add al, ah
   stosb                ; draw pixel

   lodsw                ; load values

   xchg ax, dx

   dec ch
   jnz cga_fire2_loop80_5

   sub di, 8192          ; next CGA line
   jnc cga_fire2_odd5
   add di, 16304
cga_fire2_odd5:

   pop cx
   dec ch
   jnz cga_fire2_loop5


   mov ch, 2
cga_fire2_loop2:         ; 2 lines for which two overflows possible
   push cx

   mov ch, 80           ; 160 "pixels" / 2 pixels at a time
cga_fire2_loop80_2:

   add ah, dl           ; compute (a+b+c)*5/16 values
   add al, ah
   add ah, dh
   push cx
   mov cx, ax           ; multiply by 5
   shl ax, 1
   add ch, ah
   rcr ch, 1            ; overflow may be possible
   adc ah, 0
   shr ah, 1
   add ah, ch
   add cl, al
   rcr cl, 1
   adc al, 0
   shr al, 1
   add al, cl   
   pop cx
   shr ax, 1
   shr ax, 1
   shr ax, 1
   and al, 31
   mov [si-159], ax     ; write values
   shr al, 1
   shr ah, 1
   shl al, cl
   add al, ah
   stosb                ; draw pixel

   lodsw                ; load values

   xchg ax, dx

   dec ch
   jnz cga_fire2_loop80_2

   sub di, 8192          ; next CGA line
   jnc cga_fire2_odd2
   add di, 16304
cga_fire2_odd2:

   pop cx
   dec ch
   jnz cga_fire2_loop2

   pop si
   pop di
   pop bx
   pop cx
   dec cx
   jcxz cga_fire2_done
   jmp cga_fire2_loop
cga_fire2_done:

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_fire2 ENDP

   END