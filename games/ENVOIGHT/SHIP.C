sprite_show_ship0(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 40
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 40
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 195
   asm add al, 40
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm add di, 4
   asm mov al, 190
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13131
   asm jmp nextline3
oddline3:
   asm sub di, 13061
nextline3:
   asm add di, 4
   asm mov al, 190
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13131
   asm jmp nextline4
oddline4:
   asm sub di, 13061
nextline4:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13131
   asm jmp nextline5
oddline5:
   asm sub di, 13061
nextline5:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 103
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13130
   asm jmp nextline9
oddline9:
   asm sub di, 13062
nextline9:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13130
   asm jmp nextline10
oddline10:
   asm sub di, 13062
nextline10:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 46
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13130
   asm jmp nextline11
oddline11:
   asm sub di, 13062
nextline11:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 45
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13130
   asm jmp nextline12
oddline12:
   asm sub di, 13062
nextline12:
   asm add di, 3
   asm mov al, 190
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13130
   asm jmp nextline13
oddline13:
   asm sub di, 13062
nextline13:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, 185
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 184
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline14
   asm add di, 13129
   asm jmp nextline14
oddline14:
   asm sub di, 13063
nextline14:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 243
   asm add al, 8
   asm stosb
   asm mov al, 182
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 120
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline15
   asm add di, 13129
   asm jmp nextline15
oddline15:
   asm sub di, 13063
nextline15:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, 249
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline16
   asm add di, 13129
   asm jmp nextline16
oddline16:
   asm sub di, 13063
nextline16:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, 246
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 126
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline17
   asm add di, 13129
   asm jmp nextline17
oddline17:
   asm sub di, 13063
nextline17:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, 249
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline18
   asm add di, 13129
   asm jmp nextline18
oddline18:
   asm sub di, 13063
nextline18:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline19
   asm add di, 13129
   asm jmp nextline19
oddline19:
   asm sub di, 13063
nextline19:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline20
   asm add di, 13129
   asm jmp nextline20
oddline20:
   asm sub di, 13063
nextline20:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline21
   asm add di, 13129
   asm jmp nextline21
oddline21:
   asm sub di, 13063
nextline21:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline22
   asm add di, 13129
   asm jmp nextline22
oddline22:
   asm sub di, 13063
nextline22:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline23
   asm add di, 13129
   asm jmp nextline23
oddline23:
   asm sub di, 13063
nextline23:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 191
   asm stosb
   asm xor cl, 1
   asm jz oddline24
   asm add di, 13130
   asm jmp nextline24
oddline24:
   asm sub di, 13062
nextline24:
   asm inc di
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm xor cl, 1
   asm jz oddline25
   asm add di, 13129
   asm jmp nextline25
oddline25:
   asm sub di, 13063
nextline25:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline26
   asm add di, 13128
   asm jmp nextline26
oddline26:
   asm sub di, 13064
nextline26:
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm xor cl, 1
   asm jz oddline27
   asm add di, 13128
   asm jmp nextline27
oddline27:
   asm sub di, 13064
nextline27:
   asm mov al, 175
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline28
   asm add di, 13127
   asm jmp nextline28
oddline28:
   asm sub di, 13065
nextline28:
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 243
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline29
   asm add di, 13127
   asm jmp nextline29
oddline29:
   asm sub di, 13065
nextline29:
   asm inc di
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 172
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 243
   asm stosb
   asm mov al, 234
   asm stosb
   asm xor cl, 1
   asm jz oddline30
   asm add di, 13128
   asm jmp nextline30
oddline30:
   asm sub di, 13064
nextline30:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline31
   asm add di, 13128
   asm jmp nextline31
oddline31:
   asm sub di, 13064
nextline31:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 170
   asm stosb
   asm xor cl, 1
   asm jz oddline32
   asm add di, 13130
   asm jmp nextline32
oddline32:
   asm sub di, 13062
nextline32:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, 170
   asm stosb
   asm xor cl, 1
   asm jz oddline33
   asm add di, 13130
   asm jmp nextline33
oddline33:
   asm sub di, 13062
nextline33:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 170
   asm stosb
   asm xor cl, 1
   asm jz oddline34
   asm add di, 13130
   asm jmp nextline34
oddline34:
   asm sub di, 13062
nextline34:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 1
   asm stosb
   asm mov al, 170
   asm stosb
}

void sprite_ship0_odd(unsigned char far * video)
{
   sprite_show_ship0(video, 1);
}

void sprite_ship0_even(unsigned char far * video)
{
   sprite_show_ship0(video, 0);
}

