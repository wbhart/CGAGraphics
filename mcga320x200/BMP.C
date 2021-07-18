#include <stdio.h>
#include <alloc.h>

#define DWORD unsigned long 
#define WORD unsigned int
#define BYTE unsigned char
#define LONG long

#define BUFF_SIZE 4096

typedef struct bitmap_file_header
{
   WORD  file_type;
   DWORD size;
   WORD  reserved1;
   WORD  reserved2;
   DWORD offset_bits;
} bitmap_file_header;

typedef struct bitmap_info_header
{
   DWORD size;
   LONG  width;   
   LONG  height;
   WORD  planes;
   WORD  bit_count;
   DWORD compression;
   DWORD size_image;
   LONG  x_pixels_per_meter;
   LONG  y_pixels_per_meter;
   DWORD colors_used;
   DWORD colours_important;
} bitmap_info_header;

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

   fread(&header, sizeof(bitmap_file_header), 1, fptr);

   if (header.file_type != 0x4d42)
   {
      printf("Not a bmp file\n");
      fclose(fptr);
      return NULL;
   }

   fread(info, sizeof(bitmap_info_header), 1, fptr);

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

   for (i = 0; i < info->size_image; i += 3)
   {
      tmp_rgb = bitmap[i];
      bitmap[i] = bitmap[i + 2];
      bitmap[i + 2] = tmp_rgb;
   }

   fclose(fptr);
   free(buff);

   return bitmap;
}

int main(void)
{
   bitmap_info_header info;
   unsigned char far * bitmap;

   bitmap = load_bmp("teton.bmp", &info);

   farfree(bitmap);

   return 0;
}
