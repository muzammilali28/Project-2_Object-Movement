[org 0x100]

jmp start

di_inc: dw 0
rec_x: dw 7
rec_y: dw 5

msg: db 'Move:',0
size_msg: dw 0

row: dw 10
col: dw 35


	clrScr:
	push bp
	mov bp,sp
	push ax
	push cx
	push di
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov cx, 2000
	cld
	mov di,0
	rep stosw
	pop di
	pop cx
	pop ax
	pop bp
	ret
	
	clrScr2:
	push bp
	mov bp,sp
	push ax
	push cx
	push di
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov cx,1840
	cld
	mov di,320
	rep stosw
	pop di
	pop cx
	pop ax
	pop bp
	ret
	
 strLen:
 push bp
 mov bp, sp
 push es
 push cx
 push si
 push di
 push ds
 pop es
 mov di, [bp+4]
 mov cx, 0xffff
 xor al, al
 repne scasb
 mov ax, 0xffff
 sub ax, cx 
 dec ax 
 pop di
 pop si
 pop cx
 pop es
 pop bp
 ret 2

	screenLocation:
	push bp
	mov bp,sp
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov ax,[bp+6]
	mov bl,80
	mul bl
	add ax,[bp+4]
	shl ax,1
	
	pop es
	pop bp
	ret 2

	printRectangle:
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	mov ax,0xb800
	mov es,ax
	mov cx,[rec_y]
	mov di,[bp+4]
	
	OuterLoop:
	mov bx,[rec_x]
	cld
	innerLoop:
	mov al,'*'
	mov ah,0x0F
	stosw
	add word[di_inc],2
	mov al,' '
	mov ah,0x0F
	stosw
	add word[di_inc],2
	dec bx
	cmp bx,0
	jne innerLoop
	sub di,[di_inc]
	add di,160
	mov word[di_inc],0
	loop OuterLoop
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 
	

start:
mov ax,0
mov bx,0
mov cx,0
mov dx,0
mov si,0
mov di,0

call clrScr
mov ax,[row] ;ROW
push ax
mov ax,[col] ;COL
push ax
call screenLocation
mov di,ax
push di
call printRectangle
mov ax,0

push bp
push es

printMsg:
mov ax,msg
push ax
mov ax,0
call strLen
mov word[size_msg],ax
mov ax,0
mov al,1
mov bh,0
mov bl,0x0F
mov cx,[size_msg]
mov dh,0
mov dl,0
push cs
pop es
mov bp,msg
mov ah,13h
int 10h

pop es
pop bp

mov ax,0
mov bx,0
mov cx,0
mov dx,0

intake:
mov dh,0
mov dl,[size_msg]
inc dl
mov bh,0
mov ah,2
int 10h

mov ah,0
int 16h
mov ah,0Eh
int 10h

cmp al,0x48
je UP
cmp al,0x4B
je LEFT
cmp al,0x4D
je RIGHT
cmp al,0x50
je DOWN
cmp al,'Q'
je exit
cmp al,'q'
jmp exit

mov ax,0
mov bx,0
mov cx,0
mov dx,0
jmp intake

UP:
sub word[row],1
call clrScr2
mov ax,[row]    ;UP_ROW
push ax
mov ax,[col]    ;UP_COL
push ax         ;35
call screenLocation
mov di,ax
push di
call printRectangle
jmp intake

LEFT:
sub word[col],1
call clrScr2
mov ax,[row]    ;LEFT_ROW
push ax         ;10
mov ax,[col]    ;LEFT_COL
push ax
call screenLocation
mov di,ax
push di
call printRectangle
jmp intake

RIGHT:
add word[col],1
call clrScr2
mov ax,[row]     ;RIGHT_ROW
push ax
mov ax,[col]     ;RIGHT_COL
push ax
call screenLocation
mov di,ax
push di
call printRectangle
jmp intake

DOWN:
add word[row],1
call clrScr2
mov ax,[row]     ;DOWN_ROW
push ax
mov ax,[col]     ;DOWN_COL
push ax
call screenLocation
mov di,ax
push di
call printRectangle
jmp intake

exit:
mov ax,0x4c00
int 21h
