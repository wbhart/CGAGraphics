	DOSSEG
	.MODEL small
	.CODE
	PUBLIC _cga_draw_pixel

_cga_draw_pixel PROC
	ARG x:WORD, y:WORD, colour:BYTE
	push bp
	mov bp, sp
        push di
	mov ax, 0b800h
	mov es, ax
	mov ax, [y]
	xor di, di
        shr al, 1
	sbb di, 0
        and di, 2000h
	shl ax, 1
        shl ax, 1
        shl ax, 1
        shl ax, 1
        mov bx, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        add di, bx
	mov ax, [x]
	mov cl, al
	shr ax, 1
        shr ax, 1
	add di, ax
	inc cl
        and cl, 3
        shl cl, 1
	mov dl, [colour]
	ror dl, cl
        mov al, 0fch
        ror al, cl
	and al, es:[di]
	or al, dl
	stosb
        pop di
	pop bp
	ret
_cga_draw_pixel ENDP

	PUBLIC _cga_set_y
_cga_set_y PROC
	ARG y:WORD
	push bp
	mov bp, sp
        mov dx, 0b800h
	mov ax, [y]
	xor bh, bh
        shr al, 1
	sbb bh, 0
        and bh, 02h
	xor dh, bh
        mov bx, ax
        shl ax, 1
        shl ax, 1
        add ax, dx
        add ax, bx
	mov es, ax
        pop bp
        ret
_cga_set_y ENDP

	PUBLIC _cga_draw_pixel_x
_cga_draw_pixel_x PROC
	ARG x:WORD, colour:BYTE
	push bp
	mov bp, sp
        push di
	mov ax, [x]
	mov cl, al
	shr ax, 1
        shr ax, 1
	mov di, ax
	inc cl
        and cl, 3
        shl cl, 1
	mov dl, [colour]
	ror dl, cl
        mov al, 0fch
        ror al, cl
	and al, es:[di]
	or al, dl
	stosb
        pop di
        pop bp
        ret
_cga_draw_pixel_x ENDP

        PUBLIC _cga_draw_hline
_cga_draw_hline PROC
	ARG x0:WORD, x1:WORD, y:WORD, colour:BYTE
	; line from (x0, y) - (x1, y) including endpoints
        push bp
	mov bp, sp
        push di
        mov dx, 0b800h
	mov ax, [y]
	xor bh, bh
        shr al, 1
        sbb bh, 0
	and bh, 02h
	xor dh, bh
        mov bx, ax
        shl ax, 1
        shl ax, 1
        add ax, dx
        add ax, bx
	mov es, ax
        mov ax, [x0]
        mov cl, al
        and cl, 3
        shl cl, 1
        mov dx, [x1]
        mov bl, dl
        and bl, 3
        shl bl, 1
        shr ax, 1
        shr ax, 1
        shr dx, 1
        shr dx, 1
        mov di, ax
        sub dl, al
        mov al, [colour]
        mov ah, al
        shl al, 1
        shl al, 1
        add ah, al
        mov al, ah
        shl al, 1
        shl al, 1
        shl al, 1
        shl al, 1
        add ah, al
        dec dl
        jns hline_long_line
        mov al, 0ffh
        shr al, cl
        mov cl, bl
        mov bl, 03fh
        shr bl, cl
        not bl
        and bl, al
        mov al, ah
        or al, bl
        not bl
        and bl, es:[di]
        or al, bl
        stosb
        pop di
        pop bp
        ret
hline_long_line:
        mov bh, 0ffh
        shr bh, cl        
        mov al, ah
        and al, bh
        not bh
        and bh, es:[di]
        or al, bh
        stosb
        mov al, ah
        mov cx, dx
        rep stosb
        mov cl, bl
        mov bl, 03fh
        shr bl, cl
        not bl
        mov al, ah
        and al, bl
        not bl
        and bl, es:[di]
        or al, bl
        stosb  
        pop di
        pop bp
        ret
_cga_draw_hline ENDP

        PUBLIC _cga_draw_vline
