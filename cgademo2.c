#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <conio.h>
#include <dos.h>
#include <time.h>
#include <math.h>

extern void cga_draw_pixel(int x, int y, unsigned char colour);
extern void cga_set_y(int y);
extern void cga_draw_pixel_x(int x, unsigned char colour);
extern void cga_draw_hline(int x0, int x1, int y, unsigned char colour);
extern void cga_draw_vline(int x, int y0, int y1, unsigned char colour);

extern void cga_draw_line1(int x0, int y0, int dx, int dy,
                                       int D, int endx, unsigned char colour);
extern void cga_draw_line3(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);
extern void cga_draw_line4(int x0, int y0, int dx, int dy,
                                       int D, int endy, unsigned char colour);
extern int cga_draw_ellipse1(int x0, int y0, int r,
                                                 int s, unsigned char colour);
extern int cga_draw_ellipse2(int x0, int y0, int r,
                                                 int s, unsigned char colour);
extern void cga_draw_ellipse3(int x0, int y0, int r,
                                                 int s, unsigned char colour);
extern void cga_draw_ellipse4(int x0, int y0, int r,
                                                 int s, unsigned char colour);
extern int ellipse_array(unsigned char far * buff, int r, int s);
extern void cga_draw_ellipse_array1(unsigned char far * buff,
    int x0, int y0, unsigned char far * end1, unsigned char far * end2,
                              unsigned char far * end3, unsigned char colour); 
extern void cga_draw_ellipse_array2(unsigned char far * buff,
    int x0, int y0, unsigned char far * end1, unsigned char far * end2,
                              unsigned char far * end3, unsigned char colour); 
extern void cga_draw_ellipse_array3(unsigned char far * buff,
    int x0, int y0, unsigned char far * end1, unsigned char far * end2,
                              unsigned char far * end3, unsigned char colour); 
extern void cga_draw_ellipse_array4(unsigned char far * buff,
    int x0, int y0, unsigned char far * end1, unsigned char far * end2,
                              unsigned char far * end3, unsigned char colour); 

long int cx0, cy0, cx1, cy1;
int mode;

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

int cga_first_intercept_horiz(int * D, int x0, int y0, int dx, int dy, long int y)
{
   long int a = (((dy + (y - y0)*dx) << 1) - dx)/(dy << 1);
         
   (*D) = (int) (((dy - (y - y0)*dx) + a*dy) << 1) - dx;

   return x0 + (int) a;
}

int cga_last_intercept_horiz(int x0, int y0, int dx, int dy, long int y)
{
   long int b = (dx*(1 + ((y - y0) << 1)))/(dy << 1);
   
   return x0 + (int) b;
}

int cga_first_intercept_vert(int * D, int x0, int y0, int dx, int dy, long int x)
{
   long int D1 = (((x - x0)*dy) << 1) - dx;
   long int c = ((D1 + (dx << 1) - 1)/(dx << 1));

   (*D) = (int) (D1 + (dy << 1) - ((c*dx) << 1));

   return y0 + (int) c;
}

int cga_line_cmp(int x0, int y0, int dx, int dy, long int x, long int y)
{
   long int diff = (((x - x0)*dy) << 1) - (((y - y0)*dx) << 1) - dx;
   int dh = (diff >> 16);
   return dh == 0 ? (diff != 0L) : dh;
}

void cga_draw_pixel_clipped(int x, int y, unsigned char colour)
{
   if (x >= cx0 && x <= cx1 && y >= cy0 && y <= cy1)
      cga_draw_pixel(x, y, colour);
}

void cga_draw_hline_clipped(int x0, int x1, int y, unsigned char colour)
{
   if (y >= cy0 && y <= cy1 && x0 <= cx1 && x1 >= cx0)
   {
      if (x0 < cx0)
         x0 = cx0;

      if (x1 > cx1)
         x1 = cx1;

      cga_draw_hline(x0, x1, y, colour);
   }
}

void cga_draw_vline_clipped(int x, int y0, int y1, unsigned char colour)
{
   if (x >= cx0 && x <= cx1 && y0 <= cy1 && y1 >= cy0)
   {
      if (y0 < cy0)
         y0 = cy0;

      if (y1 > cy1)
         y1 = cy1;

      cga_draw_vline(x, y0, y1, colour);
   }
}

