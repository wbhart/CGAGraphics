#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <dos.h>
#include <math.h>

extern void cga_draw_hline(unsigned char far * buff,
                                 int x0, int x1, int y, unsigned char colour);
extern void cga_draw_vline(unsigned char far * buff,
                                 int x, int y0, int y1, unsigned char colour);
extern void cga_checkboard(void);

#define SLOW_VERSION 0

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

int main(void)
{
   int i, j, k, l;
   int xstart[6];
   int ystart[4];

   getchar();

   set_video_mode(4);

#if SLOW_VERSION

   ystart[0] = 0;
   ystart[1] = 50;
   ystart[2] = 100;
   ystart[3] = 150;

   for (i = 0; i < 50; i++)
   {
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, i, 2);
   }

   for (i = 50; i < 100; i++)
   {
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, i, 1);
   }

   for (i = 100; i < 150; i++)
   {
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, i, 2);
   }

   for (i = 150; i < 200; i++)
   {
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, i, 1);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, i, 2);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, i, 1);
   }

   for (i = 0; i < 32000; i++)
   {
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, ystart[0], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, ystart[0], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, ystart[0], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, ystart[0], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, ystart[0], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, ystart[0], 1);
      
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, ystart[1], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, ystart[1], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, ystart[1], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, ystart[1], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, ystart[1], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, ystart[1], 2);
      
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, ystart[2], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, ystart[2], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, ystart[2], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, ystart[2], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, ystart[2], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, ystart[2], 1);
      
      cga_draw_hline(MK_FP(0xb800, 0), 0, 59, ystart[3], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 60, 119, ystart[3], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 120, 179, ystart[3], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 180, 239, ystart[3], 2);
      cga_draw_hline(MK_FP(0xb800, 0), 240, 299, ystart[3], 1);
      cga_draw_hline(MK_FP(0xb800, 0), 300, 319, ystart[3], 2);
      
      ystart[0]++;
      if (ystart[0] == 200)
         ystart[0] = 0;

      ystart[1]++;
      if (ystart[1] == 200)
         ystart[1] = 0;

      ystart[2]++;
      if (ystart[2] == 200)
         ystart[2] = 0;

      ystart[3]++;
      if (ystart[3] == 200)
         ystart[3] = 0;
   }

#else
   for (i = 0; i < 100; i++)
      cga_checkboard();
#endif

   getchar();

   set_video_mode(3);

   return 0;
}