_cga_draw_vline PROC
	ARG x:WORD, y0:WORD, y1:WORD, colour:BYTE
	; line from (x, y0) - (x, y1) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h      ; set segment reg to B800
        mov es, ax
        mov ax, [y0]        ; y0 coordinate
        mov bx, ax
        inc al              
        shr al, 1           ; (y0 + 1)/2
        shr bl, 1           ; y0/2
        shl ax, 1
        shl ax, 1
        shl ax, 1
        shl ax, 1
        mov di, ax          
        shl ax, 1
        shl ax, 1
        add di, ax          ; offset 80*(y0 + 1)/2 = first even line
        shl bx, 1
        shl bx, 1
        shl bx, 1
        shl bx, 1
        mov dx, bx
        shl bx, 1
        shl bx, 1
        add bx, dx          ; offset 8192 + 80*(y0/2) = first odd line
        mov ax, [y1]        ; y1 coordinate
        xor ch, ch
        shr ax, 1           ; y1/2
        sbb ch, 0           
        not ch
        and ch, 80          ; ch = 80 if y1 even, else ch = 0
        shl ax, 1
        shl ax, 1
        shl ax, 1
        shl ax, 1
        mov dx, ax
        shl ax, 1
        shl ax, 1
        add dx, ax          ; offset 80*(y1/2)
        mov ax, [x]         ; x coordinate
        mov cl, al
        shr ax, 1
        shr ax, 1           ; compute byte of pixel at coord x
        add di, ax          ; add it to offset of first even line
        add dx, ax          ; add it to offset of y1 line
        add bx, ax          ; add it to offset of first odd line
        mov ah, [colour]
        inc cl
        and al, 3
        shl cl, 1
        ror ah, cl          ; shift colour into correct bitfield
        mov al, 0fch        
        ror al, cl          
        mov si, 79          ; si = number of bytes to increase offset by when moving to next line = 80 - 1
        mov cl, al          ; shift mask into correct bitfield in cl
vline_even:
        cmp di, dx          ; display pixels on even lines (unroll by 2)
        ja vline_done_even  ; check if done
        mov al, cl
        and al, es:[di]
        or al, ah
        stosb               ; write pixel
        add di, si          ; jump to next even line
        cmp di, dx
        ja vline_done_even  ; check if done
        mov al, cl
        and al, es:[di]
        or al, ah
        stosb               ; write pixel
        add di, si          ; jump to next even line
        jmp vline_even      ; loop
vline_done_even:
        mov di, bx          ; load offset of first odd line
        xor dh, 20h         ; update y1 offset to an odd line
        sub dl, ch          ; adjust by one odd line if last line is even
        sbb dh, 0
vline_odd:
        cmp di, dx          ; display pixels on odd lines (unroll by 2)
        ja vline_done_odd   ; check if done
        mov al, cl
        and al, es:[di]
        or al, ah
        stosb               ; write pixel
        add di, si          ; jump to next odd line
        cmp di, dx
        ja vline_done_odd   ; check if done
        mov al, cl
        and al, es:[di]
        or al, ah
        stosb               ; write pixel
        add di, si          ; jump to next odd line
        jmp vline_odd       ; loop
vline_done_odd:    
        pop si
        pop di
        pop bp
        ret
_cga_draw_vline ENDP

        PUBLIC _cga_draw_line1
_cga_draw_line1 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
	; line from (x0, y0) - (xend, ?) including endpoints
        push bp
	mov bp, sp
        push ds
        push di
        push si
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        mov bx, 8192
        jnc line1_y_even
        mov bx, -8112
line1_y_even:
        push bx
        pop ds
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax

        mov bx, [x0]
        mov ax, [xend]
        sub ax, bx
        inc ax
        push ax
        shr ax, 1
        push bp
        push ax
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, dx

        pop bp
        cmp bp, 0
        je line1_end2

        cli
        mov WORD PTR cs:[line1_end2+1], sp
        mov ax, ds
        mov sp, ax
line1_begin2:
        add si, dx
        jg line1_Dgt0_1
        mov al, cl
        ror cl, 1
        ror cl, 1
        jnc line1_ine3
        and al, cl
        and al, es:[di]
        or al, ch
        ror ch, 1
        ror ch, 1
        jmp line1_Dcmp_end_1
line1_ine3:
        and al, es:[di]
        or al, ch
        stosb
        ror ch, 1
        ror ch, 1
        mov al, cl
        and al, es:[di]
        jmp line1_Dcmp_end_1
