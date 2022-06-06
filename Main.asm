INCLUDE Irvine32.inc

.data
msg BYTE "Use WASD keys to move. Press Q to quit", 0
strScore BYTE "Score: ", 0
ground BYTE "########################################################################################################################", 0
xPos BYTE 20
yPos BYTE 20
score BYTE 0
xCoinPos BYTE ?
yCoinPos BYTE ?
inputChar BYTE ?

.code
main PROC
	; Display msg string
	mov dl, 0
	mov dh, 0
	call Gotoxy
	mov edx, OFFSET msg
	add score, -48
	call WriteString

	; Draw ground
	mov eax, green (green * 16)
	call SetTextColor
	mov dl, 0
	mov dh, 29
	call Gotoxy
	mov edx, OFFSET ground

	call WriteString
	call DrawPlayer
	call RandomCoin
	call DrawCoin
	call Randomize

	gameLoop:
		mov eax, white (black * 16)
		call SetTextColor
	; Draw score:
		mov dl, 0
		mov dh, 2
		call Gotoxy
		mov edx, OFFSET strScore
		call WriteString
		mov al, score
		add al, '0'
		call WriteInt
	; Score system:
		mov bl, xPos
		cmp bl, xCoinPos
		jne notCollected
		mov bl, yPos
		cmp bl, yCoinPos
		jne notCollected
	; Player collision with the coin:
		inc score
		call RandomCoin
		call DrawCoin
		mov eax, white (black * 16)
		call SetTextColor
		jmp gameLoop

	notCollected:
		; Gravity logic:
		gravity:
			cmp yPos, 28
			jge onGround
		; Make player fall
			call UpdatePlayer
			inc yPos
			call DrawPlayer
			mov eax, 80
			call Delay
			jmp gravity
		
		onGround:
		; Wall collision logic:
		
		rightWall:
			cmp xPos, 118
			jge moveLeft

		leftWall:
			cmp xPos, 0
			jle moveRight

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
				mov ecx, 5
			jumpLoop:
				call UpdatePlayer
				dec yPos
				call DrawPlayer
				mov eax, 10
				call Delay
				loop jumpLoop
				jmp gameLoop

			moveDown:
				mov bl, yPos
				cmp bl, 32
				dec yPos
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
	exitGame:
		exit
main ENDP

DrawPlayer PROC		; Draw player
	mov eax, yellow (black * 16)
	call SetTextColor
	dec yPos
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, ","
	call WriteChar
	mov eax, blue (black * 16)
	call SetTextColor
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

DrawCoin PROC
	mov eax, black (yellow * 16)
	call SetTextColor
	mov dl, xCoinPos
	mov dh, yCoinPos
	call Gotoxy
	mov al, "$"
	call WriteChar
	ret
DrawCoin ENDP

RandomCoin PROC
	mov eax, 90
	call RandomRange
	mov xCoinPos, al
	mov yCoinPos, 23
	cmp xCoinPos, 0
	inc xCoinPos
	ret
RandomCoin ENDP

END main
