   DOSSEG
   .MODEL small
   .DATA

   line_offset DW 0, 80, 160, 240, 320, 400, 480, 560, 640, 720
               DW 800, 880, 960, 1040, 1120, 1200, 1280, 1360, 1440, 1520
               DW 1600, 1680, 1760, 1840, 1920, 2000, 2080, 2160, 2240, 2320
               DW 2400, 2480, 2560, 2640, 2720, 2800, 2880, 2960, 3040, 3120
               DW 3200, 3280, 3360, 3440, 3520, 3600, 3680, 3760, 3840, 3920
               DW 4000, 4080, 4160, 4240, 4320, 4400, 4480, 4560, 4640, 4720
               DW 4800, 4880, 4960, 5040, 5120, 5200, 5280, 5360, 5440, 5520
               DW 5600, 5680, 5760, 5840, 5920, 6000, 6080, 6160, 6240, 6320
               DW 6400, 6480, 6560, 6640, 6720, 6800, 6880, 6960, 7040, 7120
               DW 7200, 7280, 7360, 7440, 7520, 7600, 7680, 7760, 7840, 7920

   masks1 DW 0ff00h, 03f00h, 0f00h, 0300h, 0ff01h, 03f01h, 0f01h, 0301h
          DW 0ff02h, 03f02h, 0f02h, 0302h, 0ff03h, 03f03h, 0f03h, 0303h
          DW 0ff04h, 03f04h, 0f04h, 0304h, 0ff05h, 03f05h, 0f05h, 0305h
          DW 0ff06h, 03f06h, 0f06h, 0306h, 0ff07h, 03f07h, 0f07h, 0307h
          DW 0ff08h, 03f08h, 0f08h, 0308h, 0ff09h, 03f09h, 0f09h, 0309h
          DW 0ff0ah, 03f0ah, 0f0ah, 030ah, 0ff0bh, 03f0bh, 0f0bh, 030bh
          DW 0ff0ch, 03f0ch, 0f0ch, 030ch, 0ff0dh, 03f0dh, 0f0dh, 030dh
          DW 0ff0eh, 03f0eh, 0f0eh, 030eh, 0ff0fh, 03f0fh, 0f0fh, 030fh
          DW 0ff10h, 03f10h, 0f10h, 0310h, 0ff11h, 03f11h, 0f11h, 0311h
          DW 0ff12h, 03f12h, 0f12h, 0312h, 0ff13h, 03f13h, 0f13h, 0313h
          DW 0ff14h, 03f14h, 0f14h, 0314h, 0ff15h, 03f15h, 0f15h, 0315h
          DW 0ff16h, 03f16h, 0f16h, 0316h, 0ff17h, 03f17h, 0f17h, 0317h
          DW 0ff18h, 03f18h, 0f18h, 0318h, 0ff19h, 03f19h, 0f19h, 0319h
          DW 0ff1ah, 03f1ah, 0f1ah, 031ah, 0ff1bh, 03f1bh, 0f1bh, 031bh
          DW 0ff1ch, 03f1ch, 0f1ch, 031ch, 0ff1dh, 03f1dh, 0f1dh, 031dh
          DW 0ff1eh, 03f1eh, 0f1eh, 031eh, 0ff1fh, 03f1fh, 0f1fh, 031fh
          DW 0ff20h, 03f20h, 0f20h, 0320h, 0ff21h, 03f21h, 0f21h, 0321h
          DW 0ff22h, 03f22h, 0f22h, 0322h, 0ff23h, 03f23h, 0f23h, 0323h
          DW 0ff24h, 03f24h, 0f24h, 0324h, 0ff25h, 03f25h, 0f25h, 0325h
          DW 0ff26h, 03f26h, 0f26h, 0326h, 0ff27h, 03f27h, 0f27h, 0327h
          DW 0ff28h, 03f28h, 0f28h, 0328h, 0ff29h, 03f29h, 0f29h, 0329h
          DW 0ff2ah, 03f2ah, 0f2ah, 032ah, 0ff2bh, 03f2bh, 0f2bh, 032bh
          DW 0ff2ch, 03f2ch, 0f2ch, 032ch, 0ff2dh, 03f2dh, 0f2dh, 032dh
          DW 0ff2eh, 03f2eh, 0f2eh, 032eh, 0ff2fh, 03f2fh, 0f2fh, 032fh
          DW 0ff30h, 03f30h, 0f30h, 0330h, 0ff31h, 03f31h, 0f31h, 0331h
          DW 0ff32h, 03f32h, 0f32h, 0332h, 0ff33h, 03f33h, 0f33h, 0333h
          DW 0ff34h, 03f34h, 0f34h, 0334h, 0ff35h, 03f35h, 0f35h, 0335h
          DW 0ff36h, 03f36h, 0f36h, 0336h, 0ff37h, 03f37h, 0f37h, 0337h
          DW 0ff38h, 03f38h, 0f38h, 0338h, 0ff39h, 03f39h, 0f39h, 0339h
          DW 0ff3ah, 03f3ah, 0f3ah, 033ah, 0ff3bh, 03f3bh, 0f3bh, 033bh
          DW 0ff3ch, 03f3ch, 0f3ch, 033ch, 0ff3dh, 03f3dh, 0f3dh, 033dh
          DW 0ff3eh, 03f3eh, 0f3eh, 033eh, 0ff3fh, 03f3fh, 0f3fh, 033fh

   masks2 DW 0c000h, 0f000h, 0fc00h, 0ff00h, 0c001h, 0f001h, 0fc01h, 0ff01h
          DW 0c002h, 0f002h, 0fc02h, 0ff02h, 0c003h, 0f003h, 0fc03h, 0ff03h
          DW 0c004h, 0f004h, 0fc04h, 0ff04h, 0c005h, 0f005h, 0fc05h, 0ff05h
          DW 0c006h, 0f006h, 0fc06h, 0ff06h, 0c007h, 0f007h, 0fc07h, 0ff07h
          DW 0c008h, 0f008h, 0fc08h, 0ff08h, 0c009h, 0f009h, 0fc09h, 0ff09h
          DW 0c00ah, 0f00ah, 0fc0ah, 0ff0ah, 0c00bh, 0f00bh, 0fc0bh, 0ff0bh
          DW 0c00ch, 0f00ch, 0fc0ch, 0ff0ch, 0c00dh, 0f00dh, 0fc0dh, 0ff0dh
          DW 0c00eh, 0f00eh, 0fc0eh, 0ff0eh, 0c00fh, 0f00fh, 0fc0fh, 0ff0fh
          DW 0c010h, 0f010h, 0fc10h, 0ff10h, 0c011h, 0f011h, 0fc11h, 0ff11h
          DW 0c012h, 0f012h, 0fc12h, 0ff12h, 0c013h, 0f013h, 0fc13h, 0ff13h
          DW 0c014h, 0f014h, 0fc14h, 0ff14h, 0c015h, 0f015h, 0fc15h, 0ff15h
          DW 0c016h, 0f016h, 0fc16h, 0ff16h, 0c017h, 0f017h, 0fc17h, 0ff17h
          DW 0c018h, 0f018h, 0fc18h, 0ff18h, 0c019h, 0f019h, 0fc19h, 0ff19h
          DW 0c01ah, 0f01ah, 0fc1ah, 0ff1ah, 0c01bh, 0f01bh, 0fc1bh, 0ff1bh
          DW 0c01ch, 0f01ch, 0fc1ch, 0ff1ch, 0c01dh, 0f01dh, 0fc1dh, 0ff1dh
          DW 0c01eh, 0f01eh, 0fc1eh, 0ff1eh, 0c01fh, 0f01fh, 0fc1fh, 0ff1fh
          DW 0c020h, 0f020h, 0fc20h, 0ff20h, 0c021h, 0f021h, 0fc21h, 0ff21h
          DW 0c022h, 0f022h, 0fc22h, 0ff22h, 0c023h, 0f023h, 0fc23h, 0ff23h
          DW 0c024h, 0f024h, 0fc24h, 0ff24h, 0c025h, 0f025h, 0fc25h, 0ff25h
          DW 0c026h, 0f026h, 0fc26h, 0ff26h, 0c027h, 0f027h, 0fc27h, 0ff27h
          DW 0c028h, 0f028h, 0fc28h, 0ff28h, 0c029h, 0f029h, 0fc29h, 0ff29h
          DW 0c02ah, 0f02ah, 0fc2ah, 0ff2ah, 0c02bh, 0f02bh, 0fc2bh, 0ff2bh
          DW 0c02ch, 0f02ch, 0fc2ch, 0ff2ch, 0c02dh, 0f02dh, 0fc2dh, 0ff2dh
          DW 0c02eh, 0f02eh, 0fc2eh, 0ff2eh, 0c02fh, 0f02fh, 0fc2fh, 0ff2fh
          DW 0c030h, 0f030h, 0fc30h, 0ff30h, 0c031h, 0f031h, 0fc31h, 0ff31h
          DW 0c032h, 0f032h, 0fc32h, 0ff32h, 0c033h, 0f033h, 0fc33h, 0ff33h
          DW 0c034h, 0f034h, 0fc34h, 0ff34h, 0c035h, 0f035h, 0fc35h, 0ff35h
          DW 0c036h, 0f036h, 0fc36h, 0ff36h, 0c037h, 0f037h, 0fc37h, 0ff37h
          DW 0c038h, 0f038h, 0fc38h, 0ff38h, 0c039h, 0f039h, 0fc39h, 0ff39h
          DW 0c03ah, 0f03ah, 0fc3ah, 0ff3ah, 0c03bh, 0f03bh, 0fc3bh, 0ff3bh
          DW 0c03ch, 0f03ch, 0fc3ch, 0ff3ch, 0c03dh, 0f03dh, 0fc3dh, 0ff3dh
          DW 0c03eh, 0f03eh, 0fc3eh, 0ff3eh, 0c03fh, 0f03fh, 0fc3fh, 0ff3fh

   .CODE

   diffs DW 0     

   PUBLIC _cga_poly_fill