line1_Dgt0_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, sp
        xor sp, -16304
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        sbb di, 0
        mov al, cl
        and al, es:[di]
        sub si, bx        
line1_Dcmp_end_1:
        or al, ch
        stosb
        add si, dx
        jle line1_no_inc
        add di, sp
        xor sp, -16304
        sub si, bx        
line1_no_inc:
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        sbb di, 0
        dec bp
        jnz line1_begin2
line1_end2:
        mov sp, 1234
        pop bp

        pop ax
        test al, 1
        jz line1_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line1_done:

        pop si
        pop di
        pop ds
        pop bp
        ret
_cga_draw_line1 ENDP

        PUBLIC _cga_draw_line2
_cga_draw_line2 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, xend:WORD, colour:BYTE
	; line from (x0, y0) - (xend, ?) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax
        std

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax

        mov bx, [x0]
        mov ax, [xend]
        sub ax, bx
        neg ax
        inc ax
        push ax
        shr ax, 1
        push bp
        push ax
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, dx

        pop bp
        cmp bp, 0
        je line2_end2

line2_begin2:
        add si, dx
        jg line2_Dgt0_1
        mov al, cl
        rol cl, 1
        rol cl, 1
        jnc line2_ine3
        and al, cl
        and al, es:[di]
        or al, ch
        rol ch, 1
        rol ch, 1
        jmp line2_Dcmp_end_1
line2_ine3:
        and al, es:[di]
        or al, ch
        stosb
        rol ch, 1
        rol ch, 1
        mov al, cl
        and al, es:[di]
        jmp line2_Dcmp_end_1
line2_Dgt0_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        adc di, 0
        mov al, cl
        and al, es:[di]
        sub si, bx        
line2_Dcmp_end_1:
        or al, ch
        stosb
        add si, dx
        jle line2_no_inc
        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        sub si, bx        
line2_no_inc:
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        adc di, 0
        dec bp
        jnz line2_begin2
line2_end2:
        pop bp

        pop ax
        test al, 1
        jz line2_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line2_done:

        cld
        pop si
        pop di
        pop bp
        ret
_cga_draw_line2 ENDP

        PUBLIC _cga_draw_line3
_cga_draw_line3 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
	; line from (x0, y0) - (?, yend) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        mov bx, [yend]
        sub bx, ax
        inc bx
        push bx
        shr bx, 1
        push bp
        push bx
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax

        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, bx

        pop bp
        cmp bp, 0
        je line3_end2

line3_begin2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jng line3_Dcmp_end_1
        inc di
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        jnc line3_ine3
        dec di
line3_ine3:
        sub si, dx        
line3_Dcmp_end_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jle line3_no_inc
        inc di
        sub si, dx
        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        jnc line3_no_inc
        dec di
line3_no_inc:
        dec bp
        jnz line3_begin2
line3_end2:
        pop bp

        pop ax
        test al, 1
        jz line3_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line3_done:

        pop si
        pop di
        pop bp
        ret
_cga_draw_line3 ENDP

        PUBLIC _cga_draw_line4
_cga_draw_line4 PROC
	ARG x0:WORD, y0:WORD, xdiff:WORD, ydiff:WORD, D:WORD, yend:WORD, colour:BYTE
	; line from (x0, y0) - (?, yend) including endpoints
        push bp
	mov bp, sp
        push di
        push si
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        mov bx, [yend]
        sub bx, ax
        inc bx
        push bx
        shr bx, 1
        push bp
        push bx
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax

        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov dx, [ydiff]
        shl dx, 1
        mov bx, [xdiff]
        shl bx, 1
        mov si, [D]
        sub si, bx

        pop bp
        cmp bp, 0
        je line4_end2

line4_begin2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jng line4_Dcmp_end_1
        dec di
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        jnc line4_ine3
        inc di
line4_ine3:
        sub si, dx        
line4_Dcmp_end_1:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        xor ax, ax
        sub di, 8113
        sbb ax, 0
        and ax, 16304
        add di, ax
        add si, bx
        jle line4_no_inc
        dec di
        sub si, dx
        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        jnc line4_no_inc
        inc di
