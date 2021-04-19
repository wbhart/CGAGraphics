#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <dos.h>
#include <alloc.h>

extern void vga_plasma(unsigned char far * buff);
extern void set_fire_palette();

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

int main(void)
{
   int i, j, k;
   unsigned int ang, ang2;
   unsigned char xtab[40][320], shift[40][200], c;
   double sintab[256];
   const double pi = 3.1415926535898;
   const double alpha = 2.0*(pi/256);
   double theta0 = 1.5*(pi/64);
   double theta = theta0;
   double angle0 = 0.0;
   double angle = 0.0;
   unsigned char far * buff[40];
   printf("Welcome to Plasma 1.0\n");
   printf("Press a key to begin\n");

   for (k = 0; k < 40; k++)
      buff[k] = farmalloc(6560);

   angle = 0.0;
   for (i = 0; i < 256; i++)
   {
      sintab[i] = sin(angle);
      angle += alpha;
   }

   set_video_mode(19);
   set_fire_palette();

   for (k = 0; k < 40; k++)
   {
      for (i = 0, ang2 = 0; i < 200; i++, ang2+=13)
      {
         xtab[k][i] = 127.5*(sintab[255&(int)(angle/alpha)]+1.0) + (k<<4);
         angle += theta + theta*sintab[(ang2>>4)&255]/2;
      }
      theta0 -= 0.0006;
      theta = theta0;
      angle0 += 0.1;
      angle = angle0;
   }

   for (k = 0; k < 40; k++)
   {
      for (i = 0, ang2 = 0, ang = 0;
                               i < 160; i++, ang+=(48+k), ang2+=(96+2*k))
      {
         double factor = 50.0 + (100.0+((i+k)>>1))*(sintab[(ang2>>4)&255] + 1.0);
         buff[k][6400 + 159 - i] = ((((unsigned char) (factor*(sintab[(ang>>5)&255] + 1.0)))>>3)<<3);
      }
   }

   for (k = 0; k < 40; k++)
   {
      for (i = 0; i < 32; i++)
      {
         for (j = 0; j < 200; j++)
            buff[k][i*200 + j] = xtab[k][j] + (i<<3);
      }
   }

   for (i = 0; i < 50; i++)
   {
      for (k = 0; k < 40; k++)
         vga_plasma(buff[k]);

      delay(200);
/*
      for (k--; k >= 1; k--)
         vga_plasma(buff[k]);
*/
   }

   getch();

   for (k = 0; k < 40; k++)
      farfree(buff[k]);

   set_video_mode(3);

   return 0;
}