sprite_show_ship1(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13131
   asm jmp nextline0
oddline0:
   asm sub di, 13061
nextline0:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13131
   asm jmp nextline1
oddline1:
   asm sub di, 13061
nextline1:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13131
   asm jmp nextline2
oddline2:
   asm sub di, 13061
nextline2:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13130
   asm jmp nextline3
oddline3:
   asm sub di, 13062
nextline3:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13130
   asm jmp nextline4
oddline4:
   asm sub di, 13062
nextline4:
   asm add di, 4
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13130
   asm jmp nextline5
oddline5:
   asm sub di, 13062
nextline5:
   asm add di, 4
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 4
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 217
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13130
   asm jmp nextline9
oddline9:
   asm sub di, 13062
nextline9:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 120
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13130
   asm jmp nextline10
oddline10:
   asm sub di, 13062
nextline10:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 184
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13130
   asm jmp nextline11
oddline11:
   asm sub di, 13062
nextline11:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 126
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13130
   asm jmp nextline12
oddline12:
   asm sub di, 13062
nextline12:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 190
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13130
   asm jmp nextline13
oddline13:
   asm sub di, 13062
nextline13:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 46
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 110
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline14
   asm add di, 13129
   asm jmp nextline14
oddline14:
   asm sub di, 13063
nextline14:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 45
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 158
   asm stosb
   asm mov al, es:[di]
   asm and al, 207
   asm add al, 32
   asm stosb
   asm xor cl, 1
   asm jz oddline15
   asm add di, 13129
   asm jmp nextline15
oddline15:
   asm sub di, 13063
nextline15:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 111
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline16
   asm add di, 13129
   asm jmp nextline16
oddline16:
   asm sub di, 13063
nextline16:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 189
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 159
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline17
   asm add di, 13129
   asm jmp nextline17
oddline17:
   asm sub di, 13063
nextline17:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 111
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline18
   asm add di, 13129
   asm jmp nextline18
oddline18:
   asm sub di, 13063
nextline18:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline19
   asm add di, 13129
   asm jmp nextline19
oddline19:
   asm sub di, 13063
nextline19:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline20
   asm add di, 13129
   asm jmp nextline20
oddline20:
   asm sub di, 13063
nextline20:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline21
   asm add di, 13129
   asm jmp nextline21
oddline21:
   asm sub di, 13063
nextline21:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline22
   asm add di, 13129
   asm jmp nextline22
oddline22:
   asm sub di, 13063
nextline22:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline23
   asm add di, 13129
   asm jmp nextline23
oddline23:
   asm sub di, 13063
nextline23:
   asm add di, 3
   asm mov al, 255
   asm stosb
   asm mov al, 187
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline24
   asm add di, 13129
   asm jmp nextline24
oddline24:
   asm sub di, 13063
nextline24:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline25
   asm add di, 13128
   asm jmp nextline25
oddline25:
   asm sub di, 13064
nextline25:
   asm inc di
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm xor cl, 1
   asm jz oddline26
   asm add di, 13128
   asm jmp nextline26
oddline26:
   asm sub di, 13064
nextline26:
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline27
   asm add di, 13127
   asm jmp nextline27
oddline27:
   asm sub di, 13065
nextline27:
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm xor cl, 1
   asm jz oddline28
   asm add di, 13127
   asm jmp nextline28
oddline28:
   asm sub di, 13065
nextline28:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 232
   asm stosb
   asm xor cl, 1
   asm jz oddline29
   asm add di, 13127
   asm jmp nextline29
oddline29:
   asm sub di, 13065
nextline29:
   asm inc di
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm mov al, 250
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline30
   asm add di, 13127
   asm jmp nextline30
oddline30:
   asm sub di, 13065
nextline30:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline31
   asm add di, 13128
   asm jmp nextline31
oddline31:
   asm sub di, 13064
nextline31:
   asm add di, 3
   asm mov al, 234
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm mov al, 234
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline32
   asm add di, 13129
   asm jmp nextline32
oddline32:
   asm sub di, 13063
nextline32:
   asm add di, 3
   asm mov al, 106
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm mov al, 106
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline33
   asm add di, 13129
   asm jmp nextline33
oddline33:
   asm sub di, 13063
nextline33:
   asm add di, 3
   asm mov al, 234
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm mov al, 234
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline34
   asm add di, 13129
   asm jmp nextline34
oddline34:
   asm sub di, 13063
nextline34:
   asm add di, 3
   asm mov al, 106
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm mov al, 106
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
}

void sprite_ship1_odd(unsigned char far * video)
{
   sprite_show_ship1(video, 1);
}

void sprite_ship1_even(unsigned char far * video)
{
   sprite_show_ship1(video, 0);
}