line4_no_inc:
        dec bp
        jnz line4_begin2
line4_end2:
        pop bp

        pop ax
        test al, 1
        jz line4_done

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
line4_done:

        pop si
        pop di
        pop bp
        ret
_cga_draw_line4 ENDP

        PUBLIC _cga_draw_ellipse1
_cga_draw_ellipse1 PROC
	ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
	; ellipse at (x0, y0) x radius r, y radius s
        push bp
	mov bp, sp
        push di
        push si
        push ds
        mov ax, 0b800h
        mov es, ax

        xor si, si

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        add bx, [r]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx
        push cx

        mov ax, [r]
        mov bx, ax
        mul bl
        push ax
        mov ax, [s]
        mov cx, ax
        mul cl
        mov cx, ax
        mul bx
        shl ax, 1
        rcl dx, 1
        cmp dx, 0
        jne ellipse1_large
        test ah, 080h
        jz ellipse1_small1
ellipse1_large:
        pop cx
        pop cx
        pop ds
        pop si
        pop di
        pop bp
        mov ax, 0
        ret
ellipse1_small1:
        mov bx, ax
        mov ax, [s]
        shl ax, 1
        mov bp, cx
        cli
        pop dx
        dec sp
        dec sp
        sti
        mul dx
        cmp dx, 0
        jne ellipse1_large
        test ah, 0c0h
        jnz ellipse1_large

        pop dx

        mov ax, bp
        mov ds, ax
        xor bp, bp
        pop cx

        mov ax, dx
        shl ax, 1
        push ax

        cmp bx, dx
        jb ellipse1_mid       
ellipse1_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, bp
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, bp
        add bp, 80

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        add si, dx
        jo ellipse1_skip_cmpx

        mov ax, bx
        shr ax, 1

        cmp si, 0
        jl ellipse1_skipx
        cmp si, ax
        jb ellipse1_skipx

ellipse1_skip_cmpx:
        mov ax, ds
        sub bx, ax
        sub si, bx
        sub bx, ax

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0
ellipse1_skipx:

        cli
        pop ax
        dec sp
        dec sp
        add dx, ax
        sti

        cmp bx, dx
        jae ellipse1_start
        
ellipse1_mid: 
        neg si

ellipse1_start2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, bp
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, bp

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 1

        mov ax, ds
        sub bx, ax
        jc ellipse1_done
        add si, bx
        jo ellipse1_skip_cmpy

        cmp si, 0
        jl ellipse1_skipy
        mov ax, dx
        shr ax, 1
        cmp si, ax
        jbe ellipse1_skipy

ellipse1_skip_cmpy:
        sub si, dx
        cli
        pop ax
        add dx, ax
        dec sp
        dec sp
        sti

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        add bp, 80

ellipse1_skipy:
        mov ax, ds
        sub bx, ax
        jnc ellipse1_start2

ellipse1_done:
        pop dx

        pop ds        
        pop si
        pop di
        pop bp
        mov ax, 1
        ret
_cga_draw_ellipse1 ENDP

        PUBLIC _cga_draw_ellipse2
_cga_draw_ellipse2 PROC
	ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
	; ellipse at (x0, y0) x radius r, y radius s
        push bp
	mov bp, sp
        push di
        push si
        push ds
        mov ax, 0b800h
        mov es, ax

        xor si, si

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        sub bx, [r]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx
        push cx

        mov ax, [r]
        mov bx, ax
        mul bl
        push ax
        mov ax, [s]
        mov cx, ax
        mul cl
        mov cx, ax
        mul bx
        shl ax, 1
        rcl dx, 1
        cmp dx, 0
        jne ellipse2_large
        test ah, 080h
        jz ellipse2_small1
ellipse2_large:
        pop cx
        pop cx
        pop ds
        pop si
        pop di
        pop bp
        mov ax, 0
        ret
ellipse2_small1:
        mov bx, ax
        mov ax, [s]
        shl ax, 1
        mov bp, cx
        cli
        pop dx
        dec sp
        dec sp
        sti
        mul dx
        cmp dx, 0
        jne ellipse2_large
        test ah, 0c0h
        jnz ellipse2_large

        pop dx

        mov ax, bp
        mov ds, ax
        xor bp, bp
        pop cx

        mov ax, dx
        shl ax, 1
        push ax

        cmp bx, dx
        jb ellipse2_mid       