_cga_poly_fill PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE, retlr:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i].
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov dl, [colour]     ; put solid colour in dl

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_fill_even_y
   add di, 8192
   ror dl, 1            ; adjust colour pattern for odd line
   ror dl, 1
poly_fill_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_fill_patch1 + 2], ax
   mov WORD PTR cs:[poly_fill_patch2 + 2], ax
   
   mov ax, [x1]
   mov cx, [x2]
   dec cx               ; rightmost pixel is not drawn


   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                         ; first line is not drawn

   push bp
   mov bp, ax

poly_fill_long_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_patch1:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, ah
   mov cx, [bx+masks2]
   mov bl, al
   mov bx, [bx+masks1]

   sub cl, bl           ; get diff of offsets
   jbe poly_fill_short
poly_fill_long:

   xchg bl, ch
   mov ax, bx
   and bl, dl
   and bh, dl

   xchg bx, di
   not ax

   add bl, ch
   adc bh, 0

   and ah, es:[bx]      ; low pixel byte

   add bl, cl           ; switch to high offset
   adc bh, 0
   
   and al, es:[bx]      ; high pixel byte

   or ax, di

   mov es:[bx], al      ; put pixel bytes back

   sub bl, cl
   sbb bh, 0

   mov es:[bx], ah

   mov di, bx
   sub bl, ch
   sbb bh, 0
   xor ch, ch

   mov al, dl           ; prepare colour and iterations
   mov ah, dl
   inc di
   dec cx

   shr cx, 1            ; write out full byte and words
   jnc poly_fill_long_even
   stosb
