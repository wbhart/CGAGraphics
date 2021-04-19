.MODEL small
.stack 100h

.CODE
.386
   public _vga_plasma
_vga_plasma PROC
   ARG sintab:WORD
   push bp
   mov bp, sp
   push di

   mov ah, 00h
   mov al, 13h
   int 10h   

   mov ax, 0a000h
   mov es, ax
   xor di, di

   mov al, 1
   mov dx, 3c8h
   out dx, al

   mov dx, 3c9h

   mov ah, 255
   mov bl, 0

   mov cx, 84

plasma_rg_loop:
   sub ah, 3
   add bl, 3
   mov al, ah
   inc al
   shr al, 1
   shr al, 1
   dec al
   out dx, al
   mov al, bl
   inc al
   shr al, 1
   shr al, 1
   dec al
   out dx, al
   xor al, al
   out dx, al
   loop plasma_rg_loop

   sub ah, 3
   add bl, 3

   xor al, al
   out dx, al
   mov al, 63
   out dx, al
   xor al, al
   out dx, al

   mov cx, 84

plasma_gb_loop:
   add ah, 3
   sub bl, 3
   xor al, al
   out dx, al
   mov al, bl
   inc al
   shr al, 1
   shr al, 1
   dec al
   out dx, al
   mov al, ah
   inc al
   shr al, 1
   shr al, 1
   dec al
   out dx, al
   loop plasma_gb_loop

   mov ah, 63
   sub bl, 3

   xor al, al
   out dx, al
   out dx, al
   mov al, ah
   out dx, al

   mov cx, 84

plasma_bw_loop:
   add bl, 3
   mov al, bl
   inc al
   shr al, 1
   shr al, 1
   dec al
   out dx, al
   out dx, al
   mov al, ah
   out dx, al
   loop plasma_bw_loop

   mov al, ah
   out dx, al
   out dx, al
   out dx, al

   mov bx, sintab

   mov cx, 86
frame_loop:
   push cx

   xor di, di
   ror ebx, 16
   mov bx, cx
   rol ebx, 16

   push ebx

   mov dx, 200
line_loop:

   mov si, dx
patch1:
   add si, 0
   and si, 63
   mov ah, [bx+si]

   pop ebx

   ror ebx, 16
   add bx, dx
   rol ebx, 16

   push ebx

   mov cx, 320
pixel_loop:

   mov al, ah

   mov si, cx
patch2:
   add si, 0
   and si, 63
   add al, [bx+si]
   shr al, 1

   ror ebx, 16
   add bx, cx
   mov si, bx
   shr si, 8
   rol ebx, 16

   and si, 63
   add al, [bx+si]
 
   inc al

   stosb
   loop pixel_loop   

   dec dx
   jnz line_loop

   add WORD PTR [patch1+2], 1
   add WORD PTR [patch2+2], 3

   pop ebx

   pop cx
   loop frame_loop
    
   pop di
   pop bp
   ret
_vga_plasma ENDP

   public _text_mode
_text_mode PROC
   mov ah, 00h
   mov al, 03h
   int 10h

   ret
_text_mode ENDP

END
