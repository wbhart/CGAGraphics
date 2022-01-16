#include <stdio.h>
#include <alloc.h>
#include "bmp.h"

unsigned char far * load_bmp(char * filename, bitmap_info_header * info)
{
   FILE * fptr;
   bitmap_file_header header;
   unsigned char far * bitmap;
   unsigned char * buff;
   long i, bytes_read;
   unsigned char tmp_rgb;
   size_t items_read;

   fptr = fopen(filename, "rb");
   if (fptr == NULL)
   {   
      printf("Unable to open bmp file\n");
      return NULL;
   }

   items_read = fread(&header, sizeof(bitmap_file_header), 1, fptr);

   if (items_read != 1)
   {
      printf("Unable to read file header\n");
      fclose(fptr);
      return NULL;
   }

   if (header.file_type != 0x4d42)
   {
      printf("Not a bmp file\n");
      fclose(fptr);
      return NULL;
   }

   items_read = fread(info, sizeof(bitmap_info_header), 1, fptr);

   if (items_read != 1)
   {
      printf("Unable to read image header\n");
      fclose(fptr);
      return NULL;
   }

   fseek(fptr, header.offset_bits, SEEK_SET);
   
   bitmap = (unsigned char far *) farmalloc(info->size_image);

   if (bitmap == NULL)
   {
      printf("Insufficient memory\n");
      fclose(fptr);
      return NULL;
   }

   buff = (unsigned char *) malloc(BUFF_SIZE);
   
   if (buff == NULL)
   {
      printf("Unable to allocate memory\n");
      farfree(bitmap);
      fclose(fptr);
      return NULL;
   }

   bytes_read = 0;
   while (bytes_read < info->size_image)
   {
      size_t num = BUFF_SIZE;
  
      if (info->size_image - bytes_read < BUFF_SIZE)
         num = info->size_image - bytes_read;
      
      items_read = fread(buff, num, 1, fptr);
      
      if (items_read != 1)
      {
         printf("Unable to read file\n");
         free(buff);
         farfree(bitmap);
         fclose(fptr);
         return NULL;
      }
      
      for (i = 0; i < num; i++, bytes_read++)
         bitmap[bytes_read] = buff[i];
   }

   fclose(fptr);
   free(buff);

   return bitmap;
}

void free_bmp(unsigned char far * bitmap)
{
   farfree(bitmap);
}