void cga_draw_line(int x0, int y0, int x1, int y1, unsigned char colour)
{
   int dx = x1 - x0;
   int dy = y1 - y0;
   int D;

   /* ensure y1 >= y0 */
   if (dy < 0)
   {
      cga_draw_line(x1, y1, x0, y0, colour);

      return;
   }

   if (dx >= 0)
   {
      if (dx >= dy)
      {
         D = 2*dy - dx;
         cga_draw_line1(x0, y0, dx, dy, D, x1, colour);
      } else /* dx < dy */
      {
         D = 2*dx - dy;
         cga_draw_line3(x0, y0, dx, dy, D, y1, colour);
      }
   } else /* dx < 0 */
   {
      dx = -dx;

      if (dx >= dy)
      {
         D = 2*dy - dx;
         cga_draw_line1(x0, y0, -dx, dy, D, x1, colour);
      } else /* dx < dy */
      {
         D = 2*dx - dy;
         cga_draw_line4(x0, y0, dx, dy, D, y1, colour);
      }
   }
}

void cga_draw_line_clipped(int x0, int y0, int x1, int y1, unsigned char colour)
{
   int dx = x1 - x0;
   int dy = y1 - y0;

   /* ensure y1 >= y0 */
   if (dy < 0)
   {
      cga_draw_line_clipped(x1, y1, x0, y0, colour);

      return;
   }

   if (dx >= 0)
   {
      if (dx >= dy)
      {
         /* check we don't miss the clip box (inclusive) entirely */
         if (x0 <= cx1 && y0 <= cy1 && x1 >= cx0 && y1 >= cy0 &&
            (y0 >= cy0 || cga_line_cmp(x0, y0, dx, dy, cx1, cy0 - 1) > 0) &&
            (x0 >= cx0 || cga_line_cmp(x0, y0, dx, dy, cx0, cy1) <= 0))
         {
            int D, y, x, endx;

            /* if we go above the top left corner of clip box (incl.) */
            if (y0 < cy0 &&
               (x0 > cx0 || cga_line_cmp(x0, y0, dx, dy, cx0, cy0 - 1) <= 0))
            {
               x = cga_first_intercept_horiz(&D, x0, y0, dx, dy, cy0);
               y = cy0;
            } else if (x0 <= cx0)
            {
               y = dx == 0 ? cy0 : cga_first_intercept_vert(&D, x0, y0, dx, dy, cx0);
               x = cx0;
            } else
            {
               D = 2*dy - dx;
               y = y0;
               x = x0;
            }

            if (x1 > cx1 && cga_line_cmp(x0, y0, dx, dy, cx1, cy1) <= 0)
               endx = cx1;
            else if (y1 > cy1)
               endx = cga_last_intercept_horiz(x0, y0, dx, dy, cy1);
            else
               endx = x1;            

            cga_draw_line1(x, y, dx, dy, D, endx, colour);
         }
      } else /* dx < dy */
      {
         /* check we don't miss the clip box (inclusive) entirely */
         if (y0 <= cy1 && x0 <= cx1 && y1 >= cy0 && x1 >= cx0 &&
            (x0 >= cx0 || cga_line_cmp(y0, x0, dy, dx, cy1, cx0 - 1) > 0) &&
            (y0 >= cy0 || cga_line_cmp(y0, x0, dy, dx, cy0, cx1) <= 0))
         {
            int D, x, y, endy;

            /* if we go to left of the top left corner of clip box (incl.) */
            if (x0 < cx0 &&
               (y0 > cy0 || cga_line_cmp(y0, x0, dy, dx, cy0, cx0 - 1) <= 0))
            {
               y = cga_first_intercept_horiz(&D, y0, x0, dy, dx, cx0);
               x = cx0;
            } else if (y0 <= cy0)
            {
               x = cga_first_intercept_vert(&D, y0, x0, dy, dx, cy0);
               y = cy0;
            } else
            {
               D = 2*dx - dy;
               x = x0;
               y = y0;
            }

            if (y1 > cy1 && cga_line_cmp(y0, x0, dy, dx, cy1, cx1) <= 0)
               endy = cy1;
            else if (x1 > cx1)
               endy = cga_last_intercept_horiz(y0, x0, dy, dx, cx1);
            else
               endy = y1;            

            cga_draw_line3(x, y, dx, dy, D, endy, colour);
         }
      }
   } else /* dx < 0 */
   {
      dx = -dx;

      if (dx >= dy)
      {
         /* flip all coords about vertical line mid way between y0 and y1 */
         int fcy0 = y0 + y1 - cy0;
         int fcy1 = y0 + y1 - cy1;
      
         /* check we don't miss the clip box (inclusive) entirely */
         if (x0 <= cx1 && y1 <= cy1 && x1 >= cx0 && y0 >= cy0 &&
            (y1 >= fcy1 || cga_line_cmp(x0, y1, dx, dy, cx1, fcy1 - 1) > 0) &&
            (x0 >= cx0 || cga_line_cmp(x0, y1, dx, dy, cx0, fcy0) <= 0))
         {
            int D, y, x, endx;

            /* if we go above the top left corner of clip box (incl.) */
            if (y1 < fcy1 &&
               (x0 > cx0 || cga_line_cmp(x0, y1, dx, dy, cx0, fcy1 - 1) <= 0))
            {
               x = cga_first_intercept_horiz(&D, x0, y1, dx, dy, fcy1);
               y = cy1;
            } else if (x0 <= cx0)
            {
               y = dx == 0 ? cy1 : y0 + y1 - cga_first_intercept_vert(&D, x0, y1, dx, dy, fcx1);
               x = cx0;
            } else
            {
               D = 2*dy - dx;
               y = y0;
               x = x0;
            }

            if (x1 > cx1 && cga_line_cmp(x0, y1, dx, dy, cx1, fcy0) <= 0)
               endx = cx1;
            else if (y0 > fcy0)
               endx = cga_last_intercept_horiz(x0, y1, dx, dy, fcy0);
            else
               endx = x1;            

            cga_draw_line1(x, y, dx, -dy, D, endx, colour);
         }
      } else /* dx < dy */
      {
         /* flip all coords about vertical line mid way between x0 and x1 */
         int fcx0 = x0 + x1 - cx0;
         int fcx1 = x0 + x1 - cx1;

         /* check we don't miss the clip box (inclusive) entirely */
         if (y0 <= cy1 && x1 <= cx1 && y1 >= cy0 && x0 >= cx0 &&
            (x1 >= fcx1 || cga_line_cmp(y0, x1, dy, dx, cy1, fcx1 - 1) > 0) &&
            (y0 >= cy0 || cga_line_cmp(y0, x1, dy, dx, cy0, fcx0) <= 0))
         {
            int D, x, y, endy;

            /* if we go to right the top right corner of clip box (incl.) */
            if (x1 < fcx1 &&
               (y0 > cy0 || cga_line_cmp(y0, x1, dy, dx, cy0, fcx1 - 1) <= 0))
            {
               y = cga_first_intercept_horiz(&D, y0, x1, dy, dx, fcx1);
               x = cx1;
            } else if (y0 <= cy0)
            {
               x = x0 + x1 - cga_first_intercept_vert(&D, y0, x1, dy, dx, cy0);
               y = cy0;
            } else
            {
               D = 2*dx - dy;
               x = x0;
               y = y0;
            }

            if (y1 > cy1 && cga_line_cmp(y0, x1, dy, dx, cy1, fcx0) <= 0)
               endy = cy1;
            else if (x0 > fcx0)
               endy = cga_last_intercept_horiz(y0, x1, dy, dx, fcx0);
            else
               endy = y1;            

            cga_draw_line4(x, y, dx, dy, D, endy, colour);
         }
      }
   }
}

