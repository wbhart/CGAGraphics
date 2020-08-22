   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _poly_intersect
_poly_intersect PROC
   ARG buff:WORD, x1R:WORD, y1:WORD, inc1R:WORD, len1:WORD, x2L:WORD, x2R:WORD, y2:WORD, inc2L:WORD, inc2R:WORD, len2:WORD
   push bp
   mov bp, sp
   push di
   push si

   mov dx, [y1]
   mov bx, [y2]
   mov cx, bx
   sub cx, dx           ; which y comes first
   jae poly_intersect_adjust1

   mov di, [inc2L]
   add di, bx
   add bx, [inc2R]      ; will go in bp

   mov ax, [x1R]        ; compute differences
   mov dx, [x2L]
   sub dx, ax
   sub ax, [x2R]
   neg ax
   mov dh, al

   mov ah, BYTE PTR [len2] ; adjust len2
   add ah, cl

   mov al, BYTE PTR [len1]
   sub al, ah

   jg poly_intersect_force_prologue1
   add ah, al           ; main iterations in ah
   xor al, al           ; no prologue iterations

poly_intersect_force_prologue1:
   push ax              ; push prologue iterations (in al)

   neg cx               ; top adjust iterations

poly_intersect_adjust2_loop:
   inc di               ; skip to next inc
   inc bx

   add dl, [di]         ; apply increments from poly2
   add dh, [bx]
   loop poly_intersect_adjust2_loop

   mov cl, ah           ; get iterations (ch = 0 after loop)

   mov ax, [y1]
   mov si, [inc1R]
   add si, ax
   mov bp, [buff]
   add bp, ax
   xchg bp, bx 

   jmp poly_intersect_skip1


poly_intersect_adjust1:
   mov si, [inc1R]
   add si, dx
   mov bx, [buff]
   add bx, dx
   mov di, [x1R]

   mov dx, [len1]        ; adjust len1

   je poly_intersect_skip_adjust1

   sub dx, cx

poly_intersect_adjust1_loop:
   inc si                ; skip to next inc
   inc bx

   mov al, BYTE PTR [si] ; get increment
   mov BYTE PTR [bx], al ; copy out increments

   cbw                   ; sign extend
   add di, ax            ; increment x1R
   loop poly_intersect_adjust1_loop

poly_intersect_skip_adjust1:

   mov ax, [x2L]         ; adjusted len1 in al
   xchg ax, dx

   sub dx, di            ; compute differences
   mov cx, [x2R]
   sub cx, di
   mov dh, cl

   mov ah, BYTE PTR [len2]
   sub al, ah
   jg poly_intersect_force_prologue2
   add ah, al
   xor al, al           ; no prologue iterations

poly_intersect_force_prologue2:
   push ax              ; push prologue iterations (in al)
                        ; main iterations are in ah

   xor ch, ch

   mov cl, ah           ; get iterations

   mov ax, [y2]
   mov di, [inc2L]
   add di, ax
   mov bp, [inc2R]
   add bp, ax




poly_intersect_skip1:

   cmp cx, 0
   jnz poly_intersect_inc1_loop
   jmp prologue


poly_intersect_inc1_start1:
   add dh, BYTE PTR [bp]         ; add inc2R
   sub dh, ah                    ; sub inc1R

poly_intersect_inc1_start2:
   mov BYTE PTR [bx], dl         ; write out shift to poly1

   dec cx
   jz prologue

poly_intersect_inc1_loop:
   inc di             ; move to next incs
   inc si
   inc bp
   inc bx 

   mov al, BYTE PTR [di]
   add dl, al         ; add inc2L

   mov ah, BYTE PTR [si]
   sub dl, ah         ; sub inc1R
   js poly_intersect_inc1_check

   add dh, BYTE PTR [bp] ; add inc2R

   sub dh, ah         ; sub inc1R
   
   mov BYTE PTR [bx], ah         ; write out inc1R

   loop poly_intersect_inc1_loop
   jmp prologue

poly_intersect_inc1_check:
   add dh, BYTE PTR [bp]         ; add inc2R

   sub dh, ah         ; sub inc1R

   jns poly_intersect_inc2_start

   mov BYTE PTR [bx], ah         ; write out inc1R

   loop poly_intersect_inc1_loop
   jmp prologue



poly_intersect_inc2_start:
   mov BYTE PTR [bx], dl        ; write out shift to poly2

   dec cx
   jz prologue

poly_intersect_inc2_loop:
   inc di               ; move to next increment
   inc si
   inc bp
   inc bx

   mov al, BYTE PTR [di]
   add dl, al         ; add inc2L

   mov ah, BYTE PTR [si]
   sub dl, ah         ; sub inc1R
   jns poly_intersect_inc1_start1
   
   add dh, BYTE PTR [bp] ; add inc2R
   sub dh, ah         ; sub inc1R
   js poly_intersect_inc1_start2
   
   mov BYTE PTR [bx], al         ; write out inc2L
   loop poly_intersect_inc2_loop


prologue:

   pop cx              ; pop iterations
   xor ch, ch

   cmp cx, 0
   je poly_intersect_done

poly_intersect_prologue_loop:
   inc si               ; move to next inc
   inc bx
   
   mov al, BYTE PTR [si] ; write out inc1R
   mov BYTE PTR [bx], al

   loop poly_intersect_prologue_loop

poly_intersect_done:

   pop si
   pop di
   pop bp
   ret
_poly_intersect ENDP

   END