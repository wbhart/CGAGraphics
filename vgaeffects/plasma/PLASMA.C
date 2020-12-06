#include <stdio.h>
#include <conio.h>
#include <math.h>

extern void vga_plasma(unsigned char * sintab);
extern void text_mode(void);

int main(void)
{
   int i;
   unsigned char sintab[64];
   const double pi = 3.1415926536;
   const double theta = (2*pi/64);
   double angle = 0.0;

   printf("Welcome to Plasma 1.0\n");
   printf("Press a key to begin\n");

   getch();

   printf("Computing sin lookup table...\n");

   for (i = 0; i < 64; i++)
   {
      sintab[i] = 63.5*(sin(angle) + 1);
      angle += theta;
   }

   printf("...done\n");

   getch();
   
   vga_plasma(sintab);

   getch();

   text_mode();

   return 0;
}