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
   int diff = 3, inc = 0;
   int diff2 = 1, trans = 0;

   getchar();

   set_video_mode(4);

   for (i = 0; i < 200; i++)
      cga_draw_hline(MK_FP(0xb800, 0), 0, 199, i, 0);

   diff = 3;

   for (i = 0; i < 66; i++)
      cga_draw_hline(MK_FP(0xb800, 0), 100, 250, i, 1);

   for (i = 66; i < 132; i++)
      cga_draw_hline(MK_FP(0xb800, 0), 100, 250, i, 2);

   for (i = 132; i < 198; i++)
      cga_draw_hline(MK_FP(0xb800, 0), 100, 250, i, 1);

   for (i = 0; i < 10000; i++)
   {
      inc += diff;
      trans += diff2;

      if (inc == 51 || inc == -51)
         diff = -diff;

      if (trans == 20 || trans == -50)
         diff2 = -diff2;

      cga_draw_line_chunky_left(MK_FP(0xb800, 0), 100-inc+trans, 0, 100+inc+trans, 65, 0x55);
      cga_draw_line_chunky_left(MK_FP(0xb800, 0), 100+inc+trans, 66, 100+inc+trans, 131, 0xaa);
      cga_draw_line_chunky_left(MK_FP(0xb800, 0), 100+inc+trans, 132, 100-inc+trans, 197, 0x55);
      
      cga_draw_line_chunky_right(MK_FP(0xb800, 0), 250+inc+trans, 0, 250-inc+trans, 65, 0x55);
      cga_draw_line_chunky_right(MK_FP(0xb800, 0), 250-inc+trans, 66, 250-inc+trans, 131, 0xaa);
      cga_draw_line_chunky_right(MK_FP(0xb800, 0), 250-inc+trans, 132, 250+inc+trans, 197, 0x55);
   }

   getchar();

   set_video_mode(3);

   return 0;
}
