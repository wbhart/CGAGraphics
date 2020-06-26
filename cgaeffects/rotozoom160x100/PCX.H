#include <stdlib.h>
#include <stdio.h>

#define PCX_BUFF_SIZE 1024

typedef struct
{
   unsigned char r;
   unsigned char g;
   unsigned char b;
} colour_s;

typedef struct
{
   char pcx_flag;
   char version;
   char encoding;
   char bits_per_pixel;
   int x0;
   int y0;
   int x1;
   int y1;
   int hdpi;
   int vdpi;
   colour_s colour_map[16];
   char reserved;
   char nplanes;
   int bytes_per_line;
   unsigned int palette_info;
   int hscreen_size;
   int vscreen_size;
   char filler[54];   
} pcx_header_s;

void pcx_header_read(pcx_header_s * header, FILE * pcx_file);

void pcx_buffer_load(unsigned char far * buffer, FILE * pcx_file,
                                               int bytes_per_line, int lines);