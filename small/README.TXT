Small CGA Graphics Library
==========================

The small CGA functions aim to provide reasonable performance with a very small
amount of code.

   * Focus on code size, not performance, though not to the extreme
   * Generally no duplication of code for speedups
   * Interrupts will not be turned off
   * Self-modification only if it reduces code size with low overhead
   * Very efficient initialisation of routines
   * No proliferation of functions
   * Generally no approximations in graphics output   
                                   
Lines
=====                                                                                                                                                       void cga_draw_line(unsigned char far * buff, int x0, int y0, int x1, int y1, unsigned char colour)                                                                                                                                          Draw a line of the given colour (0-3) in the CGA buffer (320x200 x 2 bit)
   buff from (x0, y0) to (x1, y1) inclusive. No restrictions on input except
   that both endpoints be in the screen bounds.

void cga_draw_hline(unsigned char far * buff, int x0, int x1, int y, unsigned char colour)

   Draw a horizontal line of the given colour (0-3) from (x0, y) to (x1, y)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and x1 >= x0.

   * rep stosb

void cga_draw_vline(unsigned char far * buff, int x, int y0, int y1, unsigned char colour)

   Draw a vertical line of the given colour (0-3) from (x, y0) to (x, y1)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and y1 >= y0.

