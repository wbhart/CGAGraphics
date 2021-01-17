#include "page.h"
#include "sprite.h"
#include "pcx.h"

/******************************************************************************
*
*   Direct sprite functions
*
******************************************************************************/

void sprite_display_direct(unsigned char far * video,
                          unsigned char * sprite, int xsize, int ysize)
{
   int i, j, off = 0;

   xsize >>= 2;

   for (i = 0; i < ysize; i++)
   {
      for (j = 0; j < xsize; j++)
         video[off + j] = sprite[j];
      
      off ^= 8192;
      if (i&1)
         off += 80;

      sprite += xsize;
   }
}

/******************************************************************************
*
*   Paged sprite functions
*
******************************************************************************/

void sprite_composite(unsigned char far * page, sprite_t s)
{
   int odd = 0;

   page += ((s->y >> 1)*PAGE_LINEB + (s->x >> 2) + PAGE_OFFSET);

   if (s->y & 1)
   {
      odd = 1;
      page += PAGE_ODDB;
   }

   switch (s->x & 3)
   {
      case 0:
         if (odd)
            (s->sprite0_odd)(page);
         else
            (s->sprite0_even)(page);
         break;
      case 1:
         if (odd)
            (s->sprite1_odd)(page);
         else
            (s->sprite1_even)(page);
         break;
      case 2:
         if (odd)
            (s->sprite2_odd)(page);
         else
            (s->sprite2_even)(page);
         break;
      case 3:
         if (odd)
            (s->sprite3_odd)(page);
         else
            (s->sprite3_even)(page);
         break;
   }
}

void sprite_flip(unsigned char far * video,
                                    unsigned char far * page, sprite_t s)
{
   int x0 = min(s->x, s->oldx);
   int y0 = min(s->y, s->oldy);
   int x1 = max(s->x + s->xsize, s->oldx + s->xsize);
   int y1 = max(s->y + s->ysize, s->oldy + s->ysize);

   if (x0 < 0) x0 = 0;
   if (y0 < 0) y0 = 0;

   if (x1 > 320) x1 = 320;
   if (y1 > 200) y1 = 200;

   x0 >>= 2;
   x1 >>= 2;

   if (x1 > x0 && y1 > y0)
   {
      video += ((y0 >> 1)*80 + x0);
      page += (((PAGE_MARGIN + y0) >> 1)*PAGE_LINEB +
                (PAGE_MARGIN >> 2) + x0);

      if (y0 & 1)
      {
         video += 8192;
         page += PAGE_ODDB;
      }

      y1 -= y0;
      x1 -= x0;

      asm push ds

      asm mov bx, y1
      asm mov dx, x1

      asm les di, video
      asm lds si, page

      asm mov al, y0
      asm and al, 1

next_line:

      asm mov cx, dx
      asm shr cx, 1

      asm repz
      asm movsw

      asm test dx, 1
      asm jp even_len

      asm movsb

even_len:

      asm sub si, dx
      asm sub di, dx

      asm xor al, 1
      asm jnz even_line

      asm sub di, (8192-80)
      asm sub si, (PAGE_ODDB-PAGE_LINEB)

      asm jmp next_iter

even_line:

      asm add di, 8192
      asm add si, PAGE_ODDB
      
next_iter:

      asm dec bl
      asm jnz next_line

      asm pop ds      
   }

   s->oldx = s->x;
   s->oldy = s->y;
}

void sprite_save_bg(sprite_t s, unsigned char far * page)
{
   int x0 = s->x;
   int y0 = s->y;
   int x1 = s->x + s->xsize;
   int y1 = s->y + s->ysize;
   unsigned char far * buff = s->buff;

   if (x0 < 0) x0 = 0;
   if (y0 < 0) y0 = 0;

   if (x1 > 320) x1 = 320;
   if (y1 > 200) y1 = 200;

   if (x1 > x0 && y1 > y0)
   {
      x0 >>= 2;
      x1 >>= 2;

      page += (((PAGE_MARGIN + y0) >> 1)*PAGE_LINEB +
                (PAGE_MARGIN >> 2) + x0);

      if (y0 & 1)
         page += PAGE_ODDB;
   
      y1 -= y0;
      x1 -= x0;

      asm mov bx, y1
      asm mov dx, x1

      asm push ds

      asm lds si, page
      asm les di, buff

      asm mov al, y0
      asm and al, 1

next_line:

      asm mov cx, dx
      asm shr cx, 1

      asm repz
      asm movsw

      asm test dx, 1
      asm jp even_len

      asm movsb

even_len:

      asm sub si, dx

      asm xor al, 1
      asm jnz even_line

      asm sub si, (PAGE_ODDB-PAGE_LINEB)

      asm jmp next_iter

even_line:

      asm add si, PAGE_ODDB
      
next_iter:

      asm dec bl
      asm jnz next_line

      asm pop ds
   }
}

