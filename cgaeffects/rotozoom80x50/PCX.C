#include "pcx.h"

void pcx_header_read(pcx_header_s * header, FILE * pcx_file)
{
   /* read header */
   fread(header, 1, 128, pcx_file);
}

void pcx_buffer_load(unsigned char far * buffer, FILE * pcx_file,
                                                int bytes_per_line, int lines)
{
   unsigned char * buff;
   int data_length;
   int i, j, k, off, count = 0;
   unsigned char c, d;

   /* allocate buffer */
   buff = malloc(PCX_BUFF_SIZE+1);

   off = 0;

   data_length = 0;

   i = 0;
   while (count < lines)
   {
      j = 0;
      while (j < bytes_per_line)
      {
         if (i == data_length)
         {
            data_length = fread(buff, 1, PCX_BUFF_SIZE, pcx_file);
            if (data_length == 0)
            {
               printf("Unable to read file \n");
               abort();
            }
            i = 0;
         }

         c = buff[i];
         i++;

         if (c >= 192) /* c is a count */
         {
            c -= 192;

            if (i == data_length)
            {
               data_length = fread(buff, 1, PCX_BUFF_SIZE, pcx_file);
               if (data_length == 0)
               {
                  printf("Unable to read file \n");
                  abort();
               }
               i = 0;
            }

            d = buff[i];
            i++;

            for (k = 0; k < c; k++)
               buffer[off + j + k] = d;

            j += c;
         } else
         {
            buffer[off + j] = c;
            j++;
         }
      }
      off += bytes_per_line;
      count++;
   }

   free(buff);
}