void cga_draw_ellipse(int x0, int y0, int r, int s, unsigned char colour)
{
   if (!cga_draw_ellipse1(x0, y0, r, s, colour))
        cga_draw_ellipse3(x0, y0, r, s, colour);

   if (!cga_draw_ellipse2(x0, y0, r, s, colour))
        cga_draw_ellipse4(x0, y0, r, s, colour);

/*
   {
      int c = s*s;
      int a = r*r;
      int x = r;
      int y = 0;
      long int D = 0;
      long int xdelta = 2*(c*(long int) r);
      long int ydelta = a;
      int xr = x, yr = y;
      while (xdelta >= ydelta)
      {
         cga_draw_pixel(x0 + x, y0 + y, colour);
         cga_draw_pixel(x0 + x, y0 - y, colour);
         xr = x; yr = y;
         D += ydelta; ydelta += a; ydelta += a; y++;
         if (D >= xdelta/2)
         {
            xdelta -= c; D -= xdelta; xdelta -= c; x--;
         }
      }
      D = -D;
      while (xdelta >= 0)
      {
         cga_draw_pixel(x0 + x, y0 + y, colour);
         cga_draw_pixel(x0 + x, y0 - y, colour);
         xr = x; yr = y;
         xdelta -= c; D += xdelta; xdelta -= c; x--;
         if (D > ydelta/2)
         {
            D -= ydelta; ydelta += a; ydelta += a; y++;
         }
      }
   }
*/
}

