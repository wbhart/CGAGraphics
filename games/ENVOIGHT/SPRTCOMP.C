#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <dos.h>
#include <string.h>

#include "graphics.h"
#include "sprite.h"

int sprite_widen(unsigned char * sprite2, unsigned char * sprite,
                                    int xsize, int ysize, unsigned char key)
{
   int i, j;

   xsize >>= 2;

   key |= (key << 2);
   key |= (key << 4);

   for (i = 0; i < ysize; i++)
   {
      for (j = 0; j < xsize; j++)
         sprite2[j] = sprite[j];
      
      sprite2[j] = key;

      sprite2 += (xsize + 1);
      sprite  += xsize;
   }

   return (xsize << 2) + 4;
}

void sprite_create_mask(unsigned char * mask, unsigned char * sprite,
                                    int xsize, int ysize, unsigned char key)
{
   int i, j;
   unsigned char c, d;

   xsize >>= 2;

   for (i = 0; i < ysize; i++)
   {
      for (j = 0; j < xsize; j++)
      {
         c = sprite[j];
         d = 0;
         
         if ((c & 3) == key)
            d += 3;
         c >>= 2;

         if ((c & 3) == key)
            d += (3 << 2);
         c >>= 2;


         if ((c & 3) == key)
            d += (3 << 4);
         c >>= 2;


         if ((c & 3) == key)
            d += (3 << 6);

         mask[j] = d;
      }

      mask += xsize;
      sprite += xsize;
   }
}

void sprite_shift1(unsigned char * mask, unsigned char * sprite,
                                    int xsize, int ysize, unsigned char key)
{
   unsigned char cy1, cy2;
   int i, j;

   xsize >>= 2;

   for (i = 0; i < ysize; i++)
   {
      cy1 = ((sprite[0] & 3) << 6);
      sprite[0] >>= 2;
      sprite[0] += (key << 6);

      for (j = 1; j < xsize; j++)
      {
         cy2 = (sprite[j] & 3);
         sprite[j] >>= 2;
         sprite[j] += cy1;
         cy1 = (cy2 << 6);
      }

      sprite += xsize;
   }  

   for (i = 0; i < ysize; i++)
   {
      cy1 = ((mask[0] & 3) << 6);
      mask[0] >>= 2;
      mask[0] += (3 << 6);

      for (j = 1; j < xsize; j++)
      {
         cy2 = (mask[j] & 3);
         mask[j] >>= 2;
         mask[j] += cy1;
         cy1 = (cy2 << 6);
      }

      mask += xsize;
   }  
}

void sprite_compile(FILE * file, char * name, unsigned char * mask,
                        unsigned char * sprite, int xsize, int ysize, int off)
{
   int i, j, j0;
   
   xsize >>= 2;

   fprintf(file, "sprite_show_%s%d(unsigned char far * video, char odd)\n",
                                                                   name, off);
   fprintf(file, "{\n");

   fprintf(file, "   asm mov cl, odd\n");
   fprintf(file, "   asm les di, DWORD PTR video\n");

   for (i = 0; i < ysize; i++)
   {
      j = 0;

      while (j < xsize)
      {
         for (j0 = 0; j + j0 < xsize && mask[j + j0] == 0xff; j0++)
            ;

         j += j0;

         if (j != xsize)
         {
            if (j0 == 1)
               fprintf(file, "   asm inc di\n");
            else if (j0 != 0)
               fprintf(file, "   asm add di, %d\n", j0);

            j0 = 0;

            if (mask[j] == 0)
            {
               fprintf(file, "   asm mov al, %d\n", sprite[j]);
               fprintf(file, "   asm stosb\n");
            } else
            {
               fprintf(file, "   asm mov al, es:[di]\n");
               fprintf(file, "   asm and al, %d\n", mask[j]);
               fprintf(file, "   asm add al, %d\n", sprite[j] & ~mask[j]);
               fprintf(file, "   asm stosb\n");
            }
            
            j++;
         }
      }

      if (i < ysize - 1)
      {
         fprintf(file, "   asm xor cl, 1\n");
         fprintf(file, "   asm jz oddline%d\n", i);
         fprintf(file, "   asm add di, %d\n", SPRITE_PAGEB + j0 - xsize);
         fprintf(file, "   asm jmp nextline%d\n", i);
         fprintf(file, "oddline%d:\n", i);
         fprintf(file, "   asm sub di, %d\n",
                           SPRITE_PAGEB - SPRITE_LINEB + xsize - j0);
         fprintf(file, "nextline%d:\n", i);
      }

      mask += xsize;
      sprite += xsize;         
   }    
         
   fprintf(file, "}\n\n");

   fprintf(file, "void sprite_%s%d_odd(unsigned char far * video)\n",
                                                             name, off);
   fprintf(file, "{\n");
   fprintf(file, "   sprite_show_%s%d(video, 1);\n", name, off);
   fprintf(file, "}\n\n");

   fprintf(file, "void sprite_%s%d_even(unsigned char far * video)\n",
                                                             name, off);
   fprintf(file, "{\n");
   fprintf(file, "   sprite_show_%s%d(video, 0);\n", name, off);
   fprintf(file, "}\n\n");
}

