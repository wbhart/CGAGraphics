#include "graphics.h"

/******************************************************************************
*
*  General graphics routines
*
******************************************************************************/

int set_video_mode(int n)
{
   union REGS regs;

   regs.h.ah = 0;
   regs.h.al = n;
   int86(0x10, &regs, &regs);
}

/******************************************************************************
*
*   PCX graphics format
*
******************************************************************************/

/* save some regs by giving these global addresses */

unsigned char far * abuff0;
unsigned char far * abuff1;
unsigned char far * pcx_buff;

void cga_pcx_decode(unsigned char far * buff,
                                          int data_length, int bytes_per_line)
{
   abuff0 = MK_FP(0xb800, 0x0000);
   abuff1 = MK_FP(0xba00, 0x0000);
   pcx_buff = buff;

   asm push bp
   asm jmp startproc

   /* store CGA image in buffers */

storebyte:
   asm _storebyte proc near

   asm stosb
   asm inc dx
   asm cmp dl, ah
   asm je row_ends
   asm loop storebyte
   asm ret

   asm _storebyte endp

row_ends:

   asm xor bp, 1
   asm sub di, dx
   asm add di, 80
   asm cmp bp, 1
   asm je bank1
   asm mov word ptr abuff1, di
   asm les di, abuff0
   asm xor dx, dx
   asm loop storebyte
   asm ret

bank1:

   asm mov word ptr abuff0, di
   asm les di, abuff1
   asm xor dx, dx
   asm loop storebyte
   asm ret

   /* main assembly procedure for CGA */

startproc:

   asm mov es, word ptr abuff0[2]
   asm mov di, word ptr abuff0
   asm mov ah, byte ptr bytes_per_line
   asm mov bx, data_length
   asm mov bp, 0
   asm xor cx, cx
   asm xor dx, dx
   asm mov si, dx
   asm cld

   /* loop through input buffer */

getbyte:

   asm cmp si, bx
   asm je exit
   asm push es
   asm push di
   asm les di, pcx_buff
   asm add di, si
   asm mov al, [es:di]
   asm inc si
   asm pop di
   asm pop es
   asm cmp cl, 0
   asm jg multi_data
   asm cmp al, 192
   asm jb one_data
   
   /* it's a count byte */
   asm xor al, 192
   asm mov cl, al
   asm jmp getbyte

one_data:

   asm mov cl, 1
   asm call _storebyte
   asm jmp getbyte

multi_data:

   asm call _storebyte
   asm jmp getbyte

   /* finished with buffer */

exit:

   asm pop bp

   return;
}

void cga_display_pcx(char * filename)
{
   FILE * pcx_file = fopen(filename, "r+b");
   char * buff;
   int bytes_per_line, data_length;

   if (!pcx_file)
   {
      printf("Unable to open %s\n", filename);
      exit(1);
   }

   /* allocate buffer */
   buff = malloc(PCX_BUFF_SIZE);

   /* read header into buffer */
   fread(buff, 1, 128, pcx_file);

   bytes_per_line = (int) buff[66];

   if ((data_length = fread(buff, 1, PCX_BUFF_SIZE, pcx_file)) != 0)
      cga_pcx_decode(buff, data_length, bytes_per_line);

   free(buff);
   fclose(pcx_file);   
}
