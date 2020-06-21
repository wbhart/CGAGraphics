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

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

void cga_copy_line(unsigned char far * video, unsigned char far * buff, int line)
{
   int i, offset = 0, d;

   if (line & 1)
      offset += 8192;

   line = line >> 1;
   d = line;
   line <<= 2;
   d += line;
   offset += (d << 4);

   video += offset;
   buff += offset;

   for (i = 0; i < 80; i++)
      video[i] = buff[i];   
}

int main(void)
{
   int i, j, k, l;
   unsigned int b[4];
   unsigned int c[4];
   int lines[4];
   unsigned char far * buff1, far * buff2, far * video;

   getchar();

   set_video_mode(4);

   video = MK_FP(0xb800, 0);
   
   buff1 = farmalloc(16384);
   buff2 = farmalloc(16384);

   for (i = 0; i < 98; i++)
      cga_draw_hline(buff1, 0, 319, i, 0);
   for (i = 98; i < 200; i++)
      cga_draw_hline(buff1, 0, 319, i, 3);

   l = 1;
   for (j = 0, k = 80; j < 320; j += 40, k += 20)
   {
      for (i = 0; i < 40; i++)
         cga_draw_line(buff1, j + i, 199, k, 100, l);
      for (i = 0; i < 20; i++)
         cga_draw_line(buff1, j + 39, 199, k + i, 100, l);
      l = l == 1 ? 2 : 1;
   }

   for (i = 0; i < 98; i++)
      cga_draw_hline(buff2, 0, 319, i, 0);
   for (i = 98; i < 200; i++)
      cga_draw_hline(buff2, 0, 319, i, 3);

   l = 2;
   for (j = 0, k = 80; j < 320; j += 40, k += 20)
   {
      for (i = 0; i < 40; i++)
         cga_draw_line(buff2, j + i, 199, k, 100, l);
      for (i = 0; i < 20; i++)
         cga_draw_line(buff2, j + 39, 199, k + i, 100, l);
      l = l == 1 ? 2 : 1;
   }

   for (i = 0; i < 16384; i++)
      video[i] = buff1[i];

   getchar();

   for (i = 0; i < 16384; i++)
      video[i] = buff2[i];

   getchar();

   lines[0] = 100;
   lines[1] = 119;
   lines[2] = 142;
   lines[3] = 169;

   for (i = 0; i < 100; i++)
      cga_copy_line(video, buff1, i);

   for (i = lines[0]; i < lines[1]; i++)
      cga_copy_line(video, buff1, i);

   for (i = lines[1]; i < lines[2]; i++)
      cga_copy_line(video, buff2, i);

   for (i = lines[2]; i < lines[3]; i++)
      cga_copy_line(video, buff1, i);

   for (i = lines[3]; i < 200; i++)
      cga_copy_line(video, buff2, i);

   getchar();

   for (k = 0; k < 1000; k++)
   {
      b[0] = 32768;
      b[1] = 40724;
      b[2] = 48680;
      b[3] = 56636;
      c[0] = 0;
      c[1] = 202;
      c[2] = 8764;
      c[3] = 25686;
      lines[0] = 100;
      lines[1] = 119;
      lines[2] = 142;
      lines[3] = 169;

      for (i = 0; i < 34; i++)
      {
         for (j = 0; j < 4; j++)
         {
            unsigned int d;

            if ((j + k) & 1)
               cga_copy_line(video, buff1, lines[j]);
            else
               cga_copy_line(video, buff2, lines[j]);

            d = c[j] + b[j];
            if (d < c[j])
               lines[j]++;
            c[j] = d;
            b[j] += 234;
         }
      }
   }

   farfree(buff1);
   farfree(buff2);

   getchar();

   set_video_mode(3);

   return 0;
}
