#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <dos.h>
#include <math.h>

extern void cga_draw_line(unsigned char far * buff,
                        int x0, int y0, int x1, int y1, unsigned char colour);
extern void cga_draw_hline(unsigned char far * buff,
                                 int x0, int x1, int y, unsigned char colour);
extern void cga_draw_vline(unsigned char far * buff,
                                 int x, int y0, int y1, unsigned char colour);
extern void cga_draw_line_chunky_left(unsigned char far * buff,
                        int x0, int y0, int x1, int y1, unsigned char colour);
extern void cga_draw_line_chunky_right(unsigned char far * buff,
                        int x0, int y0, int x1, int y1, unsigned char colour);

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
   int costab[158];

   int diff = 3, inc = 0;
   int diff2 = 1, trans = 0;
   
   for (i = 0; i < 158; i++)
      costab[i] = (int) floor(50*cos(i*0.02)+0.5);

   getchar();

   set_video_mode(4);


   for (i = 0; i <100; i++)
      cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 50+i, 1);

   for (i = 0; i < 100; i++)
   {
      for (j = 0; j < 158; j++)
      {
         diff = 20*(50 - costab[(2*j) % 158])/100;
         if (j >= 79) diff = 20 - diff;

         cga_draw_line_chunky_left(MK_FP(0xb800, 0), 50, 50-diff, 50-diff, 100-costab[j], 0xaa);
         cga_draw_line_chunky_right(MK_FP(0xb800, 0), 200, 50-diff, 200+diff, 100-costab[j], 0xaa);

         if (j < 79)
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 50-diff, 2);
         else
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 50-diff-1, 0);

         cga_draw_hline(MK_FP(0xb800, 0), 50-diff, 200+diff, 100-costab[j], 2);

         cga_draw_line_chunky_left(MK_FP(0xb800, 0), 50-diff, 100-costab[j]+1, 50, 150+diff, 0x55);
         cga_draw_line_chunky_right(MK_FP(0xb800, 0), 200+diff, 100-costab[j]+1, 200, 150+diff, 0x55);

         if (j < 79)
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 150+diff, 1);
         else
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 150+diff+1, 0);
      }

      for (j = 0; j < 158; j++)
      {
         diff = 20*(50 - costab[(2*j) % 158])/100;
         if (j >= 79) diff = 20 - diff;

         cga_draw_line_chunky_left(MK_FP(0xb800, 0), 50, 50-diff, 50-diff, 100-costab[j], 0x55);
         cga_draw_line_chunky_right(MK_FP(0xb800, 0), 200, 50-diff, 200+diff, 100-costab[j], 0x55);

         if (j < 79)
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 50-diff, 1);
         else
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 50-diff-1, 0);

         cga_draw_hline(MK_FP(0xb800, 0), 50-diff, 200+diff, 100-costab[j], 1);

         cga_draw_line_chunky_left(MK_FP(0xb800, 0), 50-diff, 100-costab[j]+1, 50, 150+diff, 0xaa);
         cga_draw_line_chunky_right(MK_FP(0xb800, 0), 200+diff, 100-costab[j]+1, 200, 150+diff, 0xaa);

         if (j < 79)
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 150+diff, 2);
         else
             cga_draw_hline(MK_FP(0xb800, 0), 50, 200, 150+diff+1, 0);
      }
   }

   getchar();

   set_video_mode(3);

   return 0;
}
