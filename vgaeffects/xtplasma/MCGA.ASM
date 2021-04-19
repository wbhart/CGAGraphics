DOSSEG
.MODEL small
.DATA

.CODE

   public _set_fire_palette
_set_fire_palette PROC
   xor ah, ah
   xor bl, bl
   xor bh, bh

   mov cx, 42

fire_br_loop:
   inc bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h
   add ah, 3
   mov al, ah
   shr al, 1
   shr al, 1   
   out dx, al
   xor al, al
   out dx, al
   xor al, al
   out dx, al

   neg bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al
   neg bh

   mov dx, 3c9h
   add ah, 3
   mov al, ah
   shr al, 1
   shr al, 1   
   out dx, al
   xor al, al
   out dx, al
   xor al, al
   out dx, al
   loop fire_br_loop

   inc bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h
   add ah, 3
   mov al, ah
   shr al, 1
   shr al, 1   
   out dx, al
   xor al, al
   out dx, al
   xor al, al
   out dx, al

   mov cx, 42
   shr ah, 1
   shr ah, 1

fire_ry_loop:
   neg bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al
   neg bh

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al
   xor al, al
   out dx, al

   inc bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al
   xor al, al
   out dx, al
   loop fire_ry_loop

   neg bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al
   neg bh

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al
   xor al, al
   out dx, al

   mov cx, 42
   xor bl, bl

fire_yw_loop:
   inc bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al

   neg bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al
   neg bh

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al
   loop fire_yw_loop

   inc bh
   mov al, bh 
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h
   add bl, 3
   mov al, ah
   out dx, al
   out dx, al
   mov al, bl
   shr al, 1
   shr al, 1
   out dx, al
   ret
_set_fire_palette ENDP

   public _vga_plasma
_vga_plasma PROC
   ARG buff:DWORD
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0a000h
   mov es, ax
   xor di, di

   lds si, buff

   mov bx, 200
line_loop:
   mov cx, 160
   rep movsw
   dec bx
   jnz line_loop
    
   pop ds
   pop si
   pop di
   pop bp
   ret
_vga_plasma ENDP

PUBLIC _mcga_stosw
_mcga_stosw PROC
   push bp
   mov bp, sp
   push di
   push si

   mov ax, 0a000h
   mov es, ax

   mov ax, 0aaaah

   mov bx, 10
mcga_next_colour:
   mov dx, 60

mcga_next_frame:

   mov cx, 32000
   rep stosw

   dec dx
   jnz mcga_next_frame
   
   xor ax, 0ffffh

   dec bx
   jnz mcga_next_colour

   pop si
   pop di
   pop bp
   ret
_mcga_stosw ENDP

   END