poly_fill_long_even:
   rep stosw

   mov di, bx           ; restore di

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_long_loop

   jmp poly_fill_end

poly_fill_short_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_patch2:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, ah
   mov cx, [bx+masks2]
   mov bl, al
   mov bx, [bx+masks1]

   sub cl, bl           ; get diff of offsets
   ja poly_fill_long
poly_fill_short:
   jb poly_fill_short_skip

   and bh, ch
   mov ah, bh
   mov al, ah
   not al
   and ah, dl

   xor bh, bh
   add bx, di

   and al, es:[bx]      ; high pixel byte

   or al, ah

   mov es:[bx], al      ; put pixel bytes back

poly_fill_short_skip:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_short_loop

poly_fill_end:
   mov ax, bp
   pop bp
   cmp [retlr], 0
   je poly_fill_short_l
   xchg al, ah
   inc al               ; compensate for the dec cx at the beginning
poly_fill_short_l:

   pop si
   pop di
   pop bp
   ret
_cga_poly_fill ENDP

   PUBLIC _cga_poly_fill_left
_cga_poly_fill_left PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE, retlr:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i]. Blank pixels to the
   ; left of the polygon in any bytes written there.
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov dl, [colour]     ; put solid colour in dl

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_fill_left_even_y
   add di, 8192
   ror dl, 1            ; adjust colour pattern for odd line
   ror dl, 1
