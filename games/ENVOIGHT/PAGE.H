#ifndef PAGE_H
#define PAGE_H

#include <dos.h>

#define PAGE_MARGIN  64
#define PAGE_LINEB  (320/4)
#define PAGE_ODDB  ((100+PAGE_MARGIN)*PAGE_LINEB+PAGE_MARGIN/4)
#define PAGE_OFFSET ((PAGE_MARGIN/2)*PAGE_LINEB+PAGE_MARGIN/4)

unsigned char far * page_alloc();

void page_free(unsigned char far * page);

void page_copy_bg(unsigned char far * page, unsigned char far * video);

void page_flip_box_aligned(unsigned char far * video,
                unsigned char far * page, int x, int y, int xsize, int ysize);

void page_flip_box_unaligned(unsigned char far * video,
                unsigned char far * page, int x, int y, int xsize, int ysize);

#endif