#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <dos.h>

#include "graphics.h"
#include "sprite.h"

int line_isblank_h(unsigned char far *  video, int y, unsigned char key)
{
   int i;
   
   video += (80*(y/2));
   if (y & 1)
      video += 8192;

   for (i = 0; i < 80; i++)
      if (video[i] != key)
         return 0;

   return 1;
}

int line_isblank_v(unsigned char far * video, int x,
                                        int y0, int y1, unsigned char key)
{
   int i;

   video += (80*(y0/2) + (x/4));
   if (y0 & 1)
      video += 8192;

   for (i = y0; i <= y1; i++)
   {
      if (*video != key)
         return 0;

      if (i & 1)
         video -= (8192 - 80);
      else
         video += 8192;   
   }

   return 1;
}

void sprite_bounds(int * x0, int * y0, int * x1, int * y1,
                                     unsigned char far * video, char key)
{
   int i;

   key |= (key << 2);
   key |= (key << 4);

   for (i = 0; i < 200; i++)
   {
      if (!line_isblank_h(video, i, key))
         break;
   }
   *y0 = i;

   for (i = 199; i >= 0; i--)
   {
      if (!line_isblank_h(video, i, key))
         break;
   }
   *y1 = i;

   for (i = 0; i < 320; i += 4)
   {
      if (!line_isblank_v(video, i, *y0, *y1, key))
         break;
   }
   *x0 = i;

   for (i = 316; i >= 0; i -= 4)
   {
      if (!line_isblank_v(video, i, *y0, *y1, key))
         break;
   }
   *x1 = i + 3;

   return;
}

void get_sprite(unsigned char * sprite, unsigned char far * video,
                        int x0, int y0, int xsize, int ysize)
{
   int i, j, off;
   xsize >>= 2;
   x0 >>= 2;

   off = (80*(y0/2) + x0);
   if (y0 & 1)
      off += 8192;

   for (i = 0; i < ysize; i++)
   {
      for (j = 0; j < xsize; j++)
         sprite[i*xsize + j] = video[off + j];

      off ^= 8192;
      if ((i + y0) & 1)
          off += 80;
   }   
}

int main(void)
{
   int mode = 0;
   int ret, c, v, len, sbytes;
   unsigned char far * video = MK_FP(0xb800, 0x0000);
   int x0, y0, x1, y1, xsize, ysize;
   char filename[20];
   char outfile[20];
   unsigned char * sprite;
   FILE * sprite_file;

   printf("Enter video mode: ");
   if (!scanf("%d", &mode))
   {
      printf("Invalid input\n");
      abort();
   }

   while ((c = getchar()) != '\n' && c != EOF)
      /* discard */ ;

   printf("Input file (.pcx): ");
   gets(filename);

   strcpy(outfile, filename);
   len = strlen(outfile);
   strcpy(outfile + len - 4, ".dat");
   
   set_video_mode(mode);
   
   cga_display_pcx(filename);

   sprite_bounds(&x0, &y0, &x1, &y1, video, 0x0);

   xsize = x1 - x0 + 1;
   ysize = y1 - y0 + 1;

   sprite = (unsigned char *) malloc(ysize*(xsize/4));

   get_sprite(sprite, video, x0, y0, xsize, ysize);

   getchar();

   set_video_mode(3);

   sprite_file = fopen(outfile, "wb");

   sbytes =  fwrite(&xsize, 2, 1, sprite_file);
   sbytes += fwrite(&ysize, 2, 1, sprite_file);
   sbytes += fwrite(sprite, 1, ysize*(xsize/4), sprite_file);

   printf("x0: %d, y0: %d, x1: %d, y1: %d\n", x0, y0, x1, y1);
   printf("%d bytes written to: %s\n", sbytes, outfile);

   fflush(sprite_file);
   fclose(sprite_file);

   free(sprite);

   getchar();

   sprite_file = fopen(outfile, "rb");

   fread(&xsize, 2, 1, sprite_file);
   fread(&ysize, 2, 1, sprite_file);

   printf("Sprite %dx%d\n", xsize, ysize);
   getchar();

   sprite = (unsigned char *) malloc(ysize*(xsize/4));

   fread(sprite, 1, ysize*(xsize/4), sprite_file);

   set_video_mode(mode);

   sprite_display_direct(video, sprite, xsize, ysize);

   getchar();

   set_video_mode(3);

   fclose(sprite_file);

   free(sprite);

   return 0;
}