void cga_draw_ellipse_array(int x0, int y0, int r, int s, unsigned char colour)
{
   unsigned char far * buff = farmalloc(r + s + 1);
   unsigned int ret;
   int len;
   int snd;

   ret = ellipse_array(buff, r, s);

   len = (int) (ret & 255);
   snd = (int) (ret >> 8);
 
   cga_draw_ellipse_array1(buff, x0 + r, y0, buff + snd, buff + len, buff + len, colour);
   cga_draw_ellipse_array2(buff, x0 + r, y0, buff + snd, buff + len, buff + len, colour);
   cga_draw_ellipse_array3(buff, x0 - r, y0, buff + snd, buff + len, buff + len, colour);
   cga_draw_ellipse_array4(buff, x0 - r, y0, buff + snd, buff + len, buff + len, colour);

   farfree(buff);
}

void cga_draw_ellipse_clipped(int x0, int y0, int r, int s, unsigned char colour)
{
   /* check there is something to draw */
   if (x0 - r <= cx1 && x0 + r >= cx0 &&
       y0 - s <= cy1 && y0 + s >= cy0)
   {
      unsigned char far * buff = farmalloc(r + s + 1);
      unsigned int ret;
      int len;
      int snd;
      int draw_top, draw_bot;
      int xstart, ystart, xend, yend;
      int off1, off2, off3;

      ret = ellipse_array(buff, r, s);

      len = (int) (ret & 255);
      snd = (int) (ret >> 8);
 
      draw_top = y0 >= cy0;
      draw_bot = y0 <= cy1;

      /* check we have to draw the right side */
      if (x0 <= cx1)
      {
         if (draw_bot)
         {
            xstart = min(x0 + r, cx1);
            ystart = max(y0, cy0);

            /* find start in buffer */
            if (ystart - y0 < snd)
            {
               off1 = ystart - y0;
               while (off1 < snd && buff[off1] + x0 > cx1)
                  off1++;
               xstart = buff[off1] + x0;
               ystart = off1 + y0;
               if (off1 == snd)
               {
                  while (off1 < len && len - off1 + x0 - 1 > cx1)
                     off1++;
                  xstart = len - off1 + x0 - 1;
                  ystart = y0 + buff[off1];
               }
            } else
            {
               off1 = max(snd, len - xstart + x0 - 1);
               while (off1 < len && buff[off1] + y0 < cy0)
                     off1++;
               xstart = len - off1 + x0 - 1;
               ystart = y0 + buff[off1];
            }

            xend = max(x0, cx0);
            yend = min(y0 + s, cy1);

            /* find end in buffer */
            if (yend - y0 < snd)
            {
               off3 = yend - y0;
               while (off3 >= off1 && buff[off3] + x0 < cx0)
                  off3--;
            } else
            {
               off3 = max(snd - 1, len - xend + x0 - 1);
               while (off3 >= snd && buff[off3] + y0 > cy1)
                  off3--;
               if (off3 < snd)
               {
                  while (off3 >= off1 && buff[off3] + x0 < cx0)
                     off3--;
               }               
            }

            if (off3 >= off1)
            {
               off3++;

               off2 = min(max(off1, snd), off3);

               cga_draw_ellipse_array1(buff + off1, xstart, ystart, buff + off2, buff + off3, buff + len, colour);
            }
         }

         if (draw_top)
         {
            xstart = min(x0 + r, cx1);
            ystart = min(y0, cy1);

            /* find start in buffer */
            if (y0 - ystart < snd)
            {
               off1 = y0 - ystart;
               while (off1 < snd && buff[off1] + x0 > cx1)
                  off1++;
               xstart = buff[off1] + x0;
               ystart = y0 - off1;
               if (off1 == snd)
               {
                  while (off1 < len && len - off1 + x0 - 1 > cx1)
                     off1++;
                  xstart = len - off1 + x0 - 1;
                  ystart = y0 - buff[off1];
               }
            } else
            {
               off1 = max(snd, len - xstart + x0 - 1);
               while (off1 < len && y0 - buff[off1] > cy1)
                     off1++;
               xstart = len - off1 + x0 - 1;
               ystart = y0 - buff[off1];
            }

            xend = max(x0, cx0);
            yend = max(y0 - s, cy0);

            /* find end in buffer */
            if (y0 - yend < snd)
            {
               off3 = y0 - yend;
               while (off3 >= off1 && buff[off3] + x0 < cx0)
                  off3--;
            } else
            {
               off3 = max(snd - 1, len - xend + x0 - 1);
               while (off3 >= snd && y0 - buff[off3] < cy0)
                  off3--;
               if (off3 < snd)
               {
                  while (off3 >= off1 && buff[off3] + x0 < cx0)
                     off3--;
               }               
            }

            if (off3 >= off1)
            {
               off3++;

               off2 = min(max(off1, snd), off3);

               cga_draw_ellipse_array2(buff + off1, xstart, ystart, buff + off2, buff + off3, buff + len, colour);
            }
         }
      }

      /* check we have to draw the left side */
      if (x0 >= cx0)
      {
         if (draw_bot)
         {
            xstart = max(x0 - r, cx0);
            ystart = max(y0, cy0);

            /* find start in buffer */
            if (ystart - y0 < snd)
            {
               off1 = ystart - y0;
               while (off1 < snd && x0 - buff[off1] < cx0)
                  off1++;
               xstart = x0 - buff[off1];
               ystart = off1 + y0;
               if (off1 == snd)
               {
                  while (off1 < len && off1 - len + x0 + 1 < cx0)
                     off1++;
                  xstart = off1 - len + x0 + 1;
                  ystart = y0 + buff[off1];
               }
            } else
            {
               off1 = max(snd, len + xstart - x0 - 1);
               while (off1 < len && buff[off1] + y0 < cy0)
                     off1++;
               xstart = off1 - len + x0 + 1;
               ystart = y0 + buff[off1];
            }

            xend = min(x0, cx1);
            yend = min(y0 + s, cy1);

            /* find end in buffer */
            if (yend - y0 < snd)
            {
               off3 = yend - y0;
               while (off3 >= off1 && x0 - buff[off3] > cx1)
                  off3--;
            } else
            {
               off3 = max(snd - 1, len + xend - x0 - 1);
               while (off3 >= snd && buff[off3] + y0 > cy1)
                  off3--;
               if (off3 < snd)
               {
                  while (off3 >= off1 && x0 - buff[off3] > cx1)
                     off3--;
               }               
            }

            if (off3 >= off1)
            {
               off3++;

               off2 = min(max(off1, snd), off3);

               cga_draw_ellipse_array3(buff + off1, xstart, ystart, buff + off2, buff + off3, buff + len, colour);
            }
         }

         if (draw_top)
         {
            xstart = max(x0 - r, cx0);
            ystart = min(y0, cy1);

            /* find start in buffer */
            if (y0 - ystart < snd)
            {
               off1 = y0 - ystart;
               while (off1 < snd && x0 - buff[off1] < cx0)
                  off1++;
               xstart = x0 - buff[off1];
               ystart = y0 - off1;
               if (off1 == snd)
               {
                  while (off1 < len && off1 - len + x0 + 1 < cx0)
                     off1++;
                  xstart = off1 - len + x0 + 1;
                  ystart = y0 - buff[off1];
               }
            } else
            {
               off1 = max(snd, len + xstart - x0 - 1);
               while (off1 < len && y0 - buff[off1] > cy1)
                     off1++;
               xstart = off1 - len + x0 + 1;
               ystart = y0 - buff[off1];
            }

            xend = min(x0, cx1);
            yend = max(y0 - s, cy0);

            /* find end in buffer */
            if (y0 - yend < snd)
            {
               off3 = y0 - yend;
               while (off3 >= off1 && x0 - buff[off3] > cx1)
                  off3--;
            } else
            {
               off3 = max(snd - 1, len + xend - x0 - 1);
               while (off3 >= snd && y0 - buff[off3] < cy0)
                  off3--;
               if (off3 < snd)
               {
                  while (off3 >= off1 && x0 - buff[off3] > cx1)
                     off3--;
               }               
            }

            if (off3 >= off1)
            {
               off3++;

               off2 = min(max(off1, snd), off3);

               cga_draw_ellipse_array4(buff + off1, xstart, ystart, buff + off2, buff + off3, buff + len, colour);
            }
         }
      }

      farfree(buff);
   }
}