void sprite_restore_bg(unsigned char far * page, sprite_t s)
{
   int x0 = s->x;
   int y0 = s->y;
   int x1 = s->x + s->xsize;
   int y1 = s->y + s->ysize;
   unsigned char far * buff = s->buff;

   if (x0 < 0) x0 = 0;
   if (y0 < 0) y0 = 0;

   if (x1 > 320) x1 = 320;
   if (y1 > 200) y1 = 200;

   if (x1 > x0 && y1 > y0)
   {
      x0 >>= 2;
      x1 >>= 2;

      page += (((PAGE_MARGIN + y0) >> 1)*PAGE_LINEB +
                (PAGE_MARGIN >> 2) + x0);

      if (y0 & 1)
         page += PAGE_ODDB;

      y1 -= y0;
      x1 -= x0;

      asm mov bx, y1
      asm mov dx, x1

      asm push ds

      asm les di, page
      asm lds si, buff

      asm mov al, y0
      asm and al, 1

next_line:

      asm mov cx, dx
      asm shr cx, 1

      asm repz
      asm movsw

      asm test dx, 1
      asm jp even_len

      asm movsb

even_len:

      asm sub di, dx

      asm xor al, 1
      asm jnz even_line

      asm sub di, (PAGE_ODDB-PAGE_LINEB)

      asm jmp next_iter

even_line:

      asm add di, PAGE_ODDB
      
next_iter:

      asm dec bl
      asm jnz next_line

      asm pop ds
   }
}

void sprite_wipe(unsigned char far * page, sprite_t s)
{
   int x1 = ((s->oldx + s->xsize) >> 2);
   int y1 = s->oldy + s->ysize;
   int x0 = s->oldx < 0 ? 0 : (s->oldx >> 2);
   int y0 = s->oldy < 0 ? 0 : s->oldy;
   int i, j;

   if (x1 < 0) x1 = 0;
   if (y1 < 0) y1 = 0;

   if (x1 > 80)  x1 = 80;
   if (y1 > 200) y1 = 200;
   
   if (x1 > x0 && y1 > y0)
   {
      page += (((PAGE_MARGIN + y0) >> 1)*PAGE_LINEB +
               (PAGE_MARGIN >> 2) + x0);

      if (y0 & 1)
         page += PAGE_ODDB;

      y1 -= y0;
      x1 -= x0;

      asm mov bx, y1
      asm mov dx, x1

      asm les di, page

      asm mov bh, y0
      asm and bh, 1

      asm xor ax, ax

next_line:

      asm mov cx, dx
      asm shr cx, 1

      asm repz
      asm stosw

      asm test dx, 1
      asm jp even_len

      asm stosb

even_len:

      asm sub di, dx

      asm xor bh, 1
      asm jnz even_line

      asm sub di, (PAGE_ODDB-PAGE_LINEB)

      asm jmp next_iter

even_line:

      asm add di, PAGE_ODDB
      
next_iter:

      asm dec bl
      asm jnz next_line      
   }
}

void sprite_move(sprite_t s, int x, int y)
{
   s->x += x;
   s->y += y;

   if (s->x < 0) s->x = 0;
   if (s->x + s->xsize > 320)
      s->x  = 320 - s->xsize;

   if (s->y < -SPRITE_WIDTH) s->y = -SPRITE_WIDTH;
   if (s->y + s->ysize > 200 + SPRITE_WIDTH)
      s->y  = 200 + SPRITE_WIDTH - s->ysize;
}
