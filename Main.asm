INCLUDE Irvine32.inc

.data

ground BYTE "########################################################################################################################", 0
xPos BYTE 20
yPos BYTE 20
inputChar BYTE ?

.code
main PROC
	; Draw ground
	mov dl, 0
	mov dh, 29
	call Gotoxy
	mov edx, OFFSET ground
	call WriteString

	call DrawPlayer

	gameLoop:
	; Get key input
		call ReadChar
		mov inputChar, al
	; Quit game if user inputs "q"
		cmp inputChar, "q"
		je exitGame

		cmp inputChar, "w"
		je moveUp

		cmp inputChar, "s"
		je moveDown

		cmp inputChar, "a"
		je moveLeft

		cmp inputChar, "d"
		je moveRight

		moveUp:
		dec yPos
		call DrawPlayer

		moveDown:
		inc yPos
		call DrawPlayer

		moveLeft:
		dec xPos
		call DrawPlayer

		moveRight:
		inc xPos
		call DrawPlayer

	jmp gameLoop

	exitGame:
	exit
main ENDP

DrawPlayer PROC		; Draw player
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, "X"
	call WriteChar
	ret
DrawPlayer ENDP

END main