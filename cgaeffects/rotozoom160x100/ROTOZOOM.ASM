   DOSSEG
   .MODEL small
   .CODE

   PUBLIC _rotozoom
_rotozoom PROC
   ARG buff:DWORD, x:BYTE, y:BYTE, xinc:WORD, yinc:WORD

   push bp
   mov bp, sp
   push di
   push si
   push ds

   mov si, [xinc]       ; hard code buffer jumps in horizontal direction
   mov di, [yinc]

   xor bx, bx
   xor dx, dx

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz1+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz2+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz3+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz4+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz5+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz6+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz7+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz8+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz9+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz10+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz11+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz12+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz13+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz14+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz15+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz16+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz17+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz18+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz19+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz20+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz21+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz22+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz23+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz24+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz25+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz26+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz27+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz28+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz29+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz30+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz31+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz32+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz33+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz34+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz35+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz36+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz37+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz38+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz39+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz40+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz41+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz42+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz43+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz44+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz45+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz46+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz47+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz48+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz49+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz50+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz51+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz52+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz53+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz54+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz55+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz56+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz57+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz58+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz59+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz60+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz61+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz62+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz63+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz64+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz65+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz66+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz67+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz68+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz69+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz70+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz71+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz72+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz73+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz74+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz75+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz76+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz77+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz78+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz79+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz80+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz81+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz82+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz83+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz84+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz85+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz86+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz87+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz88+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz89+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz90+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz91+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz92+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz93+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz94+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz95+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz96+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz97+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz98+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz99+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz100+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz101+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz102+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz103+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz104+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz105+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz106+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz107+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz108+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz109+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz110+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz111+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz112+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz113+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz114+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz115+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz116+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz117+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz118+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz119+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz120+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz121+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz122+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz123+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz124+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz125+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz126+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz127+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz128+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz129+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz130+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz131+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz132+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz133+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz134+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz135+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz136+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz137+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz138+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz139+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz140+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz141+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz142+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz143+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz144+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz145+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz146+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz147+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz148+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz149+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz150+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz151+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz152+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz153+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz154+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz155+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz156+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz157+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz158+2], ax

   add bx, si           ; add incs
   add dx, di
   mov ah, dh           ; compute jumps
   mov al, bh
   mov WORD PTR cs:[rz159+2], ax

   lds si, [buff]       ; set DS:SI = buff, ES:DI = CGA memory, SI wil be 0
   mov ax, 0b800h
   mov es, ax
   xor di, di

   mov al, [x]          ; move to x, y in buff
   mov ah, [y]
   add si, ax

   xor bx, bx           ; initialise coordinates in vertical direction
   mov bh, al 
   xor dx, dx
   mov dh, ah

   mov cx, 100          ; loop iterations
   push bp
   mov bp, 0ff0h

rz_loop:

   inc di
   mov ah, [si]
rz1:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz2:
   mov ah, [si+01234h]
rz3:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz4:
   mov ah, [si+01234h]
rz5:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz6:
   mov ah, [si+01234h]
rz7:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz8:
   mov ah, [si+01234h]
rz9:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz10:
   mov ah, [si+01234h]
rz11:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz12:
   mov ah, [si+01234h]
rz13:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz14:
   mov ah, [si+01234h]
rz15:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz16:
   mov ah, [si+01234h]
rz17:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz18:
   mov ah, [si+01234h]
rz19:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz20:
   mov ah, [si+01234h]
rz21:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz22:
   mov ah, [si+01234h]
rz23:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz24:
   mov ah, [si+01234h]
rz25:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz26:
   mov ah, [si+01234h]
rz27:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz28:
   mov ah, [si+01234h]
rz29:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz30:
   mov ah, [si+01234h]
rz31:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz32:
   mov ah, [si+01234h]
rz33:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz34:
   mov ah, [si+01234h]
rz35:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz36:
   mov ah, [si+01234h]
rz37:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz38:
   mov ah, [si+01234h]
rz39:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz40:
   mov ah, [si+01234h]