void cga_blank_screen()
{
   int i;

   for (i = 0; i < 200; i++)
      cga_draw_hline(0, 319, i, 0);
}

typedef struct star
{
   int x;
   int y;
   int oldx;
   int oldy;
   int z;
} star;

#define NUM_STARS 100

void cga_starfield(int clipped)
{
   int i, j, first = 1;
   star st[NUM_STARS];

   /* create random stars */
   for (i = 0; i < NUM_STARS; i++)
   {
      st[i].x = random(256);
      st[i].y = random(256);
      st[i].z = random(256);
   }

   while (!kbhit())
   {
      for (i = 0; i < NUM_STARS; i++)
      {
         int x, y;

         if (!first)
         {
            x = st[i].oldx;
            y = st[i].oldy;

            /* blank old star */
            if (clipped)
            {
               cga_draw_pixel_clipped(x, y, 0);
            } else
            {
               if (x >= 0 && x < 320 && y >= 0 && y < 200)
                  cga_draw_pixel(st[i].oldx, st[i].oldy, 0);
            }
         }

         /* update position */
         st[i].z -= 2;

         if (st[i].z > -100)
         {
            /* draw new star */
            st[i].oldx = x = 160 + (st[i].x*256)/(150 + st[i].z);
            st[i].oldy = y = 100 + (st[i].y*256)/(100 + st[i].z);
           
            if (clipped)
            {
               cga_draw_pixel_clipped(x, y, ((st[i].z < 150)<<1) + 1);
            } else
            {
               if (x >= 0 && x < 320 && y >= 0 && y < 200)
                  cga_draw_pixel(x, y, ((st[i].z < 150)<<1) + 1);
            }
         } else
         {
            /* generate new star */
            st[i].x = random(256);
            st[i].y = random(256);
            st[i].z = 256;
         }
      }

      first = 0;      
   }

   getch();

   cga_blank_screen();   
}