sprite_show_ship2(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13130
   asm jmp nextline0
oddline0:
   asm sub di, 13062
nextline0:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13130
   asm jmp nextline1
oddline1:
   asm sub di, 13062
nextline1:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13130
   asm jmp nextline2
oddline2:
   asm sub di, 13062
nextline2:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13130
   asm jmp nextline3
oddline3:
   asm sub di, 13062
nextline3:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13130
   asm jmp nextline4
oddline4:
   asm sub di, 13062
nextline4:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13130
   asm jmp nextline5
oddline5:
   asm sub di, 13062
nextline5:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm add di, 4
   asm mov al, 185
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 184
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm add di, 4
   asm mov al, 182
   asm stosb
   asm mov al, 126
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13130
   asm jmp nextline9
oddline9:
   asm sub di, 13062
nextline9:
   asm add di, 4
   asm mov al, 185
   asm stosb
   asm mov al, 158
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13130
   asm jmp nextline10
oddline10:
   asm sub di, 13062
nextline10:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 110
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13130
   asm jmp nextline11
oddline11:
   asm sub di, 13062
nextline11:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 217
   asm stosb
   asm mov al, 159
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13129
   asm jmp nextline12
oddline12:
   asm sub di, 13063
nextline12:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 111
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13129
   asm jmp nextline13
oddline13:
   asm sub di, 13063
nextline13:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 139
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline14
   asm add di, 13129
   asm jmp nextline14
oddline14:
   asm sub di, 13063
nextline14:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 139
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 103
   asm stosb
   asm mov al, es:[di]
   asm and al, 51
   asm add al, 136
   asm stosb
   asm xor cl, 1
   asm jz oddline15
   asm add di, 13129
   asm jmp nextline15
oddline15:
   asm sub di, 13063
nextline15:
   asm add di, 3
   asm mov al, 175
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 232
   asm stosb
   asm xor cl, 1
   asm jz oddline16
   asm add di, 13129
   asm jmp nextline16
oddline16:
   asm sub di, 13063
nextline16:
   asm add di, 3
   asm mov al, 175
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 103
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 232
   asm stosb
   asm xor cl, 1
   asm jz oddline17
   asm add di, 13129
   asm jmp nextline17
oddline17:
   asm sub di, 13063
nextline17:
   asm add di, 3
   asm mov al, 175
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 232
   asm stosb
   asm xor cl, 1
   asm jz oddline18
   asm add di, 13129
   asm jmp nextline18
oddline18:
   asm sub di, 13063
nextline18:
   asm add di, 3
   asm mov al, 191
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 111
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline19
   asm add di, 13129
   asm jmp nextline19
oddline19:
   asm sub di, 13063
nextline19:
   asm add di, 3
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline20
   asm add di, 13129
   asm jmp nextline20
oddline20:
   asm sub di, 13063
nextline20:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline21
   asm add di, 13129
   asm jmp nextline21
oddline21:
   asm sub di, 13063
nextline21:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline22
   asm add di, 13129
   asm jmp nextline22
oddline22:
   asm sub di, 13063
nextline22:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline23
   asm add di, 13129
   asm jmp nextline23
oddline23:
   asm sub di, 13063
nextline23:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 238
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline24
   asm add di, 13129
   asm jmp nextline24
oddline24:
   asm sub di, 13063
nextline24:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline25
   asm add di, 13128
   asm jmp nextline25
oddline25:
   asm sub di, 13064
nextline25:
   asm inc di
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm xor cl, 1
   asm jz oddline26
   asm add di, 13128
   asm jmp nextline26
oddline26:
   asm sub di, 13064
nextline26:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 3
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 240
   asm stosb
   asm xor cl, 1
   asm jz oddline27
   asm add di, 13127
   asm jmp nextline27
oddline27:
   asm sub di, 13065
nextline27:
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm xor cl, 1
   asm jz oddline28
   asm add di, 13127
   asm jmp nextline28
oddline28:
   asm sub di, 13065
nextline28:
   asm inc di
   asm mov al, 175
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 207
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 63
   asm stosb
   asm mov al, 250
   asm stosb
   asm xor cl, 1
   asm jz oddline29
   asm add di, 13127
   asm jmp nextline29
oddline29:
   asm sub di, 13065
nextline29:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 10
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 207
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 62
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline30
   asm add di, 13127
   asm jmp nextline30
oddline30:
   asm sub di, 13065
nextline30:
   asm add di, 2
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm xor cl, 1
   asm jz oddline31
   asm add di, 13128
   asm jmp nextline31
oddline31:
   asm sub di, 13064
nextline31:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 58
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 58
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline32
   asm add di, 13129
   asm jmp nextline32
oddline32:
   asm sub di, 13063
nextline32:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 26
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 26
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline33
   asm add di, 13129
   asm jmp nextline33
oddline33:
   asm sub di, 13063
nextline33:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 58
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 58
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline34
   asm add di, 13129
   asm jmp nextline34
oddline34:
   asm sub di, 13063
nextline34:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 26
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 26
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
}

