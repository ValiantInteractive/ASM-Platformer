INCLUDE Irvine32.inc

.data
msg BYTE "Use WASD keys to move. Press Q to quit", 0
ground BYTE "########################################################################################################################", 0
xPos BYTE 20
yPos BYTE 20
inputChar BYTE ?
isJumping BYTE "F"

.code
main PROC
	; Display msg string
	mov dl, 0
	mov dh, 0
	call Gotoxy
	mov edx, OFFSET msg
	call WriteString
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
		call UpdatePlayer
		dec yPos
		call DrawPlayer
		jmp gameLoop

		moveDown:
		call UpdatePlayer
		inc yPos
		call DrawPlayer
		jmp gameLoop

		moveLeft:
		call UpdatePlayer
		dec xPos
		call DrawPlayer
		jmp gameLoop

		moveRight:
		call UpdatePlayer
		inc xPos
		call DrawPlayer
		jmp gameLoop

	jmp gameLoop

	exitGame:
	exit
main ENDP

DrawPlayer PROC		; Draw player
	dec yPos
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, ","
	call WriteChar
	inc yPos
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, "X"
	call WriteChar
	ret
DrawPlayer ENDP

UpdatePlayer PROC	; Update previous X- and Y-coordinates with blank spaces
	dec yPos
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, " "
	call WriteChar
	inc yPos
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
UpdatePlayer ENDP

END main