poly_fill_left_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_fill_left_patch1 + 2], ax
   mov WORD PTR cs:[poly_fill_left_patch2 + 2], ax
   
   mov ax, [x1]
   mov cx, [x2]
   dec cx               ; rightmost pixel is not drawn


   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                         ; first line is not drawn

   push bp
   mov bp, ax

poly_fill_left_long_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_left_patch1:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, al
   mov cx, [bx+masks1]
   mov bl, ah
   mov bx, [bx+masks2]

   sub cl, bl           ; get diff of offsets
   jae poly_fill_left_short
poly_fill_left_long:
   
   neg cl
   
   xchg bl, ch
   mov ax, bx
   and bl, dl
   and bh, dl

   xchg bx, di
   not ax

   add bl, ch           ; switch to high offset
   adc bh, 0

   and ah, es:[bx]      ; high pixel byte
   
   xor al, al
   
   or ax, di

   mov es:[bx], ah      ; put pixel bytes back

   sub bl, cl           ; switch to low offset
   sbb bh, 0

   mov di, bx
   
   stosb

   sub ch, cl

   sub bl, ch           ; restore di
   sbb bh, 0   

   xor ch, ch

   mov al, dl           ; prepare colour and iterations
   mov ah, dl
   dec cx

   shr cx, 1            ; write out full byte and words
   jnc poly_fill_left_long_even
   stosb
poly_fill_left_long_even:
   rep stosw

   mov di, bx           ; restore di

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_left_long_loop

   jmp poly_fill_left_end

poly_fill_left_short_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_left_patch2:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, al
   mov cx, [bx+masks1]
   mov bl, ah
   mov bx, [bx+masks2]

   sub cl, bl           ; get diff of offsets
   jb poly_fill_left_long
poly_fill_left_short:
   ja poly_fill_left_short_skip

   mov al, bh
   and bh, ch
   mov ah, bh
   not al
   and ah, dl

   xor bh, bh
   add bx, di

   and al, es:[bx]      ; high pixel byte

   or al, ah

   mov es:[bx], al      ; put pixel bytes back

poly_fill_left_short_skip:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_left_short_loop

poly_fill_left_end:
   mov ax, bp
   pop bp
   cmp [retlr], 0
   je poly_fill_left_short_l
   xchg al, ah
   inc al               ; compensate for the dec cx at the beginning
poly_fill_left_short_l:

   pop si
   pop di
   pop bp
   ret
_cga_poly_fill_left ENDP

   PUBLIC _cga_poly_fill_right
