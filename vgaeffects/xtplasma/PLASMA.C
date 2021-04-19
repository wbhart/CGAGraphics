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
   int i, j;
   unsigned char sintab[320], shift[200], c;
   const double pi = 3.1415926536;
   const double theta = 1.5*(pi/64);
   const double theta2 = 0.4*(pi/64);
   double angle = 0.0, angle2 = 0.0;
   unsigned char far * buff;
   printf("Welcome to Plasma 1.0\n");
   printf("Press a key to begin\n");

   getch();

   buff = farmalloc(64000);

   for (i = 0; i < 320; i++)
   {
      sintab[i] = 127.5*(sin(angle)+1.0);
      angle += theta + theta*sin(angle2)/2;
      angle2 += theta2;
   }

   angle2 = 0.0;
   for (i = 0; i < 200; i++)
   {
      double factor = 100.0 + 180.0*(sin(angle2) + 1.0);
      shift[i] = factor*(sin(angle) + 1.0);

      angle += theta;
      angle2 += theta;
   }

   for (i = 0; i < 200; i++)
   {
      for (j = 0; j < 320; j++)
         buff[i*320 + j] = sintab[j] + shift[i];  
   }

   set_video_mode(19);
   set_fire_palette();

   vga_plasma(buff);

   getch();

   farfree(buff);

   set_video_mode(3);

   return 0;
}