rz41:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz42:
   mov ah, [si+01234h]
rz43:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz44:
   mov ah, [si+01234h]
rz45:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz46:
   mov ah, [si+01234h]
rz47:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz48:
   mov ah, [si+01234h]
rz49:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz50:
   mov ah, [si+01234h]
rz51:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz52:
   mov ah, [si+01234h]
rz53:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz54:
   mov ah, [si+01234h]
rz55:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz56:
   mov ah, [si+01234h]
rz57:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz58:
   mov ah, [si+01234h]
rz59:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz60:
   mov ah, [si+01234h]
rz61:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz62:
   mov ah, [si+01234h]
rz63:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz64:
   mov ah, [si+01234h]
rz65:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz66:
   mov ah, [si+01234h]
rz67:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz68:
   mov ah, [si+01234h]
rz69:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz70:
   mov ah, [si+01234h]
rz71:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz72:
   mov ah, [si+01234h]
rz73:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz74:
   mov ah, [si+01234h]
rz75:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz76:
   mov ah, [si+01234h]
rz77:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz78:
   mov ah, [si+01234h]
rz79:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz80:
   mov ah, [si+01234h]
rz81:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz82:
   mov ah, [si+01234h]
rz83:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz84:
   mov ah, [si+01234h]
rz85:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz86:
   mov ah, [si+01234h]
rz87:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz88:
   mov ah, [si+01234h]
rz89:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz90:
   mov ah, [si+01234h]
rz91:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz92:
   mov ah, [si+01234h]
rz93:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz94:
   mov ah, [si+01234h]
rz95:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz96:
   mov ah, [si+01234h]
rz97:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz98:
   mov ah, [si+01234h]
rz99:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz100:
   mov ah, [si+01234h]
rz101:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz102:
   mov ah, [si+01234h]
rz103:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz104:
   mov ah, [si+01234h]
rz105:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz106:
   mov ah, [si+01234h]
rz107:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz108:
   mov ah, [si+01234h]
rz109:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz110:
   mov ah, [si+01234h]
rz111:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz112:
   mov ah, [si+01234h]
rz113:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz114:
   mov ah, [si+01234h]
rz115:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz116:
   mov ah, [si+01234h]
rz117:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz118:
   mov ah, [si+01234h]
rz119:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz120:
   mov ah, [si+01234h]
rz121:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz122:
   mov ah, [si+01234h]
rz123:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz124:
   mov ah, [si+01234h]
rz125:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz126:
   mov ah, [si+01234h]
rz127:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz128:
   mov ah, [si+01234h]
rz129:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz130:
   mov ah, [si+01234h]
rz131:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz132:
   mov ah, [si+01234h]
rz133:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz134:
   mov ah, [si+01234h]
rz135:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz136:
   mov ah, [si+01234h]
rz137:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz138:
   mov ah, [si+01234h]
rz139:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz140:
   mov ah, [si+01234h]
rz141:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz142:
   mov ah, [si+01234h]
rz143:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz144:
   mov ah, [si+01234h]
rz145:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz146:
   mov ah, [si+01234h]
rz147:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz148:
   mov ah, [si+01234h]
rz149:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz150:
   mov ah, [si+01234h]
rz151:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz152:
   mov ah, [si+01234h]
rz153:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz154:
   mov ah, [si+01234h]
rz155:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz156:
   mov ah, [si+01234h]
rz157:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   inc di
rz158:
   mov ah, [si+01234h]
rz159:
   mov al, [si+01234h]
   and ax, bp
   add al, ah
   stosb

   pop bp
   sub bx, [yinc]       ; jump by (-yinc, xinc) in vertical direction
   add dx, [xinc]
   mov al, bh
   mov ah, dh
   mov si, ax
   push bp
   mov bp, 0ff0h

   dec cx
   jz rz_done
   jmp rz_loop

rz_done:

   pop bp
   
   pop ds
   pop si
   pop di
   pop bp
   ret   
_rotozoom ENDP

   END