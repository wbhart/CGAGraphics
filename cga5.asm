   DOSSEG
   .MODEL small
   .CODE
   
   PUBLIC _cga_draw_line1
_cga_draw_line1 PROC
   ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
   ; line from (x0, y0) - (xend, ?) including endpoints
   ; AX: Acc, BX: 2*dx, SP: 2*dy, CX: Loop, BP: ydelta
   ; DX: D, DI: Offset, ES: B800, SI: Jump offset
   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov ax, 0b800h       ; set segment for CGA memory
   mov es, ax

   xor di, di           ; compute offset for line y0
   mov ax, [y0]

   shr ax, 1
   mov bx, 8191         ; also compute ydelta
   jnc line1_y_even
   mov bx, -8113
line1_y_even:
   mov cx, 0ffb0h
   sbb di, 0

   mov si, [ydiff]      ; fixups for +ve/-ve slope
   cmp si, 0
   jge line1_pos

   neg si
   sub bx, 80
   mov cx, 0c050h

line1_pos:

   push bx

   mov WORD PTR cs:[line1_patch10 + 2], cx
   mov WORD PTR cs:[line1_patch11 + 2], cx
   mov WORD PTR cs:[line1_patch12 + 2], cx
   mov WORD PTR cs:[line1_patch13 + 2], cx
   mov WORD PTR cs:[line1_patch14 + 2], cx
   mov WORD PTR cs:[line1_patch15 + 2], cx
            
   and di, 8192         ; continue computing offset for line y0
   mov cl, 4
   xor ah, ah        
   shl ax, cl
   add di, ax
   shl ax, 1
   shl ax, 1
   add di, ax

   mov bx, [xdiff]      ; compute 2*dx
   shl bx, 1
         
   shl si, 1            ; compute 2*dy

line1_yinc:

   mov dx, [D]          ; store D

   mov cx, [x0]         ; compute jump offset
   and cl, 3            ; multiply x mod 4 by 20
   shl cl, 1
   shl cl, 1
   mov al, cl
   shl cl, 1
   shl cl, 1
   add al, cl
   xor ah, ah
   mov ds, ax

   mov ah, [colour]     ; patch colours in
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch1 + 1], ah
   mov BYTE PTR cs:[line1_patch7 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch2 + 1], ah
   mov BYTE PTR cs:[line1_patch8 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch3 + 1], ah
   mov BYTE PTR cs:[line1_patch9 + 1], ah
   ror ah, 1
   ror ah, 1
   mov BYTE PTR cs:[line1_patch4 + 1], ah

   mov ax, [x0]         ; get x0

   shr ax, 1            ; adjust offset for column x0
   shr ax, 1
   add di, ax

   shl ax, 1            ; round x0 down to nearest multiple of 4
   shl ax, 1
   
   mov cx, [xend]       ; compute loop iterations
   sub cx, ax
   inc cx
   mov BYTE PTR cs:[line1_patch6 + 1], cl ; save iterations for prologue
   shr cx, 1
   shr cx, 1            ; we will unroll by 4 so divide by 4

   pop bp               ; get ydelta
   
   sub dx, si           ; compensate for first addition of 2*dy

   cli                  ; save and free up sp
   mov WORD PTR cs:[line1_patch5 + 1], sp
   mov sp, si

   mov ax, ds           ; get jump offset   
   mov si, ax
   mov al, es:[di]      ; get first word

   cmp cl, 0            ; check for iterations = 0
   je line1_no_iter

   lea si, si + line1_loop
   jmp si

line1_loop:
   and al, 03fh         
line1_patch1:
   or al, 040h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy1
 
   stosb                ; draw pixel

   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch10:
   xor bp, 1234         ; adjust ydelta

   sub dx, bx           ; D -= 2*dx

   mov al, es:[di]
line1_skip_incy1:

   and al, 0cfh
line1_patch2:
   or al, 010h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy2

   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch11:
   xor bp, 1234         ; adjust ydelta

   sub dx, bx           ; D -= 2*dx

   mov al, es:[di]
line1_skip_incy2:             

   and al, 0f3h
line1_patch3:
   or al, 04h
   add dx, sp           ; D += 2*dy

   jle line1_skip_incy3

   stosb                ; draw pixel(s)

   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch12:
   xor bp, 1234         ; adjust ydelta

   sub dx, bx           ; D -= 2*dx

   mov al, es:[di]
line1_skip_incy3:             

   and al, 0fch
line1_patch4:
   or al, 01h
   add dx, sp           ; D += 2*dy
   stosb
   
   jle line1_skip_incy4

   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch13:
   xor bp, 1234         ; adjust ydelta

   sub dx, bx           ; D -= 2*dx
   inc di
line1_skip_incy4:             
   mov al, es:[di]

   loop line1_loop

line1_no_iter:

line1_patch6:
   mov cl, 123          ; do remaining iterations (0-3)
   and cl, 03h

   cmp cl, 0
   je line1_done                   

   and al, 03fh         
line1_patch7:
   or al, 040h
   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line1_skip_incy5

   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch14:
   xor bp, 1234         ; adjust ydelta

   sub dx, bx           ; D -= 2*dx

   mov al, es:[di]
   inc di
line1_skip_incy5:
   dec di

   dec cl
   jz line1_done


   and al, 0cfh         
line1_patch8:
   or al, 010h
   add dx, sp           ; D += 2*dy

   stosb                ; draw pixel

   jle line1_skip_incy6
 
   add di, bp           ; odd <-> even line (reenigne's trick)
line1_patch15:
   xor bp, 1234        ; adjust ydelta

   sub dx, bx           ; D -= 2*dx

   mov al, es:[di]
   inc di
line1_skip_incy6:
   dec di

   dec cl
   jz line1_done


   and al, 0f3h         
line1_patch9:
   or al, 04h

   stosb                ; draw pixel

line1_done:

line1_patch5:
   mov sp, 1234
   sti
   
   pop ds
   pop si
   pop di
   pop bp
   ret
_cga_draw_line1 ENDP

   END

