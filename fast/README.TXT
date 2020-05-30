Fast CGA Graphics Library
=========================

The fast CGA functions aim to provide very fast performance, somewhat at the
cost of code size. However, some limitations apply.

   * Focus on very high performance
   * Will not duplicate large quantities of code for small speedups
   * Interrupts will not be turned off
   * Self-modification allowed, but only if this improves performance
   * Efficient initialisation of routines
   * Additional functions may exist for high performance programs
   * Generally no approximations in graphics output
   * Insane precomputation and memory usage not permitted
                        
Lines
=====                                                                                                                                                       void cga_draw_line(unsigned char far * buff, int x0, int y0, int x1, int y1, unsigned char colour)                                                                                                                                          Draw a line of the given colour (0-3) in the CGA buffer (320x200 x 2 bit)
   buff from (x0, y0) to (x1, y1) inclusive. No restrictions on input except
   that both endpoints be in the screen bounds.

   * All tricks as per the efficient code
   * Special case colours 0 and 3
   * Hard coded for each individual colour

void cga_draw_hline(unsigned char far * buff, int x0, int x1, int y, unsigned char colour)

   Draw a horizontal line of the given colour (0-3) from (x0, y) to (x1, y)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and x1 >= x0.

   * unroll by 2 and use rep stosw

void cga_draw_vline(unsigned char far * buff, int x, int y0, int y1, unsigned char colour)

   Draw a vertical line of the given colour (0-3) from (x, y0) to (x, y1)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and y1 >= y0.

   * unroll by 4