void sprite_ship2_odd(unsigned char far * video)
{
   sprite_show_ship2(video, 1);
}

void sprite_ship2_even(unsigned char far * video)
{
   sprite_show_ship2(video, 0);
}

sprite_show_ship3(unsigned char far * video, char odd)
{
   asm mov cl, odd
   asm les di, DWORD PTR video
   asm add di, 5
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline0
   asm add di, 13130
   asm jmp nextline0
oddline0:
   asm sub di, 13062
nextline0:
   asm add di, 5
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline1
   asm add di, 13130
   asm jmp nextline1
oddline1:
   asm sub di, 13062
nextline1:
   asm add di, 5
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 160
   asm stosb
   asm xor cl, 1
   asm jz oddline2
   asm add di, 13130
   asm jmp nextline2
oddline2:
   asm sub di, 13062
nextline2:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline3
   asm add di, 13130
   asm jmp nextline3
oddline3:
   asm sub di, 13062
nextline3:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline4
   asm add di, 13130
   asm jmp nextline4
oddline4:
   asm sub di, 13062
nextline4:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 248
   asm stosb
   asm xor cl, 1
   asm jz oddline5
   asm add di, 13130
   asm jmp nextline5
oddline5:
   asm sub di, 13062
nextline5:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline6
   asm add di, 13130
   asm jmp nextline6
oddline6:
   asm sub di, 13062
nextline6:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 11
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline7
   asm add di, 13130
   asm jmp nextline7
oddline7:
   asm sub di, 13062
nextline7:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 46
   asm stosb
   asm mov al, 110
   asm stosb
   asm xor cl, 1
   asm jz oddline8
   asm add di, 13130
   asm jmp nextline8
oddline8:
   asm sub di, 13062
nextline8:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 45
   asm stosb
   asm mov al, 159
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline9
   asm add di, 13129
   asm jmp nextline9
oddline9:
   asm sub di, 13063
nextline9:
   asm add di, 4
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 46
   asm stosb
   asm mov al, 103
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline10
   asm add di, 13129
   asm jmp nextline10
oddline10:
   asm sub di, 13063
nextline10:
   asm add di, 4
   asm mov al, 185
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline11
   asm add di, 13129
   asm jmp nextline11
oddline11:
   asm sub di, 13063
nextline11:
   asm add di, 4
   asm mov al, 182
   asm stosb
   asm mov al, 103
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline12
   asm add di, 13129
   asm jmp nextline12
oddline12:
   asm sub di, 13063
nextline12:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 249
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, es:[di]
   asm and al, 15
   asm add al, 224
   asm stosb
   asm xor cl, 1
   asm jz oddline13
   asm add di, 13129
   asm jmp nextline13
oddline13:
   asm sub di, 13063
nextline13:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 226
   asm stosb
   asm xor cl, 1
   asm jz oddline14
   asm add di, 13129
   asm jmp nextline14
oddline14:
   asm sub di, 13063
nextline14:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 204
   asm add al, 34
   asm stosb
   asm mov al, 217
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 226
   asm stosb
   asm xor cl, 1
   asm jz oddline15
   asm add di, 13129
   asm jmp nextline15
oddline15:
   asm sub di, 13063
nextline15:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 250
   asm stosb
   asm xor cl, 1
   asm jz oddline16
   asm add di, 13129
   asm jmp nextline16
oddline16:
   asm sub di, 13063
nextline16:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, 217
   asm stosb
   asm mov al, 153
   asm stosb
   asm mov al, 250
   asm stosb
   asm xor cl, 1
   asm jz oddline17
   asm add di, 13129
   asm jmp nextline17
oddline17:
   asm sub di, 13063
nextline17:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, 230
   asm stosb
   asm mov al, 102
   asm stosb
   asm mov al, 250
   asm stosb
   asm xor cl, 1
   asm jz oddline18
   asm add di, 13129
   asm jmp nextline18
oddline18:
   asm sub di, 13063
nextline18:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, 249
   asm stosb
   asm mov al, 155
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline19
   asm add di, 13129
   asm jmp nextline19
oddline19:
   asm sub di, 13063
nextline19:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 47
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline20
   asm add di, 13129
   asm jmp nextline20
oddline20:
   asm sub di, 13063
nextline20:
   asm add di, 3
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 254
   asm stosb
   asm xor cl, 1
   asm jz oddline21
   asm add di, 13129
   asm jmp nextline21
oddline21:
   asm sub di, 13063
nextline21:
   asm add di, 3
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline22
   asm add di, 13128
   asm jmp nextline22
oddline22:
   asm sub di, 13064
nextline22:
   asm add di, 3
   asm mov al, 255
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline23
   asm add di, 13128
   asm jmp nextline23
oddline23:
   asm sub di, 13064
nextline23:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm mov al, 251
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm xor cl, 1
   asm jz oddline24
   asm add di, 13129
   asm jmp nextline24
oddline24:
   asm sub di, 13063
nextline24:
   asm add di, 2
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 190
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm xor cl, 1
   asm jz oddline25
   asm add di, 13128
   asm jmp nextline25
oddline25:
   asm sub di, 13064
nextline25:
   asm inc di
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 15
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline26
   asm add di, 13127
   asm jmp nextline26
oddline26:
   asm sub di, 13065
nextline26:
   asm inc di
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 252
   asm stosb
   asm xor cl, 1
   asm jz oddline27
   asm add di, 13127
   asm jmp nextline27
oddline27:
   asm sub di, 13065
nextline27:
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 191
   asm stosb
   asm mov al, 239
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 192
   asm stosb
   asm xor cl, 1
   asm jz oddline28
   asm add di, 13126
   asm jmp nextline28
oddline28:
   asm sub di, 13066
nextline28:
   asm inc di
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 43
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 243
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 207
   asm stosb
   asm mov al, 254
   asm stosb
   asm mov al, es:[di]
   asm and al, 63
   asm add al, 128
   asm stosb
   asm xor cl, 1
   asm jz oddline29
   asm add di, 13126
   asm jmp nextline29
oddline29:
   asm sub di, 13066
nextline29:
   asm inc di
   asm mov al, es:[di]
   asm and al, 252
   asm add al, 2
   asm stosb
   asm mov al, es:[di]
   asm and al, 12
   asm add al, 179
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, 255
   asm stosb
   asm mov al, es:[di]
   asm and al, 48
   asm add al, 207
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm xor cl, 1
   asm jz oddline30
   asm add di, 13127
   asm jmp nextline30
oddline30:
   asm sub di, 13065
nextline30:
   asm add di, 2
   asm mov al, es:[di]
   asm and al, 192
   asm add al, 42
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm mov al, 170
   asm stosb
   asm xor cl, 1
   asm jz oddline31
   asm add di, 13128
   asm jmp nextline31
oddline31:
   asm sub di, 13064
nextline31:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 14
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 14
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm xor cl, 1
   asm jz oddline32
   asm add di, 13129
   asm jmp nextline32
oddline32:
   asm sub di, 13063
nextline32:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 6
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 6
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm xor cl, 1
   asm jz oddline33
   asm add di, 13129
   asm jmp nextline33
oddline33:
   asm sub di, 13063
nextline33:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 14
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 14
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm xor cl, 1
   asm jz oddline34
   asm add di, 13129
   asm jmp nextline34
oddline34:
   asm sub di, 13063
nextline34:
   asm add di, 3
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 6
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
   asm mov al, es:[di]
   asm and al, 240
   asm add al, 6
   asm stosb
   asm mov al, es:[di]
   asm and al, 3
   asm add al, 168
   asm stosb
}

void sprite_ship3_odd(unsigned char far * video)
{
   sprite_show_ship3(video, 1);
}

void sprite_ship3_even(unsigned char far * video)
{
   sprite_show_ship3(video, 0);
}

#include <alloc.h>
#include "sprite.h"

void sprite_init_ship(sprite_t s, int x, int y)
{
   s->x = x;
   s->y = y;
   s->oldx = x;
   s->oldy = y;
   s->xsize = 40;
   s->ysize = 36; 
   s->sprite0_odd  = sprite_ship0_odd;
   s->sprite0_even = sprite_ship0_even;
   s->sprite1_odd  = sprite_ship1_odd;
   s->sprite1_even = sprite_ship1_even;
   s->sprite2_odd  = sprite_ship2_odd;
   s->sprite2_even = sprite_ship2_even;
   s->sprite3_odd  = sprite_ship3_odd;
   s->sprite3_even = sprite_ship3_even;
   s->buff = malloc(s->ysize*s->xsize/4);
}

void sprite_clear_ship(sprite_t s)
{
   free(s->buff);
}

