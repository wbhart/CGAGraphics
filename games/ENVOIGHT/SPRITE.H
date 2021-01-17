#include <dos.h>
#include <alloc.h>
#include <stdlib.h>
#include <stdio.h>
#include "graphics.h"

#define SPRITE_WIDTH 64
#define SPRITE_LINEB (320/4)
#define SPRITE_PAGEB ((100+SPRITE_WIDTH)*SPRITE_LINEB+SPRITE_WIDTH/4)
#define SPRITE_OFFSET ((SPRITE_WIDTH/2)*SPRITE_LINEB+SPRITE_WIDTH/4)

typedef void (*spritefn)(unsigned char far *);

typedef struct
{
   int x;
   int y;
   int oldx;
   int oldy;
   int xsize;
   int ysize;
   spritefn sprite0_odd;
   spritefn sprite0_even;
   spritefn sprite1_odd;
   spritefn sprite1_even;
   spritefn sprite2_odd;
   spritefn sprite2_even;
   spritefn sprite3_odd;
   spritefn sprite3_even;
   unsigned char * buff;
} sprite_s;

typedef sprite_s sprite_t[1];

/**** Direct sprite functions ****/

void sprite_display_direct(unsigned char far * video,
                                unsigned char * sprite, int xsize, int ysize);

/**** Sprite functions ****/

void sprite_composite(unsigned char far * page, sprite_t s);

void sprite_flip(unsigned char far * video,
                                    unsigned char far * page, sprite_t s);

void sprite_save_bg(sprite_t s, unsigned char far * page);

void sprite_restore_bg(unsigned char far * page, sprite_t s);

void sprite_wipe(unsigned char far * page, sprite_t s);

void sprite_move(sprite_t s, int x, int y);