void rotate_point(double * coords, double x, double y, double z, double rot1, double rot2)
{
   double c1 = cos(rot1), s1 = sin(rot1);
   double c2 = cos(rot2), s2 = sin(rot2);
   double sc1 = s1*x + c1*y;

   coords[0] = c1*x - s1*y;
   coords[1] = c2*sc1 - s2*z;
   coords[2] = s2*sc1 + c2*z;
}

void xyz2xy(int * icoords, double * coords)
{
   icoords[0] = (int) (160.5 + (coords[0]*256.0)/(150.0 + coords[2]));
   icoords[1] = (int) (100.5 + (coords[1]*256.0)/(100.0 + coords[2]));
}

void draw_tetrahedron(int * icoords, unsigned char colour)
{
   cga_draw_line_clipped(icoords[0], icoords[1], icoords[2], icoords[3], colour);
   cga_draw_line_clipped(icoords[0], icoords[1], icoords[4], icoords[5], colour);
   cga_draw_line_clipped(icoords[0], icoords[1], icoords[6], icoords[7], colour);
   cga_draw_line_clipped(icoords[2], icoords[3], icoords[4], icoords[5], colour);
   cga_draw_line_clipped(icoords[2], icoords[3], icoords[6], icoords[7], colour);
   cga_draw_line_clipped(icoords[4], icoords[5], icoords[6], icoords[7], colour);
}

void move_clipbox()
{
   switch (mode)
   {
      case 0:
         cx0 += 1; cx1 += 1;
         if (cx0 == 110)
            mode = 1;
         break;
      case 1:
         cy0 += 1; cy1 += 1;
         if (cy0 == 80)
            mode = 2;
         break;
      case 2:
         cx0 -= 1; cx1 -= 1;
         if (cx0 == 50)
            mode = 3;
         break;
      case 3:
         cy0 -= 1; cy1 -= 1;
         if (cy0 == 20)
            mode = 0;
         break; 
   }
}

