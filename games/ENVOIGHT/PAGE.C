#include <dos.h>
#include <alloc.h>
#include "page.h"

unsigned char far * page_alloc()
{
   return farcalloc(2, PAGE_ODDB);
}

void page_free(unsigned char far * page)
{
   farfree(page);
}

void page_copy_bg(unsigned char far * page, unsigned char far * video)
{
   page += PAGE_OFFSET;

   asm push ds

   asm mov bx, 200
   asm mov dx, 80

   asm lds si, video
   asm les di, page

   asm xor al, al

next_line:

   asm mov cx, dx
   asm shr cx, 1

   asm repz
   asm movsw

   asm sub si, dx
   asm sub di, dx

   asm xor al, 1
   asm jnz even_line

   asm sub si, (8192-80)
   asm sub di, (PAGE_ODDB-PAGE_LINEB)

   asm jmp next_iter

even_line:

   asm add si, 8192
   asm add di, PAGE_ODDB
      
next_iter:

   asm dec bl
   asm jnz next_line

   asm pop ds
}

void page_flip_box_aligned(unsigned char far * video,
                 unsigned char far * page, int x, int y, int xsize, int ysize)
{
   int off1 = (y>>1)*80 + (x>>2);
   int off2 = PAGE_OFFSET+(y>>1)*PAGE_LINEB+(x>>2);
   int end, i;

   xsize >>= 2;

   if (y & 1)
   {
      off1 += 8192;
      off2 += PAGE_ODDB;
   }

   asm push ds
   asm les di, video
   asm add di, off1
   asm lds si, page
   asm add si, off2

   asm mov bl, y
   asm and bl, 1

   asm mov dx, ysize

next_line:

   asm mov cx, xsize
   asm shr cx, 1

   asm repz
   asm movsw

   asm sub si, xsize
   asm sub di, xsize

   asm xor bl, 1
   asm jp odd_line

   asm add si, PAGE_ODDB
   asm add di, 8192

   asm jmp cont_line

odd_line:

   asm sub si, (PAGE_ODDB-PAGE_LINEB)
   asm sub di, (8192-80)

cont_line:

   asm dec dx
   asm jnz next_line

   asm pop ds
}

void page_flip_box_unaligned(unsigned char far * video,
                 unsigned char far * page, int x, int y, int xsize, int ysize)
{
   int off1 = (y>>1)*80 + (x>>2);
   int off2 = PAGE_OFFSET+(y>>1)*PAGE_LINEB+(x>>2);
   int end, i;

   xsize >>= 2;

   if (y & 1)
   {
      off1 += 8192;
      off2 += PAGE_ODDB;
   }

   asm push ds
   asm les di, video
   asm add di, off1
   asm lds si, page
   asm add si, off2

   asm mov bl, y
   asm and bl, 1

   asm mov dx, ysize

next_line:

   asm mov cx, xsize

   asm repz
   asm movsb

   asm sub si, xsize
   asm sub di, xsize

   asm xor bl, 1
   asm jp odd_line

   asm add si, PAGE_ODDB
   asm add di, 8192

   asm jmp cont_line

odd_line:

   asm sub si, (PAGE_ODDB-PAGE_LINEB)
   asm sub di, (8192-80)

cont_line:

   asm dec dx
   asm jnz next_line

   asm pop ds
}
