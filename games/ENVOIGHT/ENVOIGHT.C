#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <conio.h>
#include <dos.h>

#include "graphics.h"
#include "sprite.h"

extern void sprite_init_ship(sprite_t s, int x, int y);
extern void sprite_init_enemy1(sprite_t s, int x, int y);
extern void sprite_init_enemy2(sprite_t s, int x, int y);
extern void sprite_init_enemy3(sprite_t s, int x, int y);
extern void sprite_init_ammo(sprite_t s, int x, int y);

extern void sprite_clear_ship(sprite_t s);
extern void sprite_clear_enemy1(sprite_t s);
extern void sprite_clear_enemy2(sprite_t s);
extern void sprite_clear_enemy3(sprite_t s);
extern void sprite_clear_ammo(sprite_t s);

extern void cga_retrace();

typedef struct
{
   unsigned char far * page;
   sprite_s * sprites;
   int num_sprites;
} raster_ctx_s;

typedef raster_ctx_s raster_ctx_t[1];

int visible[9];
int ammo_used[5];
int ammo_unused[5];
int num_used;
int frame;
int tone;
int noise;

unsigned char keystate[0x60];
unsigned char extstate[0x60];

void interrupt (*old_kb_int)();

void interrupt new_kb_int()
{
   static unsigned char last = 0;
   unsigned char a, raw = inp(0x60); /* read raw code from k/b */
   int scancode = raw & 0x7f;

   if (last == 0xe0) /* ignore second byte of extended scancode */
   {
      if (scancode <0x60)
         extstate[scancode] = !(raw & 0x80);
      last = 0;
   } else if (last >= 0xe1 && last <= 0xe2)
      last = 0; /* ignore these */
   else if (raw >= 0xe0 && raw <= 0xe2)
      last = raw; /* first byte of extended scancode */
   else if (scancode < 0x60)
      keystate[scancode] = !(raw & 0x80);  
   
   /* Signal end of input */
   a = inp(0x61) | 0x80;
   outp(0x61, a);
   a ^= 0x80;
   outp(0x61, a);

   /* End interrupt */
   outp(0x20, 0x20);
}

void hook_kb_int()
{
   unsigned char i;

   for (i = 0; i < 0x60; i++)
      keystate[i] = 0x0;

   old_kb_int = getvect(0x09);
   setvect(0x09, new_kb_int);
}

void unhook_kb_int()
{
   if (old_kb_int != NULL)
   {
      setvect(0x09, old_kb_int);
      old_kb_int = NULL;
   } 
}

void set_freq(int n)
{
   int count = n == 0 ? 0 : 1.19318e6 / n;
   char b;

   if (count == 0)
   {
      b = inp(0x61) & 0xfc;
      outp(0x61, b);
   } else
   {
      b = inp(0x61) | 0x03;
      outp(0x61, b);

      outp(0x43, 0xb6);
      
      b = (char) count;
      outp(0x42, b);

      b = (char) (count >> 8);
      outp(0x42, b);
   }
}

void interrupt (*old_int8)();

void interrupt new_int8()
{
   if (tone != 0)
   {
      set_freq(2000);
      tone--;
   } else if (noise != 0)
   {
      set_freq(random(5000) + 5000);
      noise--;
   } else
      set_freq(0);

   /* End interrupt */
   outp(0x20, 0x20);
}

void hook_int8()
{
   unsigned char i;

   outp(0x43, 0x34);   
   outp(0x40, 174);
   outp(0x40, 77);

   old_int8 = getvect(0x08);
   setvect(0x8, new_int8);
}

void unhook_int8()
{
   if (old_int8 != NULL)
   {
      setvect(0x08, old_int8);
      old_int8 = NULL;
   } 
}

sprite_s * raster_ctx_init(raster_ctx_t screen, int max_sprites)
{
   unsigned char far * video = MK_FP(0xb800, 0x0000);

   screen->page = farcalloc(2, SPRITE_PAGEB);
   screen->sprites = malloc(sizeof(sprite_s)*max_sprites);
   screen->num_sprites = 0;

   page_copy_bg(screen->page, video);

   return screen->sprites;
}

void raster_ctx_clear(raster_ctx_t screen)
{
   farfree(screen->page);
   free(screen->sprites);
}

void screen_set_num_sprites(raster_ctx_t screen, int num)
{
   screen->num_sprites = num;
}

void screen_draw_sprites(raster_ctx_t screen)
{
   int i;

   for (i = 0; i < screen->num_sprites; i++)
      sprite_save_bg(screen->sprites + i, screen->page);

   for (i = 0; i < screen->num_sprites; i++)
   {
      if (visible[i])
         sprite_composite(screen->page, screen->sprites + i);
   }
}