ellipse2_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, bp
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, bp
        add bp, 80

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        add si, dx
        jo ellipse2_skip_cmpx

        mov ax, bx
        shr ax, 1

        cmp si, 0
        jl ellipse2_skipx
        cmp si, ax
        jb ellipse2_skipx

ellipse2_skip_cmpx:
        mov ax, ds
        sub bx, ax
        sub si, bx
        sub bx, ax

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0
ellipse2_skipx:

        cli
        pop ax
        dec sp
        dec sp
        add dx, ax
        sti

        cmp bx, dx
        jae ellipse2_start
        
ellipse2_mid: 
        neg si

ellipse2_start2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, bp
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, bp

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0ffffh

        mov ax, ds
        sub bx, ax
        jc ellipse2_done
        add si, bx
        jo ellipse2_skip_cmpy

        cmp si, 0
        jl ellipse2_skipy
        mov ax, dx
        shr ax, 1
        cmp si, ax
        jbe ellipse2_skipy

ellipse2_skip_cmpy:
        sub si, dx
        cli
        pop ax
        add dx, ax
        dec sp
        dec sp
        sti

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        add bp, 80

ellipse2_skipy:
        mov ax, ds
        sub bx, ax
        jnc ellipse2_start2

ellipse2_done:
        pop dx

        pop ds        
        pop si
        pop di
        pop bp
        mov ax, 1
        ret
_cga_draw_ellipse2 ENDP

        PUBLIC _cga_draw_ellipse3
_cga_draw_ellipse3 PROC
	LOCAL xlo:WORD, xhi:WORD, ylo:WORD, yhi:WORD=AUTO_SIZE
	ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
        ; ellipse at (x0, y0) x radius r, y radius s
        push bp
	mov bp, sp
        sub sp, AUTO_SIZE
        push di
        push si
        push ds
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        add bx, [r]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov ax, [s]
        mov bx, [r]
        mul al
        mov ds, ax
        mul bx
        shl ax, 1
        rcl dx, 1
        mov [xlo], ax
        mov [xhi], dx

        mov ax, bx
        mul bl
        mov [ylo], ax
        shl ax, 1
        push ax

        xor si, si
        xor bx, bx
        xor dx, dx        
        mov [yhi], bx

        add bx, 1
        adc dx, 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jb ellipse3_mid

