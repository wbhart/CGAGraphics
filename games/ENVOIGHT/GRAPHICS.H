#ifndef GRAPHICS_H
#define GRAPHICS_H

#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include <alloc.h>
#include "pcx.h"

/**** General graphics routines ****/

int set_video_mode(int n);

/**** PCX file format ****/

void cga_display_pcx(char * filename);

#endif
