#include "stdio.h"
#include "dos.h"

extern void cga_colours();

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

void set_video_palette_colour(unsigned char colour)
{
   asm push ax;
   asm push dx;
   asm mov dx, 03d9h;
   asm mov al, [colour];
   asm out dx, al;
   asm pop dx;
   asm pop ax;
}

int main(void)
{
   int i;

   set_video_mode(4);
   outp(0x3d8, 10);

   for (i = 0; i < 64; i++)
   {
      set_video_palette_colour(i);

      cga_colours();

      getchar();
   }

   set_video_mode(3);

   return 0;
}