ellipse3_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, si
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, si
        add si, 80

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        add bx, [ylo]
        adc dx, [yhi]

        js ellipse3_skipx

        mov ax, [xhi]
        shr ax, 1
        push ax
        mov ax, [xlo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse3_skipx

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        sub bx, [xlo]
        sbb dx, [xhi]
        sub [xlo], ax
        sbb [xhi], 0

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0
ellipse3_skipx:

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jae ellipse3_start

ellipse3_mid:

        sub bx, 1
        sbb dx, 0

        not dx 
        neg bx
        cmc
        adc dx, 0

ellipse3_start2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, si
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, si

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 1

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jb ellipse3_done

        add bx, [xlo]
        adc dx, [xhi]

        js ellipse3_skipy

        mov ax, [yhi]
        shr ax, 1
        push ax
        mov ax, [ylo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse3_skipy

        sub bx, [ylo]
        sbb dx, [yhi]

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        add si, 80

ellipse3_skipy:
        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jae ellipse3_start2

ellipse3_done:
        pop dx
        pop ds        
        pop si
        pop di

        add sp, AUTO_SIZE

        pop bp
        ret
_cga_draw_ellipse3 ENDP

        PUBLIC _cga_draw_ellipse4
_cga_draw_ellipse4 PROC
	LOCAL xlo:WORD, xhi:WORD, ylo:WORD, yhi:WORD=AUTO_SIZE
	ARG x0:WORD, y0:WORD, r:WORD, s:WORD, colour:BYTE
        ; ellipse at (x0, y0) x radius r, y radius s
        push bp
	mov bp, sp
        sub sp, AUTO_SIZE
        push di
        push si
        push ds
        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        sub bx, [r]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov ax, [s]
        mov bx, [r]
        mul al
        mov ds, ax
        mul bx
        shl ax, 1
        rcl dx, 1
        mov [xlo], ax
        mov [xhi], dx

        mov ax, bx
        mul bl
        mov [ylo], ax
        shl ax, 1
        push ax

        xor si, si
        xor bx, bx
        xor dx, dx        
        mov [yhi], bx

        add bx, 1
        adc dx, 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jb ellipse4_mid

ellipse4_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, si
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, si
        add si, 80

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        add bx, [ylo]
        adc dx, [yhi]

        js ellipse4_skipx

        mov ax, [xhi]
        shr ax, 1
        push ax
        mov ax, [xlo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse4_skipx

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        sub bx, [xlo]
        sbb dx, [xhi]
        sub [xlo], ax
        sbb [xhi], 0

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0
ellipse4_skipx:

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jae ellipse4_start

ellipse4_mid:

        sub bx, 1
        sbb dx, 0

        not dx 
        neg bx
        cmc
        adc dx, 0

ellipse4_start2:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        sub di, si
        dec di
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb
        add di, si

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0ffffh

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jb ellipse4_done

        add bx, [xlo]
        adc dx, [xhi]

        js ellipse4_skipy

        mov ax, [yhi]
        shr ax, 1
        push ax
        mov ax, [ylo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse4_skipy

        sub bx, [ylo]
        sbb dx, [yhi]

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax
        add si, 80

ellipse4_skipy:
        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jae ellipse4_start2

ellipse4_done:
        pop dx
        pop ds        
        pop si
        pop di

        add sp, AUTO_SIZE

        pop bp
        ret
_cga_draw_ellipse4 ENDP

        PUBLIC _ellipse_array
_ellipse_array PROC
	LOCAL xlo:WORD, xhi:WORD, ylo:WORD, yhi:WORD=AUTO_SIZE
	ARG off:DWORD, r:WORD, s:WORD
        ; ellipse into array at sg:off, x radius r, y radius s
        push bp
	mov bp, sp
        sub sp, AUTO_SIZE
        push di
        push si
        push ds

        les di, DWORD PTR off

        mov ax, [s]
        mov bx, [r]
        mul al
        mov ds, ax
        mul bx
        shl ax, 1
        rcl dx, 1
        mov [xlo], ax
        mov [xhi], dx

        mov ax, bx
        mov cx, bx
        mul bl
        mov [ylo], ax
        shl ax, 1
        push ax

        xor si, si
        xor bx, bx
        xor dx, dx        
        mov [yhi], bx

        add bx, 1
        adc dx, 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jb ellipse_array_mid

ellipse_array_start:
        mov al, cl
        stosb

        ; inc y

        add bx, [ylo]
        adc dx, [yhi]

        js ellipse_array_skipx

        mov ax, [xhi]
        shr ax, 1
        push ax
        mov ax, [xlo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse_array_skipx

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        sub bx, [xlo]
        sbb dx, [xhi]
        sub [xlo], ax
        sbb [xhi], 0

        dec cl
ellipse_array_skipx:

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        mov ax, [xlo]
        sub ax, [ylo]
        mov ax, [xhi]
        sbb ax, [yhi]
        jae ellipse_array_start

ellipse_array_mid:

        sub bx, 1
        sbb dx, 0

        not dx 
        neg bx
        cmc
        adc dx, 0

        mov ax, di
        sub ax, WORD PTR [off]
        mov ch, al
        mov cl, al

ellipse_array_start2:
        mov al, cl
        stosb

        ; dec x

        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jb ellipse_array_done

        add bx, [xlo]
        adc dx, [xhi]

        js ellipse_array_skipy

        mov ax, [yhi]
        shr ax, 1
        push ax
        mov ax, [ylo]
        rcr ax, 1
        sub ax, bx
        pop ax
        sbb ax, dx

        jae ellipse_array_skipy

        sub bx, [ylo]
        sbb dx, [yhi]

        cli
        pop ax
        dec sp
        dec sp
        sti
        add [ylo], ax
        adc [yhi], 0

        inc cl

ellipse_array_skipy:
        mov ax, ds
        sub [xlo], ax
        sbb [xhi], 0
        jae ellipse_array_start2

ellipse_array_done:

        mov ax, di
        sub ax, WORD PTR [off]
        mov ah, ch

        pop dx
        pop ds        
        pop si
        pop di

        add sp, AUTO_SIZE

        pop bp
        ret
_ellipse_array ENDP

        PUBLIC _cga_draw_ellipse_array1
_cga_draw_ellipse_array1 PROC
	ARG off:DWORD, x0:WORD, y0:WORD, e1:DWORD, e2:DWORD, e3:DWORD, colour:BYTE
        ; draw ellipse from array starting at point (x0, y0)
        push bp
	mov bp, sp
        push di
        push si
        push ds

        lds si, DWORD PTR off

        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov bx, WORD PTR [e1]

        cmp si, bx
        jae cga_ellipse_array1_mid

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array1_one

cga_ellipse_array1_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        lodsb
        mov dh, al
        sub al, dl
        mov dl, dh
        jnc cga_ellipse_array1_x

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0

cga_ellipse_array1_x:        
        
        cmp si, bx
        jb cga_ellipse_array1_start

cga_ellipse_array1_one:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        mov ax, WORD PTR [e3]
        sub ax, WORD PTR [e1]
        dec ax
        sub al, dl
        jnc cga_ellipse_array1_mid

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0

cga_ellipse_array1_mid:

        mov bx, WORD PTR [e2]

        cmp si, bx
        jae cga_ellipse_array1_end

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array1_two

cga_ellipse_array1_start2:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 1

        lodsb
        xchg al, dl
        sub al, dl
        jnc cga_ellipse_array1_y

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax

cga_ellipse_array1_y:

        cmp si, bx
        jb cga_ellipse_array1_start2

cga_ellipse_array1_two:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

cga_ellipse_array1_end:

        pop ds        
        pop si
        pop di
        pop bp
        ret
_cga_draw_ellipse_array1 ENDP

        PUBLIC _cga_draw_ellipse_array2
_cga_draw_ellipse_array2 PROC
	ARG off:DWORD, x0:WORD, y0:WORD, e1:DWORD, e2:DWORD, e3:DWORD, colour:BYTE
        ; draw ellipse from array starting at point (x0, y0)
        push bp
	mov bp, sp
        push di
        push si
        push ds

        lds si, DWORD PTR off

        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov bx, WORD PTR [e1]

        cmp si, bx
        jae cga_ellipse_array2_mid

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array2_one

cga_ellipse_array2_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8193
        sbb ax, ax
        and ax, 16304
        add di, ax

        lodsb
        mov dh, al
        sub al, dl
        mov dl, dh
        jnc cga_ellipse_array2_x

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0

cga_ellipse_array2_x:        
        
        cmp si, bx
        jb cga_ellipse_array2_start

cga_ellipse_array2_one:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8193
        sbb ax, ax
        and ax, 16304
        add di, ax

        mov ax, WORD PTR [e3]
        sub ax, WORD PTR [e1]
        dec ax
        sub al, dl
        jnc cga_ellipse_array2_mid

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 0

cga_ellipse_array2_mid:

        mov bx, WORD PTR [e2]

        cmp si, bx
        jae cga_ellipse_array2_end

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array2_two

cga_ellipse_array2_start2:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        rol ch, 1
        rol ch, 1
        rol cl, 1
        rol cl, 1
        cmc
        sbb di, 1

        lodsb
        xchg al, dl
        sub al, dl
        jnc cga_ellipse_array2_y

        xor ax, ax
        sub di, 8192
        sbb ax, ax
        and ax, 16304
        add di, ax

cga_ellipse_array2_y:

        cmp si, bx
        jb cga_ellipse_array2_start2

cga_ellipse_array2_two:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

cga_ellipse_array2_end:

        pop ds        
        pop si
        pop di
        pop bp
        ret
_cga_draw_ellipse_array2 ENDP

        PUBLIC _cga_draw_ellipse_array3
_cga_draw_ellipse_array3 PROC
	ARG off:DWORD, x0:WORD, y0:WORD, e1:DWORD, e2:DWORD, e3:DWORD, colour:BYTE
        ; draw ellipse from array starting at point (x0, y0)
        push bp
	mov bp, sp
        push di
        push si
        push ds

        lds si, DWORD PTR off

        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov bx, WORD PTR [e1]

        cmp si, bx
        jae cga_ellipse_array3_mid

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array3_one

cga_ellipse_array3_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        lodsb
        mov dh, al
        sub al, dl
        mov dl, dh
        jnc cga_ellipse_array3_x

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0

cga_ellipse_array3_x:        
        
        cmp si, bx
        jb cga_ellipse_array3_start

cga_ellipse_array3_one:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8113
        sbb ax, ax
        and ax, 16304
        add di, ax

        mov ax, WORD PTR [e3]
        sub ax, WORD PTR [e1]
        dec ax
        sub al, dl
        jnc cga_ellipse_array3_mid

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0

cga_ellipse_array3_mid:

        mov bx, WORD PTR [e2]

        cmp si, bx
        jae cga_ellipse_array3_end

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array3_two

cga_ellipse_array3_start2:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0ffffh

        lodsb
        xchg al, dl
        sub al, dl
        jnc cga_ellipse_array3_y

        xor ax, ax
        sub di, 8112
        sbb ax, ax
        and ax, 16304
        add di, ax

cga_ellipse_array3_y:

        cmp si, bx
        jb cga_ellipse_array3_start2

cga_ellipse_array3_two:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

cga_ellipse_array3_end:

        pop ds        
        pop si
        pop di
        pop bp
        ret
_cga_draw_ellipse_array3 ENDP

        PUBLIC _cga_draw_ellipse_array4
_cga_draw_ellipse_array4 PROC
	ARG off:DWORD, x0:WORD, y0:WORD, e1:DWORD, e2:DWORD, e3:DWORD, colour:BYTE
        ; draw ellipse from array starting at point (x0, y0)
        push bp
	mov bp, sp
        push di
        push si
        push ds

        lds si, DWORD PTR off

        mov ax, 0b800h
        mov es, ax

        xor di, di
        mov ax, [y0]
        shr ax, 1
        sbb di, 0
        and di, 8192
        shl ax, 1
        shl ax, 1
        shl ax, 1        
        shl ax, 1
        add di, ax
        shl ax, 1
        shl ax, 1
        add di, ax
        
        mov bx, [x0]
        mov cl, bl
        mov ch, [colour]
        inc cl
        and cl, 3
        shl cl, 1
        ror ch, cl
        mov ah, 0fch
        ror ah, cl
        mov cl, ah
        shr bx, 1
        shr bx, 1
        add di, bx

        mov bx, WORD PTR [e1]

        cmp si, bx
        jae cga_ellipse_array4_mid

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array4_one

cga_ellipse_array4_start:
        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8193
        sbb ax, ax
        and ax, 16304
        add di, ax

        lodsb
        mov dh, al
        sub al, dl
        mov dl, dh
        jnc cga_ellipse_array4_x

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0

cga_ellipse_array4_x:
        
        cmp si, bx
        jb cga_ellipse_array4_start

cga_ellipse_array4_one:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        xor ax, ax
        sub di, 8193
        sbb ax, ax
        and ax, 16304
        add di, ax

        mov ax, WORD PTR [e3]
        sub ax, WORD PTR [e1]
        dec ax
        sub al, dl
        jnc cga_ellipse_array4_mid

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0

cga_ellipse_array4_mid:

        mov bx, WORD PTR [e2]

        cmp si, bx
        jae cga_ellipse_array4_end

        lodsb
        mov dl, al

        cmp si, bx
        jae cga_ellipse_array4_two

cga_ellipse_array4_start2:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

        ror ch, 1
        ror ch, 1
        ror cl, 1
        ror cl, 1
        cmc
        adc di, 0ffffh

        lodsb
        xchg al, dl
        sub al, dl
        jnc cga_ellipse_array4_y

        xor ax, ax
        sub di, 8192
        sbb ax, ax
        and ax, 16304
        add di, ax

cga_ellipse_array4_y:

        cmp si, bx
        jb cga_ellipse_array4_start2

cga_ellipse_array4_two:

        mov al, cl
        and al, es:[di]
        or al, ch
        stosb

cga_ellipse_array4_end:

        pop ds        
        pop si
        pop di
        pop bp
        ret
_cga_draw_ellipse_array4 ENDP

	END