int main(void)
{
   int i, j, k;
   double coords[12]; /* rotated coordinates */
   double rot1 = 0.05, rot2 = 0.01;
   int icoords[8];
   int icoords1[8];
   int * oldcoords, * newcoords, * tmp;

   mode = 0;

   cx0 = 50;
   cx1 = 209;
   cy0 = 20;
   cy1 = 119;

   randomize();

   coords[0] =  30.0;  coords[1] =   0.0;  coords[2] = -21.213203;
   coords[3] = -30.0;  coords[4] =   0.0;  coords[5] = -21.213203;
   coords[6] =   0.0;  coords[7] =  30.0;  coords[8] =  21.213203;
   coords[9] =   0.0; coords[10] = -30.0; coords[11] =  21.213203;

   for (j = 0, k = 0; j < 12; j += 3, k += 2)
      xyz2xy(icoords + k, coords + j);

   set_video_mode(4);

   cga_draw_line(cx0 - 1, cy0 - 1, cx1 + 1, cy0 - 1, 1);
   cga_draw_line(cx0 - 1, cy1 + 1, cx1 + 1, cy1 + 1, 1);
   cga_draw_line(cx0 - 1, cy0 - 1, cx0 - 1, cy1 + 1, 1);
   cga_draw_line(cx1 + 1, cy0 - 1, cx1 + 1, cy1 + 1, 1);

   draw_tetrahedron(icoords, 2);

   oldcoords = icoords;
   newcoords = icoords1;

   getchar();

   for (i = 0; i < 10000; i++)
   {
      rotate_point(coords + 0,  30.0,   0.0, -21.213203, rot1, rot2);
      rotate_point(coords + 3, -30.0,   0.0, -21.213203, rot1, rot2);
      rotate_point(coords + 6,   0.0,  30.0,  21.213203, rot1, rot2);
      rotate_point(coords + 9,   0.0, -30.0,  21.213203, rot1, rot2);

      for (j = 0, k = 0; j < 12; j += 3, k += 2)
        xyz2xy(newcoords + k, coords + j);

      if (mode == 0)
      {

         cga_draw_line(cx0, cy0 - 1, cx0, cy1 + 1, 1);
         cga_draw_line(cx1 + 2, cy0 - 1, cx1 + 2, cy1 + 1, 1);
         cga_draw_line(cx0 - 1, cy0 - 1, cx0 - 1, cy1 + 1, 0);
         cga_draw_line(cx1 + 1, cy0 - 1, cx1 + 1, cy1 + 1, 0);
      } else if (mode == 1)
      {
         cga_draw_line(cx0 - 1, cy0, cx1 + 1, cy0, 1);
         cga_draw_line(cx0 - 1, cy1 + 2, cx1 + 1, cy1 + 2, 1);
         cga_draw_line(cx0 - 1, cy0 - 1, cx1 + 1, cy0 - 1, 0);
         cga_draw_line(cx0 - 1, cy1 + 1, cx1 + 1, cy1 + 1, 0);
      } else if (mode == 2)
      {
         cga_draw_line(cx0 - 2, cy0 - 1, cx0 - 2, cy1 + 1, 1);
         cga_draw_line(cx1, cy0 - 1, cx1, cy1 + 1, 1);
         cga_draw_line(cx0 - 1, cy0 - 1, cx0 - 1, cy1 + 1, 0);
         cga_draw_line(cx1 + 1, cy0 - 1, cx1 + 1, cy1 + 1, 0);
      }  else
      {
         cga_draw_line(cx0 - 1, cy0 - 2, cx1 + 1, cy0 - 2, 1);
         cga_draw_line(cx0 - 1, cy1, cx1 + 1, cy1, 1);
         cga_draw_line(cx0 - 1, cy0 - 1, cx1 + 1, cy0 - 1, 0);
         cga_draw_line(cx0 - 1, cy1 + 1, cx1 + 1, cy1 + 1, 0);
      } 

      draw_tetrahedron(oldcoords, 0);

      move_clipbox();

      cga_draw_line(cx0 - 1, cy0 - 1, cx1 + 1, cy0 - 1, 1);
      cga_draw_line(cx0 - 1, cy1 + 1, cx1 + 1, cy1 + 1, 1);
      cga_draw_line(cx0 - 1, cy0 - 1, cx0 - 1, cy1 + 1, 1);
      cga_draw_line(cx1 + 1, cy0 - 1, cx1 + 1, cy1 + 1, 1);

      draw_tetrahedron(newcoords, 2);
         
      tmp = oldcoords;
      oldcoords = newcoords;
      newcoords = tmp;

      rot1 += 0.05;
      rot2 += 0.01;
   }

   getchar();

   set_video_mode(3);

   return 0;
}