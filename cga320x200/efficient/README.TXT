Efficient CGA Graphics Library
==============================

The efficient CGA functions aim to provide all-round efficiency, both in terms
of speed and space.

   * May be 20-30% slower than the fast versions
   * Will not duplicate large quantities of code for small speedups
   * Interrupts will not be turned off
   * No self-modification
   * Efficient initialisation of routines
   * No unnecessary proliferation of functions
   * Generally no approximations in graphics output

Lines
=====

void cga_draw_line(unsigned char far * buff, int x0, int y0, int x1, int y1, unsigned char colour)

   Draw a line of the given colour (0-3) in the CGA buffer (320x200 x 2 bit)
   buff from (x0, y0) to (x1, y1) inclusive. No restrictions on input except
   that both endpoints be in the screen bounds.

   * Special case pixels mod 4 in horizontal direction with 4 way unroll
   * Deal with odd and even lines in pairs in verticalish case, 2 way unroll
   * Reenigne's XOR trick to deal with switching between odd/even lines
   * Special layout of cases to maximise short jumps
   * As many cases as possible fall through to next case without jump

void cga_draw_hline(unsigned char far * buff, int x0, int x1, int y, unsigned char colour)

   Draw a horizontal line of the given colour (0-3) from (x0, y) to (x1, y)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and x1 >= x0.

   * unroll by 2 and use rep stosw

void cga_draw_vline(unsigned char far * buff, int x, int y0, int y1, unsigned char colour)

   Draw a vertical line of the given colour (0-3) from (x, y0) to (x, y1)
   inclusive in the CGA buffer (320x200 x 2 bit) buff. No restrictions except
   that inputs be in the screen bounds and y1 >= y0.

   * unroll by 2