_cga_poly_fill_right PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE, retlr:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i]. Blank pixels to the
   ; right of the polygon in any bytes written there.
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov dl, [colour]     ; put solid colour in dl

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_fill_right_even_y
   add di, 8192
   ror dl, 1            ; adjust colour pattern for odd line
   ror dl, 1
poly_fill_right_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_fill_right_patch1 + 2], ax
   mov WORD PTR cs:[poly_fill_right_patch2 + 2], ax
   
   mov ax, [x1]
   mov cx, [x2]
   dec cx               ; rightmost pixel is not drawn


   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                         ; first line is not drawn

   push bp
   mov bp, ax
   std

poly_fill_right_long_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_right_patch1:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, ah
   mov cx, [bx+masks2]
   mov bl, al
   mov bx, [bx+masks1]

   sub cl, bl           ; get diff of offsets
   jbe poly_fill_right_short
poly_fill_right_long:
   
   xchg bl, ch
   mov ax, bx
   and bl, dl
   and bh, dl

   xchg bx, di
   not ax

   add bl, ch           ; switch to low offset
   adc bh, 0

   and ah, es:[bx]      ; low pixel byte
   
   xor al, al
   
   or ax, di

   mov es:[bx], ah      ; put pixel bytes back

   add bl, cl           ; switch to high offset
   adc bh, 0

   mov di, bx

   stosb

   add ch, cl

   sub bl, ch           ; restore di
   sbb bh, 0   

   xor ch, ch

   mov al, dl           ; prepare colour and iterations
   mov ah, dl
   dec di
   dec cx

   shr cx, 1            ; write out full byte and words
   rep stosw
   jnc poly_fill_right_long_even
   inc di
   stosb
poly_fill_right_long_even:

   mov di, bx           ; restore di

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_right_long_loop

   jmp poly_fill_right_end

poly_fill_right_short_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_right_patch2:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, ah
   mov cx, [bx+masks2]
   mov bl, al
   mov bx, [bx+masks1]

   sub cl, bl           ; get diff of offsets
   ja poly_fill_right_long
poly_fill_right_short:
   jb poly_fill_right_short_skip

   mov al, bh
   and bh, ch
   mov ah, bh
   not al
   and ah, dl

   xor bh, bh
   add bx, di

   and al, es:[bx]      ; low pixel byte

   or al, ah

   mov es:[bx], al      ; put pixel bytes back

poly_fill_right_short_skip:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_right_short_loop

poly_fill_right_end:
   mov ax, bp
   pop bp
   cmp [retlr], 0
   je poly_fill_right_short_l
   xchg al, ah
   inc al               ; compensate for the dec cx at the beginning
poly_fill_right_short_l:

   cld

   pop si
   pop di
   pop bp
   ret
_cga_poly_fill_right ENDP

   PUBLIC _cga_poly_fill_both
_cga_poly_fill_both PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE, retlr:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i]. Blank pixels to
   ; both sides of the polygon in any bytes written there.
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov dl, [colour]     ; put solid colour in dl

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_fill_both_even_y
   add di, 8192
   ror dl, 1            ; adjust colour pattern for odd line
   ror dl, 1
poly_fill_both_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_fill_both_patch1 + 2], ax
   mov WORD PTR cs:[poly_fill_both_patch2 + 2], ax
   
   mov ax, [x1]
   mov cx, [x2]
   dec cx               ; rightmost pixel is not drawn


   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                         ; first line is not drawn

   push bp
   mov bp, ax

poly_fill_both_long_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_both_patch1:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, al
   mov cx, [bx+masks1]
   mov bl, ah
   mov bx, [bx+masks2]

   sub cl, bl           ; get diff of offsets
   jae poly_fill_both_short
