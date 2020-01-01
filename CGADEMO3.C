#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <conio.h>
#include <dos.h>
#include <time.h>
#include <math.h>
 
extern void cga_draw_line1(int x0, int y0, int dx, int dy,
                                       int D, int endx, unsigned char colour);
extern void cga_draw_line1_11(int x0, int y0, int dx, int dy,
                                                             int D, int endx);
extern void cga_draw_line1_00(int x0, int y0, int dx, int dy,
                                                             int D, int endx);
extern void cga_draw_line_xor1(int x0, int y0, int dx, int dy,
                                       int D, int endx, unsigned char colour);
extern void cga_draw_line_blank1(int x0, int y0, int dx, int dy,
                                       int D, int endx, unsigned char colour);

extern void cga_draw_line2(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);
extern void cga_draw_line2_00(int x0, int y0, int dx, int dy,
                                                             int D, int endy);
extern void cga_draw_line2_11(int x0, int y0, int dx, int dy,
                                                             int D, int endy);
extern void cga_draw_line_blank2(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);
extern void cga_draw_line3(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);
extern void cga_draw_line3_00(int x0, int y0, int dx, int dy,
                                                             int D, int endy);
extern void cga_draw_line3_11(int x0, int y0, int dx, int dy,
                                                             int D, int endy);
extern void cga_draw_line_blank3(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);

extern void cga_draw_circle1(int x0, int y0, int r, unsigned char colour);
extern void cga_draw_circle1_00(int x0, int y0, int r);
extern void cga_draw_circle1_11(int x0, int y0, int r);
extern void cga_draw_circle_xor1(int x0, int y0, int r, unsigned char colour);
extern void cga_draw_circle_blank1(int x0, int y0, int r, unsigned char colour);
extern void cga_draw_circle2(int x0, int y0, int r, unsigned char colour);
extern void cga_draw_circle2_00(int x0, int y0, int r);
extern void cga_draw_circle2_11(int x0, int y0, int r);
extern void cga_draw_circle_xor2(int x0, int y0, int r, unsigned char colour);
extern void cga_draw_circle_blank2(int x0, int y0, int r, unsigned char colour);

extern void cga_draw_ellipse1(int x0, int y0, int r, int s, unsigned char colour);
extern void cga_draw_ellipse2(int x0, int y0, int r, int s, unsigned char colour);
extern void cga_draw_ellipse_precomp1(int x0, int y0, int r, int s, unsigned char colour, unsigned char * arr);
extern void cga_draw_ellipse_precomp2(int x0, int y0, int r, int s, unsigned char colour, unsigned char * arr);
extern void cga_draw_ellipse_precompute(unsigned char * arr, int r, int s);

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

void cga_draw_line(int x0, int y0, int x1, int y1, unsigned char colour)
{
   int dx = x1 - x0;
   int dy = y1 - y0;
   int D;

   if (dx < 0 || (dy >= 0 && dy > dx) || (dy < 0 && -dy > dx)) /* verticalish */
   {
      if (dx < 0)
      {
         D = (-dx << 1) - dy;
         if (colour == 3)
            cga_draw_line3_11(x0, y0, dx, dy, D, y1);
         else if (colour == 0)
            cga_draw_line3_00(x0, y0, dx, dy, D, y1);
         else
            cga_draw_line3(x0, y0, dx, dy, D, y1, colour);
      } else
      {
         D = (dx << 1) - dy;
         if (colour == 0)
            cga_draw_line2_00(x0, y0, dx, dy, D, y1);
         else if (colour == 3)
            cga_draw_line2_11(x0, y0, dx, dy, D, y1);
         else
            cga_draw_line2(x0, y0, dx, dy, D, y1, colour);
      }
   } else /* horizontalish */
   {
      if (dy < 0)
         D = (-dy << 1) - dx;
      else
         D = (dy << 1) - dx;
      if (colour == 3)
         cga_draw_line1_11(x0, y0, dx, dy, D, x1);
      else if (colour == 0)
         cga_draw_line1_00(x0, y0, dx, dy, D, x1);
      else
         cga_draw_line1(x0, y0, dx, dy, D, x1, colour);
   }
}

void clear_lines()
{
   int i, j, start = 0, end = 319;

   for (i = 0; i < 200; i++)
   {
      cga_draw_line_blank1(start, 0, end - start, i, 2*i - end + start, end, 0);
   }

}

void box()
{
   int i, j;

   for (i = 0; i < 80; i++)
   {
      cga_draw_line1(0, 120+i, 80, 0, -80, 80, 3);
   }
}

void cga_draw_circle(int x0, int y0, int r, unsigned char colour)
{
   if (colour == 0)
   {
      cga_draw_circle1_00(x0, y0, r);
      cga_draw_circle2_00(x0, y0, r);
   } else if (colour == 3)
   {
      cga_draw_circle1_11(x0, y0, r);
      cga_draw_circle2_11(x0, y0, r);
   } else
   {
      cga_draw_circle1(x0, y0, r, colour);
      cga_draw_circle2(x0, y0, r, colour);
   }
}

