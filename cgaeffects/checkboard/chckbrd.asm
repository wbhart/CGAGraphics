   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _cga_checkboard
_cga_checkboard PROC
   push di

   mov ax, 0b800h       ; set CGA segment
   mov es, ax

   mov dx, 0h           ; set initial offset

   mov ax, 05555h       ; solid colour 1

   mov cx, 25           ; number of pairs of lines to draw
checkboard_loop1:
   mov di, dx

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   mov di, dx
   add di, 8192         ; odd lines

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
     
   add dx, 80
   loopz checkboard_done1
   jmp checkboard_loop1

checkboard_done1:

   mov dx, 0
   not ax
   mov cx, 25

checkboard_loop2:
   mov di, dx

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   mov di, dx
   add di, 8192         ; odd lines

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 2
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 1
   stosb
   stosw
   stosw

   add di, 1920

   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   not ax               ; solid colour 1
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosw
   stosb
   not ax               ; solid colour 2
   stosb
   stosw
   stosw

   add dx, 80
   loopz checkboard_done2
   jmp checkboard_loop2

checkboard_done2:

   pop di
   ret
_cga_checkboard ENDP

   END

