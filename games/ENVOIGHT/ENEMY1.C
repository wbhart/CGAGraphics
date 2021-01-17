sprite_show_enemy10(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm inc di
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13133
   asm jmp nextline0
oddline0:
   asm sub di, 13059
nextline0:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13133
   asm jmp nextline1
oddline1:
   asm sub di, 13059
nextline1:
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13132
   asm jmp nextline2
oddline2:
   asm sub di, 13060
nextline2:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13132
   asm jmp nextline4
oddline4:
   asm sub di, 13060
nextline4:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13132
   asm jmp nextline5
oddline5:
   asm sub di, 13060
nextline5:
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13132
   asm jmp nextline6
oddline6:
   asm sub di, 13060
nextline6:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13132
   asm jmp nextline7
oddline7:
   asm sub di, 13060
nextline7:
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13132
   asm jmp nextline8
oddline8:
   asm sub di, 13060
nextline8:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13132
   asm jmp nextline10
oddline10:
   asm sub di, 13060
nextline10:
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13132
   asm jmp nextline12
oddline12:
   asm sub di, 13060
nextline12:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13133
   asm jmp nextline13
oddline13:
   asm sub di, 13059
nextline13:
   asm inc di
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
}

void sprite_enemy10_odd(unsigned char far * video)
{
   sprite_show_enemy10(video, 1);
}

void sprite_enemy10_even(unsigned char far * video)
{
   sprite_show_enemy10(video, 0);
}

sprite_show_enemy11(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13133
   asm jmp nextline0
oddline0:
   asm sub di, 13059
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13132
   asm jmp nextline3
oddline3:
   asm sub di, 13060
nextline3:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
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
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
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
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13132
   asm jmp nextline9
oddline9:
   asm sub di, 13060
nextline9:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13132
   asm jmp nextline11
oddline11:
   asm sub di, 13060
nextline11:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13132
   asm jmp nextline12
oddline12:
   asm sub di, 13060
nextline12:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13132
   asm jmp nextline13
oddline13:
   asm sub di, 13060
nextline13:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
}

void sprite_enemy11_odd(unsigned char far * video)
{
   sprite_show_enemy11(video, 1);
}

void sprite_enemy11_even(unsigned char far * video)
{
   sprite_show_enemy11(video, 0);
}

sprite_show_enemy12(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13133
   asm jmp nextline0
oddline0:
   asm sub di, 13059
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13132
   asm jmp nextline2
oddline2:
   asm sub di, 13060
nextline2:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13132
   asm jmp nextline3
oddline3:
   asm sub di, 13060
nextline3:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13132
   asm jmp nextline4
oddline4:
   asm sub di, 13060
nextline4:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
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
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13132
   asm jmp nextline9
oddline9:
   asm sub di, 13060
nextline9:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13132
   asm jmp nextline10
oddline10:
   asm sub di, 13060
nextline10:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13132
   asm jmp nextline11
oddline11:
   asm sub di, 13060
nextline11:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13132
   asm jmp nextline12
oddline12:
   asm sub di, 13060
nextline12:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13132
   asm jmp nextline13
oddline13:
   asm sub di, 13060
nextline13:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
}

void sprite_enemy12_odd(unsigned char far * video)
{
   sprite_show_enemy12(video, 1);
}

void sprite_enemy12_even(unsigned char far * video)
{
   sprite_show_enemy12(video, 0);
}

sprite_show_enemy13(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13133
   asm jmp nextline0
oddline0:
   asm sub di, 13059
nextline0:
   asm inc di
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13132
   asm jmp nextline1
oddline1:
   asm sub di, 13060
nextline1:
   asm inc di
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13132
   asm jmp nextline2
oddline2:
   asm sub di, 13060
nextline2:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13132
   asm jmp nextline4
oddline4:
   asm sub di, 13060
nextline4:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
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
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13132
   asm jmp nextline10
oddline10:
   asm sub di, 13060
nextline10:
   asm inc di
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
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
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13132
   asm jmp nextline12
oddline12:
   asm sub di, 13060
nextline12:
   asm inc di
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13132
   asm jmp nextline13
oddline13:
   asm sub di, 13060
nextline13:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
}

void sprite_enemy13_odd(unsigned char far * video)
{
   sprite_show_enemy13(video, 1);
}

void sprite_enemy13_even(unsigned char far * video)
{
   sprite_show_enemy13(video, 0);
}

#include <alloc.h>
#include "sprite.h"

void sprite_init_enemy1(sprite_t s, int x, int y)
{
   s->x = x;
   s->y = y;
   s->oldx = x;
   s->oldy = y;
   s->xsize = 20;
   s->ysize = 15; 
   s->sprite0_odd  = sprite_enemy10_odd;
   s->sprite0_even = sprite_enemy10_even;
   s->sprite1_odd  = sprite_enemy11_odd;
   s->sprite1_even = sprite_enemy11_even;
   s->sprite2_odd  = sprite_enemy12_odd;
   s->sprite2_even = sprite_enemy12_even;
   s->sprite3_odd  = sprite_enemy13_odd;
   s->sprite3_even = sprite_enemy13_even;
   s->buff = malloc(s->ysize*s->xsize/4);
}

void sprite_clear_enemy1(sprite_t s)
{
   free(s->buff);
}