void cga_draw_circle_blank(int x0, int y0, int r, unsigned char colour)
{
   cga_draw_circle_blank1(x0, y0, r, colour);
   cga_draw_circle_blank2(x0, y0, r, colour);
}

void cga_draw_ellipse(int x0, int y0, int r, int s, unsigned char colour)
{
   if (r == 0)
      cga_draw_line(x0, y0 - s, x0, y0 + s, colour);
   else if (s == 0)
      cga_draw_line(x0 - r, y0, x0 + r, s, colour);
   else
   {
      cga_draw_ellipse1(x0, y0, r, s, colour);
      cga_draw_ellipse2(x0, y0, r, s, colour);
   }
}

void cga_draw_ellipse_precomp(int x0, int y0, int r, int s, unsigned char colour, unsigned char * ellipse_data)
{
   cga_draw_ellipse_precomp1(x0, y0, r, s, colour, ellipse_data);
   cga_draw_ellipse_precomp2(x0, y0, r, s, colour, ellipse_data);
}

#define CGA5 1
#define PI 3.1415926

/* precomputed ellipse data, 16 bytes per ellipse */
unsigned char ellipse1[16*32];
unsigned char ellipse2[16*20];

int main(void)
{
   int i, j, l, gd, gm;
   unsigned char k;
   int xsize1[320];
   int ysize1[320];
   int xsize2[200];
   int ysize2[200];

   set_video_mode(4);

  /*
   gd = CGA;
   gm = CGAC1;
   initgraph(&gd, &gm, "c:\\tc");
   setbkcolor(BLUE);
   cleardevice();
  */

   /* precomputation */
   for (i = 5, j = 0; i < 320; i+=10, j++)
   {
      ysize1[i] = (int)(32.0*sin(PI*(double)i/320.0));
      xsize1[i] = (int)((1.0 - sin(PI*(double)i/320.0)/2.0)*ysize1[i]);

      cga_draw_ellipse_precompute(ellipse1 + (j<<4), xsize1[i] + 3, ysize1[i] + 3);
   }
  
   for (i = 5, j = 0; i < 200; i+=10, j++)
   {
      ysize2[i] = (int)(32.0*sin(PI*(double)i/200.0));
      xsize2[i] = (int)((1.0 - sin(PI*(double)i/200.0)/2.0)*ysize2[i]);

      cga_draw_ellipse_precompute(ellipse2 + (j<<4), ysize2[i] + 3, xsize2[i] + 3);
   }

   getchar();

   k = 0;

   for (j = 0; j < 70; j++)
   {
      for (i = 5, l = 0; i < 320; i+=10, l++)
      {
         cga_draw_ellipse_precomp(i, 199 - ((3*ysize1[i])>>1) - 3, xsize1[i] + 3, ysize1[i] + 3, k+1, ellipse1 + (l<<4));
         cga_draw_ellipse_precomp(320-i, ((3*ysize1[i])>>1) + 3, xsize1[i] + 3, ysize1[i] + 3, 0, ellipse1 + (l<<4));

         if ((i&7) == 7)
            k = ((k + 1) % 3);
      }

      for (i = 5, l = 0; i < 200; i+=10, l++)
      {
         cga_draw_ellipse_precomp(319 - ((3*ysize2[i])>>1) - 3, 200-i, ysize2[i] + 3, xsize2[i] + 3, k+1, ellipse2 + (l<<4));
         cga_draw_ellipse_precomp(((3*ysize2[i])>>1) + 3, i, ysize2[i] + 3, xsize2[i] + 3, 0, ellipse2 + (l<<4));

         if ((i&7) == 7)
            k = ((k + 1) % 3);
      }

      for (i = 5, l = 0; i < 320; i+=10, l++)
      {
         cga_draw_ellipse_precomp(320-i, ((3*ysize1[i])>>1) + 3, xsize1[i] + 3, ysize1[i] + 3, k+1, ellipse1 + (l<<4));
         cga_draw_ellipse_precomp(i, 199 - ((3*ysize1[i])>>1) - 3, xsize1[i] + 3, ysize1[i] + 3, 0, ellipse1 + (l<<4));

         if ((i&7) == 7)
            k = ((k + 1) % 3);
      }

      for (i = 5, l = 0; i < 200; i+=10, l++)
      {
         cga_draw_ellipse_precomp(((3*ysize2[i])>>1) + 3, i, ysize2[i] + 3, xsize2[i] + 3, k+1, ellipse2 + (l<<4));
         cga_draw_ellipse_precomp(319 - ((3*ysize2[i])>>1) - 3, 200-i, ysize2[i] + 3, xsize2[i] + 3, 0, ellipse2 + (l<<4));

         if ((i&7) == 7)
            k = ((k + 1) % 3);
      }
   }

   getchar();

   set_video_mode(3);

   /* closegraph();*/

   return 0;
}