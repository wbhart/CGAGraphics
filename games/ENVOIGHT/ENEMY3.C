sprite_show_enemy30(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 16
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13132
   asm jmp nextline0
oddline0:
   asm sub di, 13060
nextline0:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 84
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13132
   asm jmp nextline2
oddline2:
   asm sub di, 13060
nextline2:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13131
   asm jmp nextline5
oddline5:
   asm sub di, 13061
nextline5:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13131
   asm jmp nextline6
oddline6:
   asm sub di, 13061
nextline6:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm inc di
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13130
   asm jmp nextline9
oddline9:
   asm sub di, 13062
nextline9:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
}

void sprite_enemy30_odd(unsigned char far * video)
{
   sprite_show_enemy30(video, 1);
}

void sprite_enemy30_even(unsigned char far * video)
{
   sprite_show_enemy30(video, 0);
}

sprite_show_enemy31(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 4
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13132
   asm jmp nextline0
oddline0:
   asm sub di, 13060
nextline0:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 21
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13131
   asm jmp nextline5
oddline5:
   asm sub di, 13061
nextline5:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13130
   asm jmp nextline9
oddline9:
   asm sub di, 13062
nextline9:
   asm inc di
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
}

void sprite_enemy31_odd(unsigned char far * video)
{
   sprite_show_enemy31(video, 1);
}

void sprite_enemy31_even(unsigned char far * video)
{
   sprite_show_enemy31(video, 0);
}

sprite_show_enemy32(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13132
   asm jmp nextline0
oddline0:
   asm sub di, 13060
nextline0:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13130
   asm jmp nextline5
oddline5:
   asm sub di, 13062
nextline5:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13129
   asm jmp nextline9
oddline9:
   asm sub di, 13063
nextline9:
   asm inc di
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 21
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
}

void sprite_enemy32_odd(unsigned char far * video)
{
   sprite_show_enemy32(video, 1);
}

void sprite_enemy32_even(unsigned char far * video)
{
   sprite_show_enemy32(video, 0);
}

sprite_show_enemy33(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13130
   asm jmp nextline4
oddline4:
   asm sub di, 13062
nextline4:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13130
   asm jmp nextline5
oddline5:
   asm sub di, 13062
nextline5:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 20
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 69
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 81
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 17
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 64
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13129
   asm jmp nextline8
oddline8:
   asm sub di, 13063
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 68
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 80
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13129
   asm jmp nextline9
oddline9:
   asm sub di, 13063
nextline9:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 5
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, 85
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 84
   asm stosb
}

void sprite_enemy33_odd(unsigned char far * video)
{
   sprite_show_enemy33(video, 1);
}

void sprite_enemy33_even(unsigned char far * video)
{
   sprite_show_enemy33(video, 0);
}

#include <alloc.h>
#include "sprite.h"

void sprite_init_enemy3(sprite_t s, int x, int y)
{
   s->x = x;
   s->y = y;
   s->oldx = x;
   s->oldy = y;
   s->xsize = 28;
   s->ysize = 11; 
   s->sprite0_odd  = sprite_enemy30_odd;
   s->sprite0_even = sprite_enemy30_even;
   s->sprite1_odd  = sprite_enemy31_odd;
   s->sprite1_even = sprite_enemy31_even;
   s->sprite2_odd  = sprite_enemy32_odd;
   s->sprite2_even = sprite_enemy32_even;
   s->sprite3_odd  = sprite_enemy33_odd;
   s->sprite3_even = sprite_enemy33_even;
   s->buff = malloc(s->ysize*s->xsize/4);
}

void sprite_clear_enemy3(sprite_t s)
{
   free(s->buff);
}