void sprite_compile_aux(FILE * file, char * name, int xsize, int ysize)
{
   fprintf(file, "#include <alloc.h>\n");
   fprintf(file, "#include \"sprite.h\"\n\n");

   fprintf(file, "void sprite_init_%s(sprite_t s, int x, int y)\n", name);
   fprintf(file, "{\n");
   fprintf(file, "   s->x = x;\n");
   fprintf(file, "   s->y = y;\n");
   fprintf(file, "   s->oldx = x;\n");
   fprintf(file, "   s->oldy = y;\n");
   fprintf(file, "   s->xsize = %d;\n", xsize);
   fprintf(file, "   s->ysize = %d; \n", ysize);
   fprintf(file, "   s->sprite0_odd  = sprite_%s0_odd;\n", name);
   fprintf(file, "   s->sprite0_even = sprite_%s0_even;\n", name);
   fprintf(file, "   s->sprite1_odd  = sprite_%s1_odd;\n", name);
   fprintf(file, "   s->sprite1_even = sprite_%s1_even;\n", name);
   fprintf(file, "   s->sprite2_odd  = sprite_%s2_odd;\n", name);
   fprintf(file, "   s->sprite2_even = sprite_%s2_even;\n", name);
   fprintf(file, "   s->sprite3_odd  = sprite_%s3_odd;\n", name);
   fprintf(file, "   s->sprite3_even = sprite_%s3_even;\n", name);
   fprintf(file, "   s->buff = malloc(s->ysize*s->xsize/4);\n");
   fprintf(file, "}\n\n");

   fprintf(file, "void sprite_clear_%s(sprite_t s)\n", name);
   fprintf(file, "{\n");
   fprintf(file, "   free(s->buff);\n");
   fprintf(file, "}\n\n");
}

int main(void)
{
   int mode = 0;
   int i, ret, c, v, len, sbytes;
   unsigned char far * video = MK_FP(0xb800, 0x0000);
   int x0, y0, x1, y1, xsize, ysize;
   char name[20], datfile[20], cfile[20];
   unsigned char * sprite, * sprite2, * mask2;
   FILE * sprite_file, * compile_file;

   printf("Enter video mode: ");
   if (!scanf("%d", &mode))
   {
      printf("Invalid input\n");
      abort();
   }

   while ((c = getchar()) != '\n' && c != EOF)
      /* discard */ ;

   printf("Input file (.dat): ");
   gets(name);
   
   for (i = 0; i < strlen(name); i++)
   {
      if (name[i] == '.')
         name[i] = '\0';
   }

   strcpy(datfile, name);
   strcat(datfile, ".dat");

   strcpy(cfile, name);
   strcat(cfile, ".c");

   sprite_file = fopen(datfile, "rb");

   fread(&xsize, 2, 1, sprite_file);
   fread(&ysize, 2, 1, sprite_file);

   sprite = (unsigned char *) malloc(ysize*(xsize/4));

   fread(sprite, 1, ysize*(xsize/4), sprite_file);

   set_video_mode(mode);

   sprite_display_direct(video, sprite, xsize, ysize);

   fclose(sprite_file);

   sprite2 = (unsigned char *) malloc(ysize*((xsize + 4)/4));
   mask2   = (unsigned char *) malloc(ysize*((xsize + 4)/4));

   xsize = sprite_widen(sprite2, sprite, xsize, ysize, 0);

   free(sprite);

   compile_file = fopen(cfile, "w");

   sprite_create_mask(mask2, sprite2, xsize, ysize, 0);
   sprite_compile(compile_file, name, mask2, sprite2, xsize, ysize, 0);

   sprite_shift1(mask2, sprite2, xsize, ysize, 0);
   sprite_create_mask(mask2, sprite2, xsize, ysize, 0);
   sprite_compile(compile_file, name, mask2, sprite2, xsize, ysize, 1);

   sprite_display_direct(video, sprite2, xsize, ysize);

   sprite_shift1(mask2, sprite2, xsize, ysize, 0);
   sprite_create_mask(mask2, sprite2, xsize, ysize, 0);
   sprite_compile(compile_file, name, mask2, sprite2, xsize, ysize, 2);

   sprite_display_direct(video, sprite2, xsize, ysize);

   sprite_shift1(mask2, sprite2, xsize, ysize, 0);
   sprite_create_mask(mask2, sprite2, xsize, ysize, 0);
   sprite_compile(compile_file, name, mask2, sprite2, xsize, ysize, 3);

   sprite_display_direct(video, sprite2, xsize, ysize);

   sprite_compile_aux(compile_file, name, xsize, ysize);

   set_video_mode(3);

   printf("Sprite %dx%d written to %s\n", xsize, ysize, cfile);
   getchar();

   fclose(compile_file);

   free(sprite2);
   free(mask2);

   return 0;
}
