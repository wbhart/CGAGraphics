#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <dos.h>
#include <math.h>
#include <assert.h>
#include "pcx.h"

extern void cga_retrace();

extern void cga_draw_hline(unsigned char far * buff,
                                 int x0, int x1, int y, unsigned char colour);

extern void rotozoom(unsigned char far * buff,
                        unsigned char x, unsigned char y, int xinc, int yinc);

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

void set_video_char_height(unsigned char pixels)
{
   unsigned char total = 32*(8/pixels) - 1;
   unsigned char displayed = 25*(8/pixels);
   unsigned char sync = displayed + 3*(8/pixels);

   pixels--;

   asm push ds
   asm push ax
   asm push dx
   asm push si

   asm mov ax, 0040h /* get current value of mode-set register */
   asm mov ds, ax
   asm mov si, 0065h
   asm mov al, [si]

   asm xor al, 08h /* disable video */
   asm mov dx, 03d8h
   asm out dx, al
   asm mov [si], al

   asm xor ax, ax  /* get address of video initialisation table */
   asm mov ds, ax
   asm mov si, 0074h
   asm mov ax, [si]
   asm mov ds, ax
   asm mov si, [si+2]

   asm mov dx, 03d4h /* set current max scan line address */
   asm mov al, 09h
   asm out dx, al
   asm mov dx, 03d5h
   asm mov al, pixels
   asm out dx, al
   asm mov [si+9], al

   asm mov dx, 03d4h /* set vertical total */
   asm mov al, 04h
   asm out dx, al
   asm mov dx, 03d5h
   asm mov al, total
   asm out dx, al
   asm mov [si+4], al

   asm mov dx, 03d4h /* set vertical displayed */
   asm mov al, 06h
   asm out dx, al
   asm mov dx, 03d5h
   asm mov al, displayed
   asm out dx, al
   asm mov [si+6], al

   asm mov dx, 03d4h /* set vertical sync position */
   asm mov al, 07h
   asm out dx, al
   asm mov dx, 03d5h
   asm mov al, sync
   asm out dx, al
   asm mov [si+7], al

   asm mov ax, 0040h /* get current value of mode-set register */
   asm mov ds, ax
   asm mov si, 0065h
   asm mov al, [si]

   asm xor al, 08h /* enable video */
   asm mov dx, 03d8h
   asm out dx, al
   asm mov [si], al

   asm pop si
   asm pop dx
   asm pop ax
   asm pop ds
}

void set_video_blink_toggle()
{
   asm push ds
   asm push ax
   asm push dx
   asm push si

   asm mov ax, 0040h /* get current value of mode-set register */
   asm mov ds, ax
   asm mov si, 0065h
   asm mov al, [si]

   asm xor al, 08h /* disable video */
   asm mov dx, 03d8h
   asm out dx, al
   asm mov [si], al

   asm xor al, 08h /* enable video */
   asm xor al, 020h /* toggle blink */
   asm mov dx, 03d8h
   asm out dx, al
   asm mov [si], al

   asm pop si
   asm pop dx
   asm pop ax
   asm pop ds
}

void far * buff_alloc(unsigned long nbytes)
{
   void far * buff = farmalloc(nbytes + 8);
   if (buff == NULL)
   {
       printf("Insufficient memory\n");
       abort();
   }

   assert(FP_OFF(buff) == 8);

   return MK_FP(FP_SEG(buff)+1, FP_OFF(buff)-8);
}

void buff_free(void far * buff)
{
   farfree(MK_FP(FP_SEG(buff)-1, FP_OFF(buff)+8));
}

void bitplanes_to_rgbi(unsigned char far * rgbi,
                          unsigned char far * bp, int rows, int bytes_per_row)
{
   int n = bytes_per_row/4;
   unsigned char p1, p2, p3, p4, t;
   int i, j, k;

   for (i = 0; i < rows; i++)
   {
      for (j = 0, k = 0; j < n; j++, k += 8)
      {
         p1 = bp[j];
         p2 = bp[j + n];
         p3 = bp[j + 2*n];
         p4 = bp[j + 3*n];

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 7] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 6] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 5] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 4] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 3] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 2] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         p4 >>= 1; p3 >>= 1; p2 >>= 1; p1 >>= 1;
         rgbi[k + 1] = t + (t<<4);

         t = ((p4&1)<<3) + ((p3&1)<<2) + ((p2&1)<<1) + (p1&1);
         rgbi[k] = t + (t<<4);
      }

      bp += bytes_per_row;
      rgbi += 2*bytes_per_row;
   }
}

int main(void)
{
   int i, j, k, l;
   int x, y, inc;
   unsigned char far * buff, far * bp, far * video;
   pcx_header_s header;
   FILE * file;
   double sintab[100];
   double costab[100];
   double theta = 0.0;

   randomize();

   printf("WARNING: this demo requires CGA hardware. It may damage EGA/VGA machines\n");
   printf("If you don't have a CGA or clone CGA card press CTRL-C or reset now!\n");
   printf("The responsibility is yours. Press ENTER if you wish to continue.\n");

   getchar();

   printf("Computing sine/cosine table \n");

   for (i = 0; i < 100; i++)
   {
      sintab[i] = sin(theta);
      costab[i] = cos(theta);
      theta += 0.0628318;
   }

   printf("Loading graphic\n");

   bp = buff_alloc(33768);
   if (bp == NULL)
   {
      printf("Insufficient memory\n");
      abort();
   }
   
   buff = buff_alloc(65536);
   if (buff == NULL)
   {
      printf("Insufficient memory\n");
      abort();
   }

   file = fopen("pcretro.pcx", "rb");
   if (file == NULL)
   {
      printf("Unable to open pcretro.pcx\n");
      abort();
   }

   pcx_header_read(&header, file);

   pcx_buffer_load(bp, file, header.bytes_per_line*header.nplanes,
                                                   header.y1 - header.y0 + 1);
   fclose(file);

   printf("Converting to RGBI\n");

   bitplanes_to_rgbi(buff, bp, 256, 128);
   buff_free(bp);

   video = MK_FP(0xb800, 0);

   set_video_mode(1);

   for (i = 0; i < 2000; i++)
   {
      video[2*i+1] = 0;
      video[2*i] = 221;
   }

   set_video_char_height(2);
   set_video_blink_toggle();

   k = 0;
   l = 0;
   inc = 4;
   for (y = 0; y < 256;)
   {
      int scale = 768 + 512*sintab[l];
      for (x = 0; x >= 0 && x < 256; x+=inc)
      {
         rotozoom(buff, x, y, (int) (scale*costab[k]), (int) (scale*sintab[k]));
         k++;
         if (k == 100)
            k = 0;
         if ((x & 63) == 60)
         {
            y++;
            l++;
            if (l == 100)
               l = 0;
            scale = 768 + 512*sintab[l];
         }
      }
      if (x == 256)
         x = 252;
      if (x == -1)
         x = 0;
      inc = -inc;
   }

   getchar();

   buff_free(buff);

   set_video_blink_toggle();
   set_video_char_height(8);
   set_video_mode(3);

   return 0;
}
