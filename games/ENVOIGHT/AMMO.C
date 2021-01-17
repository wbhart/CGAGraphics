sprite_show_ammo0(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13135
   asm jmp nextline0
oddline0:
   asm sub di, 13057
nextline0:
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
}

void sprite_ammo0_odd(unsigned char far * video)
{
   sprite_show_ammo0(video, 1);
}

void sprite_ammo0_even(unsigned char far * video)
{
   sprite_show_ammo0(video, 0);
}

sprite_show_ammo1(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13134
   asm jmp nextline0
oddline0:
   asm sub di, 13058
nextline0:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
}

void sprite_ammo1_odd(unsigned char far * video)
{
   sprite_show_ammo1(video, 1);
}

void sprite_ammo1_even(unsigned char far * video)
{
   sprite_show_ammo1(video, 0);
}

sprite_show_ammo2(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm inc di
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13134
   asm jmp nextline0
oddline0:
   asm sub di, 13058
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
}

void sprite_ammo2_odd(unsigned char far * video)
{
   sprite_show_ammo2(video, 1);
}

void sprite_ammo2_even(unsigned char far * video)
{
   sprite_show_ammo2(video, 0);
}

sprite_show_ammo3(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm inc di
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 60
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13134
   asm jmp nextline0
oddline0:
   asm sub di, 13058
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 60
   asm stosb
}

void sprite_ammo3_odd(unsigned char far * video)
{
   sprite_show_ammo3(video, 1);
}

void sprite_ammo3_even(unsigned char far * video)
{
   sprite_show_ammo3(video, 0);
}

#include <alloc.h>
#include "sprite.h"

void sprite_init_ammo(sprite_t s, int x, int y)
{
   s->x = x;
   s->y = y;
   s->oldx = x;
   s->oldy = y;
   s->xsize = 8;
   s->ysize = 2; 
   s->sprite0_odd  = sprite_ammo0_odd;
   s->sprite0_even = sprite_ammo0_even;
   s->sprite1_odd  = sprite_ammo1_odd;
   s->sprite1_even = sprite_ammo1_even;
   s->sprite2_odd  = sprite_ammo2_odd;
   s->sprite2_even = sprite_ammo2_even;
   s->sprite3_odd  = sprite_ammo3_odd;
   s->sprite3_even = sprite_ammo3_even;
   s->buff = malloc(s->ysize*s->xsize/4);
}

void sprite_clear_ammo(sprite_t s)
{
   free(s->buff);
}