poly_fill_both_long:
   
   neg cl
   
   xchg bl, ch
   and bl, dl
   and bh, dl
   mov ax, bx

   mov bx, di

   add bl, ch           ; switch to high offset
   adc bh, 0

   mov es:[bx], ah      ; put pixel bytes in

   sub bl, cl           ; switch to low offset
   sbb bh, 0

   mov di, bx

   stosb

   sub ch, cl

   sub bl, ch           ; restore di
   sbb bh, 0   

   xor ch, ch

   mov al, dl           ; prepare colour and iterations
   mov ah, dl
   dec cx

   shr cx, 1            ; write out full byte and words
   jnc poly_fill_both_long_even
   stosb
poly_fill_both_long_even:
   rep stosw

   mov di, bx           ; restore di

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_both_long_loop

   jmp poly_fill_both_end

poly_fill_both_short_loop:
   inc si
   mov ax, bp   ; update diffs
   add al, [si]
poly_fill_both_patch2:
   add ah, [si+200]
   mov bp, ax

   xor bh, bh
   shl ax, 1             ; get masks and offsets
   mov bl, al
   mov cx, [bx+masks1]
   mov bl, ah
   mov bx, [bx+masks2]

   sub cl, bl           ; get diff of offsets
   jb poly_fill_both_long
poly_fill_both_short:
   ja poly_fill_both_short_skip

   and bh, ch
   mov ah, bh
   and ah, dl

   xor bh, bh
   add bx, di

   mov es:[bx], ah      ; put pixel bytes back

poly_fill_both_short_skip:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   ror dl, 1            ; rotate colour
   ror dl, 1

   dec dh
   jnz poly_fill_both_short_loop

poly_fill_both_end:
   mov ax, bp
   pop bp
   cmp [retlr], 0
   je poly_fill_both_short_l
   xchg al, ah
   inc al               ; compensate for the dec cx at the beginning
poly_fill_both_short_l:

   pop si
   pop di
   pop bp
   ret
_cga_poly_fill_both ENDP

   PUBLIC _cga_poly_blank_left
_cga_poly_blank_left PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i] with zeros,
   ; not being too particular about the left side (for performance
   ; reasons, i.e. fill to the next byte boundary) and only writing the
   ; rightmost byte if it is up against a byte boundary.
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_blank_left_even_y
   add di, 8192
poly_blank_left_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_blank_left_patch1 + 2], ax
   mov WORD PTR cs:[poly_blank_left_patch2 + 2], ax
   
   mov ax, [x1]
   mov cx, [x2]
                        ; rightmost pixel is not drawn
                        ; but we adjust for this elsewhere

   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl           ; put starting points in diffs global
   mov cs:[diffs], ax

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                        ; first line is not drawn

   xor bh, bh           ; routine expects bh = 0 throughout

poly_blank_left_long_loop:
   inc si
   mov ax, cs:[diffs]   ; update diffs
   add al, [si]
poly_blank_left_patch1:
   add ah, [si+200]
   mov cs:[diffs], ax

   shr ah, 1            ; compute offsets
   shr ah, 1
   mov cl, ah
   shr al, 1
   shr al, 1

   sub cl, al           ; get diff of offsets, don't draw right byte
   jb poly_blank_left_short
poly_blank_left_long:

   mov bl, al           ; bx = low offset

   add di, bx

   xor ax, ax           ; zeros to be written

   mov bp, cx           ; save diff of offsets

   shr cx, 1            ; write out full byte and words
   jnc poly_blank_left_long_even
   stosb
poly_blank_left_long_even:
   rep stosw

   sub di, bp           ; restore di
   sub di, bx

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   dec dh
   jnz poly_blank_left_long_loop

   pop si
   pop di
   pop bp
   ret

poly_blank_left_short_loop:
   inc si
   mov ax, cs:[diffs]   ; update diffs
   add al, [si]
poly_blank_left_patch2:
   add ah, [si+200]
   mov cs:[diffs], ax

   shr al, 1            ; compute offsets
   shr al, 1
   shr ah, 1
   shr ah, 1
   mov cl, ah

   sub cl, al           ; get diff of offsets
   jae poly_blank_left_long
