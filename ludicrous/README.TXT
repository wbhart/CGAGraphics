Ludicrous CGA Graphics Library
==============================

The ludicrous CGA functions provide a no-holds-barred approach to performance,
perhaps for demos, but more often than not for intellectual interest only.

   * Always the fastest possible approach known
   * Considerable code duplication possible
   * Interrupts may be turned off
   * Self-modification is fair game if it enables an interesting approach
   * Routines may focus on asymptotic performance to the detriment of small cases
   * Additional functions may be added for programs wanting ludicrous performance
   * Approximations in graphics output are permitted, but not glitchy artifacts
   * Precomputation is permitted, but not purely brute force approaches
   * High memory usage is permitted if it demonstrates an interesting approach
   * Undocumented features/instructions may be used
        
Lines
=====                                                                                                                                                                             void cga_draw_line(unsigned char far * buff, int x0, int y0, int x1, int y1, unsigned char colour)                                                                                                                                                                            Draw a line of the given colour (0-3) in the CGA buffer (320x200 x 2 bit)
   buff from (x0, y0) to (x1, y1) inclusive. No restrictions on input except
   that both endpoints be in the screen bounds.

   * All tricks as per fast code
   * Turn off interrupts and use SP for speeding up Reenigne's XOR trick