void screen_flip(raster_ctx_t screen)
{
   unsigned char far * video = MK_FP(0xb800, 0x0000);
   int i;

   for (i = 0; i < screen->num_sprites; i++)
      sprite_flip(video, screen->page, screen->sprites + i);

   for (i = 0; i < screen->num_sprites; i++)
      sprite_restore_bg(screen->page, screen->sprites + i);
}

void collision_detect(sprite_s * sprites)
{
   int enemy, missile;

   for (enemy = 1; enemy <= 3; enemy++)
   {
      for (missile = 4; missile <= 8; missile++)
      {
         sprite_s * e = sprites + enemy;
         sprite_s * m = sprites + missile;

         if (visible[enemy] && visible[missile] &&
             (e->y >= m->y) &&
             (m->x >= e->x && m->x + m->xsize <= e->x + e->xsize))
         {
            visible[enemy] = 0;
            visible[missile] = 0;
            noise = 20;
         }
      }
   }   
}

void runloop(raster_ctx_t screen)
{
   int running = 1, xoff, yoff, c, i, j, k;

   sprite_s * sprites = screen->sprites;

   while (running)
   {
      screen_draw_sprites(screen);

      screen_flip(screen);

      xoff = 0;
      yoff = 0;

      if (keystate[0x4d]) /* right arrow */
         xoff = 2; /* right arrow */
      else if (keystate[0x4b]) /* left arrow */
         xoff = -2; 
      else if (keystate[0x1d]) /* left ctrl */
      {
         if (((frame & 3) == 0) && num_used != 5)
         {
            sprite_s * s;
            int x = (sprites + 0)->x + 15;
            int y = (sprites + 0)->y - 2;
            int num = ammo_unused[4 - num_used];
            ammo_used[num_used] = num;
            s = sprites + num;
            sprite_move(s, x - s->x, y - s->y);
            num_used += 1;
            tone = 6;
            visible[num] = 1;
         }
      } else if (keystate[0x01]) /* Esc */
         running = 0;

      collision_detect(sprites);

      sprite_move(sprites + 0, xoff, yoff);
      for (i = 1; i <= 3; i++)
      {
         sprite_move(sprites + i, 0, 1);
         if ((sprites + i)->y >= 200)
         {
            visible[i] = 1;
            (sprites + i)->x = random(304);
            (sprites + i)->y = -20;
         }
      }

      j = 0;
      k = 5 - num_used;
      for (i = 0; i < num_used; i++)
      {
          sprite_s * s = sprites + ammo_used[i];
          if (s->y < -1)
          {
             visible[ammo_used[i]] = 0;
             ammo_unused[k] = ammo_used[i];
             k++;
          } else
          {
             ammo_used[j] = ammo_used[i];
             j++;
          }
      }
      num_used = j;

      for (i = 0; i < num_used; i++)
      {
          sprite_s * s = sprites + ammo_used[i];
          sprite_move(s, 0, -3);
      }

      frame++;
   }
}

int main(void)
{
   int i, j, c;
   raster_ctx_t screen;
   sprite_s * sprites;

   set_video_mode(4);
   outp(0x3d8, 10);
   outp(0x3d9, 25);

   cga_display_pcx("backg.pcx");

   sprites = raster_ctx_init(screen, 16);

   sprite_init_ship(sprites + 0, 148, 164);
   sprite_init_enemy1(sprites + 1, 30, 64);
   sprite_init_enemy2(sprites + 2, 70, 124);
   sprite_init_enemy3(sprites + 3, 133, 170);
  
   for (i = 0; i < 5; i++)
   {
      sprite_init_ammo(sprites + 4 + i, 160, 200);
      ammo_unused[i] = 4 + i;
   }
   num_used = 0;
   
   screen_set_num_sprites(screen, 9);

   for (i = 0; i < 9; i++)
      visible[i] = 1;

   frame = 0;

   set_freq(1000);
   delay(500);
   set_freq(0);

   tone = 0;
   noise = 0;

   hook_int8();
   hook_kb_int();
   runloop(screen);
   unhook_kb_int();
   unhook_int8();

   sprite_clear_ship(sprites + 0);
   sprite_clear_enemy1(sprites + 1);
   sprite_clear_enemy2(sprites + 2);
   sprite_clear_enemy3(sprites + 3);

   for (i = 0; i < 5; i++)
      sprite_clear_ammo(sprites + 4 + i);

   raster_ctx_clear(screen);

   set_video_mode(3);

   return 0;
}