poly_blank_left_short:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   dec dh
   jnz poly_blank_left_short_loop

   pop si
   pop di
   pop bp
   ret
_cga_poly_blank_left ENDP

   PUBLIC _cga_poly_blank_right
_cga_poly_blank_right PROC
   ARG buff:DWORD, x1:WORD, x2:WORD, y:WORD, inc1:WORD, inc2:WORD, len:WORD, minx:WORD, colour:BYTE
   ; fill a polygon with top points at (x1, y) and (x2, y) with
   ; increments in the x direction in inc1[i] and inc2[i] with zeros,
   ; not being too particular about the right side (for performance
   ; reasons, i.e. fill to the next byte boundary) and only writing the
   ; leftmost byte if it is up against a byte boundary.
   ; Negative and zero spans are ignored. Rightmost pixels and the
   ; first span, at line y, are omitted.
   push bp
   mov bp, sp
   push di
   push si

   les di, buff         ; get buffer address in es:di

   mov bx, [y]          ; adjust offset of CGA bank (odd/even)
   shr bx, 1
   jnc poly_blank_right_even_y
   add di, 8192
poly_blank_right_even_y:

   shl bx, 1            ; adjust offset for line y
   add di, [bx+line_offset]

   mov si, [inc1]       ; get addresses of increments buffers
   mov ax, [inc2]
   sub ax, si
   
   mov WORD PTR cs:[poly_blank_right_patch1 + 2], ax
   mov WORD PTR cs:[poly_blank_right_patch2 + 2], ax
   
   mov ax, [x1]
   dec ax               ; leftmost byte not drawn unless up against byte boundary
   mov cx, [x2]
   dec cx               ; rightmost pixel is not drawn

   mov bx, [minx]       ; adjust so diffs are in range
   and bl, 0fch
   sub ax, bx
   sub cx, bx
   shr bx, 1
   shr bx, 1
   add di, bx

   mov ah, cl           ; put starting points in diffs global
   mov cs:[diffs], ax

   mov dh, BYTE PTR [len] ; get number of horizontal lines
                        ; first line is not drawn

   xor bh, bh           ; routine expects bh = 0 throughout

poly_blank_right_long_loop:
   inc si
   mov ax, cs:[diffs]   ; update diffs
   add al, [si]
poly_blank_right_patch1:
   add ah, [si+200]
   mov cs:[diffs], ax

   shr ah, 1            ; compute offsets
   shr ah, 1
   mov cl, ah
   shr al, 1
   shr al, 1

   sub cl, al           ; get diff of offsets
   jb poly_blank_right_short
poly_blank_right_long:

   mov bl, al           ; bx = low offset

   inc bx               ; don't draw left byte
   add di, bx

   xor ax, ax           ; zeros to be written

   mov bp, cx           ; save diff of offsets

   shr cx, 1            ; write out full byte and words
   jnc poly_blank_right_long_even
   stosb
poly_blank_right_long_even:
   rep stosw

   sub di, bp           ; restore di
   sub di, bx

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   dec dh
   jnz poly_blank_right_long_loop

   pop si
   pop di
   pop bp
   ret

poly_blank_right_short_loop:
   inc si
   mov ax, cs:[diffs]   ; update diffs
   add al, [si]
poly_blank_right_patch2:
   add ah, [si+200]
   mov cs:[diffs], ax

   shr al, 1            ; compute offsets
   shr al, 1
   shr ah, 1
   shr ah, 1
   mov cl, ah

   sub cl, al           ; get diff of offsets
   jae poly_blank_right_long
poly_blank_right_short:

   sub di, 8112         ; increment y
   sbb ax, ax
   and ax, 16304
   add di, ax

   dec dh
   jnz poly_blank_right_short_loop

   pop si
   pop di
   pop bp
   ret
_cga_poly_blank_right ENDP

   END
