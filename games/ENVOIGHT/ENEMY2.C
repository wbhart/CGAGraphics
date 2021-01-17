sprite_show_enemy20(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13132
   asm jmp nextline0
oddline0:
   asm sub di, 13060
nextline0:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13132
   asm jmp nextline2
oddline2:
   asm sub di, 13060
nextline2:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13132
   asm jmp nextline3
oddline3:
   asm sub di, 13060
nextline3:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13132
   asm jmp nextline4
oddline4:
   asm sub di, 13060
nextline4:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13132
   asm jmp nextline5
oddline5:
   asm sub di, 13060
nextline5:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13132
   asm jmp nextline6
oddline6:
   asm sub di, 13060
nextline6:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13132
   asm jmp nextline7
oddline7:
   asm sub di, 13060
nextline7:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13132
   asm jmp nextline8
oddline8:
   asm sub di, 13060
nextline8:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13132
   asm jmp nextline9
oddline9:
   asm sub di, 13060
nextline9:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13132
   asm jmp nextline10
oddline10:
   asm sub di, 13060
nextline10:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13132
   asm jmp nextline11
oddline11:
   asm sub di, 13060
nextline11:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13132
   asm jmp nextline12
oddline12:
   asm sub di, 13060
nextline12:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
}

void sprite_enemy20_odd(unsigned char far * video)
{
   sprite_show_enemy20(video, 1);
}

void sprite_enemy20_even(unsigned char far * video)
{
   sprite_show_enemy20(video, 0);
}

sprite_show_enemy21(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13132
   asm jmp nextline3
oddline3:
   asm sub di, 13060
nextline3:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13132
   asm jmp nextline5
oddline5:
   asm sub di, 13060
nextline5:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13131
   asm jmp nextline6
oddline6:
   asm sub di, 13061
nextline6:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13132
   asm jmp nextline7
oddline7:
   asm sub di, 13060
nextline7:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13131
   asm jmp nextline8
oddline8:
   asm sub di, 13061
nextline8:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13132
   asm jmp nextline9
oddline9:
   asm sub di, 13060
nextline9:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13131
   asm jmp nextline10
oddline10:
   asm sub di, 13061
nextline10:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13132
   asm jmp nextline11
oddline11:
   asm sub di, 13060
nextline11:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 12
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13131
   asm jmp nextline12
oddline12:
   asm sub di, 13061
nextline12:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
}

void sprite_enemy21_odd(unsigned char far * video)
{
   sprite_show_enemy21(video, 1);
}

void sprite_enemy21_even(unsigned char far * video)
{
   sprite_show_enemy21(video, 0);
}

sprite_show_enemy22(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13131
   asm jmp nextline5
oddline5:
   asm sub di, 13061
nextline5:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13131
   asm jmp nextline6
oddline6:
   asm sub di, 13061
nextline6:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13131
   asm jmp nextline7
oddline7:
   asm sub di, 13061
nextline7:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13131
   asm jmp nextline8
oddline8:
   asm sub di, 13061
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13131
   asm jmp nextline9
oddline9:
   asm sub di, 13061
nextline9:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13131
   asm jmp nextline10
oddline10:
   asm sub di, 13061
nextline10:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13131
   asm jmp nextline11
oddline11:
   asm sub di, 13061
nextline11:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13131
   asm jmp nextline12
oddline12:
   asm sub di, 13061
nextline12:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
}

void sprite_enemy22_odd(unsigned char far * video)
{
   sprite_show_enemy22(video, 1);
}

void sprite_enemy22_even(unsigned char far * video)
{
   sprite_show_enemy22(video, 0);
}

sprite_show_enemy23(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13131
   asm jmp nextline5
oddline5:
   asm sub di, 13061
nextline5:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13131
   asm jmp nextline6
oddline6:
   asm sub di, 13061
nextline6:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13131
   asm jmp nextline7
oddline7:
   asm sub di, 13061
nextline7:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13131
   asm jmp nextline8
oddline8:
   asm sub di, 13061
nextline8:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13131
   asm jmp nextline9
oddline9:
   asm sub di, 13061
nextline9:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13131
   asm jmp nextline10
oddline10:
   asm sub di, 13061
nextline10:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13131
   asm jmp nextline11
oddline11:
   asm sub di, 13061
nextline11:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 204
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13131
   asm jmp nextline12
oddline12:
   asm sub di, 13061
nextline12:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 51
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 48
   asm stosb
}

void sprite_enemy23_odd(unsigned char far * video)
{
   sprite_show_enemy23(video, 1);
}

void sprite_enemy23_even(unsigned char far * video)
{
   sprite_show_enemy23(video, 0);
}

#include <alloc.h>
#include "sprite.h"

void sprite_init_enemy2(sprite_t s, int x, int y)
{
   s->x = x;
   s->y = y;
   s->oldx = x;
   s->oldy = y;
   s->xsize = 20;
   s->ysize = 14; 
   s->sprite0_odd  = sprite_enemy20_odd;
   s->sprite0_even = sprite_enemy20_even;
   s->sprite1_odd  = sprite_enemy21_odd;
   s->sprite1_even = sprite_enemy21_even;
   s->sprite2_odd  = sprite_enemy22_odd;
   s->sprite2_even = sprite_enemy22_even;
   s->sprite3_odd  = sprite_enemy23_odd;
   s->sprite3_even = sprite_enemy23_even;
   s->buff = malloc(s->ysize*s->xsize/4);
}

void sprite_clear_enemy2(sprite_t s)
{
   free(s->buff);
}

