   DOSSEG
   .MODEL small
   .CODE

   jmp_addr   DW ?
   sp_save    DW ?
   ss_save    DW ?

   PUBLIC _cga_fire
_cga_fire PROC
   ARG rand_arr:WORD
   ; al, ah, bl, bh, dl, dh: vals
   ; di: cga offset, bp: offset inc, cx: loop
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, ds
   mov es, ax

   mov ax, 0b800h
   mov ds, ax

   mov di, [rand_arr]
   xor bp, bp

   mov cx, 1000

cga_fire_loop:
   push cx
   push di
   
   cmp bp, 2560
   jne cga_fire_more_rand
   xor bp, bp
cga_fire_more_rand:

   mov si, 8000          ; copy random values just below visible screen
   mov cx, 80
cga_fire_rand_loop:
   mov al, es:[di+bp]
   mov [si], al
   inc si
   inc bp
   loop cga_fire_rand_loop

   push bp
   
   mov di, 6000       ; setup di, bp
   mov bp, 8193

   mov cx, 50         ; 50 lines at bottom of screen 

cga_fire_loop50:
   push cx

   mov cx, 26         ; 78/3 = 26 iterations (unroll by three)

   sub bp, 2
   mov dl, ds:[di+bp]    ; setup al, ah, bl, bh, dl
   inc bp
   and dl, 15
   mov bl, ds:[di+bp]
   inc bp
   mov bh, bl
   shr bh, 1
   shr bh, 1
   shr bh, 1
   shr bh, 1
   and bl, 15
   mov al, ds:[di+bp]
   mov ah, al
   shr ah, 1
   shr ah, 1
   shr ah, 1
   shr ah, 1
   and al, 15

cga_fire_loop26:
   push cx

   add ah, bl         ; compute sums
   add al, ah
   add ah, bh
   mov si, ax         ; compute pixels
   shl si, 1
   shl si, 1
   add ax, si
   shr ax, 1
   shr ax, 1
   shr ax, 1
   shr ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add al, ah
   mov [di], al       ; write pixels
   inc di
   mov dh, ds:[di+bp]    ; get next pixels
   mov al, dh
   shr dh, 1
   shr dh, 1
   shr dh, 1
   shr dh, 1
   and al, 15

   add bh, dl         ; compute sums
   add bl, bh
   add bh, dh
   mov si, bx         ; compute pixels
   shl si, 1
   shl si, 1
   add bx, si
   shr bx, 1
   shr bx, 1
   shr bx, 1
   shr bx, 1
   shl bl, 1
   shl bl, 1
   shl bl, 1
   shl bl, 1
   add bl, bh
   mov [di], bl       ; write pixels
   inc di
   mov ah, ds:[di+bp]    ; get next pixels
   mov bl, ah
   shr ah, 1
   shr ah, 1
   shr ah, 1
   shr ah, 1
   and bl, 15

   add dh, al         ; compute sums
   add dl, dh
   add dh, ah
   mov si, dx         ; compute pixels
   shl si, 1
   shl si, 1
   add dx, si
   shr dx, 1
   shr dx, 1
   shr dx, 1
   shr dx, 1
   shl dl, 1
   shl dl, 1
   shl dl, 1
   shl dl, 1
   add dl, dh
   mov [di], dl       ; write pixels
   inc di
   mov bh, ds:[di+bp]    ; get next pixels
   mov dl, bh
   shr bh, 1
   shr bh, 1
   shr bh, 1
   shr bh, 1
   and dl, 15

   pop cx
   dec cx
   jcxz cga_fire_loop26_done
   jmp cga_fire_loop26
cga_fire_loop26_done:

                      ; extra two iterations   
   add ah, bl         ; compute sums
   add al, ah
   add ah, bh
   mov si, ax         ; compute pixels
   shl si, 1
   shl si, 1
   add ax, si
   shr ax, 1
   shr ax, 1
   shr ax, 1
   shr ax, 1
   shl al, 1
   shl al, 1
   shl al, 1
   shl al, 1
   add al, ah
   mov [di], al       ; write pixels
   inc di
   mov dh, ds:[di+bp]    ; get next pixels
   mov al, dh
   shr dh, 1
   shr dh, 1
   shr dh, 1
   shr dh, 1
   and al, 15

   add bh, dl         ; compute sums
   add bl, bh
   add bh, dh
   mov si, bx         ; compute pixels
   shl si, 1
   shl si, 1
   add bx, si
   shr bx, 1
   shr bx, 1
   shr bx, 1
   shr bx, 1
   shl bl, 1
   shl bl, 1
   shl bl, 1
   shl bl, 1
   add bl, bh
   mov [di], bl       ; write pixels
   inc di

   sub di, 8192
   jnc cga_fire_odd
   add di, 16304
cga_fire_odd:

   xor bp, 0c050h     ; switch between 8193 and -8111

   pop cx
   dec cx
   jcxz cga_fire_done50
   jmp cga_fire_loop50
cga_fire_done50:

   pop bp
   pop di
   pop cx
   dec cx
   jcxz cga_fire_done
   jmp cga_fire_loop
cga_fire_done:

   pop ds
   pop si
   pop di
   pop bp
   ret   
_cga_fire ENDP

   END