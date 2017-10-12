; iofunctions.asm
; Mark Underwood
; 9.30.17
; Contains functions designed to be run in iomain.cpp

section .text

;Getting everything in the right scope ----------------------;
global fopenASM
global fcloseASM
global printfASM
global readStrings
global spellItOut
global writeToText
global writeToBin

extern fopen
extern fclose
extern fscanf
extern fprintf
extern putchar
extern printf
extern fread
extern fwrite
extern feof
;------------------------------------------------------------;

;Functions --------------------------------------------------;

;fopenASM
;NASM wrapper for C function fopen. Gets a file open.
fopenASM:		
	sub rsp,40
	call fopen
	add rsp,40
	ret
;end fopenASM -----------------------------------------------;

;printfASM	
;NASM wrapper for C function printf. Prints stuff to the screen.
printfASM:		
	sub rsp,40
	call printf
	add rsp,40
	ret
;end printfASM ----------------------------------------------;

;fcloseASM
;NASM wrapper for C function fclose. Closes a file when given a file pointer.
fcloseASM:		
	sub rsp,40
	call fclose
	add rsp,40
	ret
;end fcloseASM ----------------------------------------------;

;readStrings
;Reads strings out of a text file and prints them to the screen.
readStrings:	
	push rsi
	push rdi
	mov rsi,rcx
	mov rdi,stringToRead
	readTextLoop:
		mov rcx,rsi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne readStringsEnd

		mov rcx,rsi
		mov rdx,stringFormat
		mov r8,rdi
		sub rsp,40
		call fscanf
		add rsp,40

		mov rdx,rdi
		mov rcx, stringFormat
		sub rsp,40
		call printfASM
		add rsp,40

		add rdi,64
	jmp readTextLoop

	readStringsEnd:
		pop rdi
		pop rsi
		ret
;end readStrings --------------------------------------------;

;spellItOut
;Reads bytes from a binary file, converts each byte into a character, and prints to the screen.
spellItOut:			
	push rdi
	push rsi
	mov rdi,rcx
	mov rsi,0
	readBinLoop:
		mov r9,rdi
		mov r8,1
		mov rdx,1
		mov rcx,currentChar
		sub rsp,40
		call fread
		add rsp,40

		mov rcx,rdi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne spellItOutEnd

		mov rcx,[currentChar]
		mov BYTE[stringToWrite+rsi], cl
		sub rsp,40
		call putchar
		add rsp,40
		add rsi,1

	jmp readBinLoop

	spellItOutEnd:
		pop rsi
		pop rdi
		ret
;end spellItOut ---------------------------------------------;

;writeToText
;Reads a string from a stored location in memory and prints it to a text file.
writeToText:
	mov rdx,stringFormat
	mov r8,stringToWrite
	sub rsp,40
	call fprintf
	add rsp,40
	ret
;end writeToText --------------------------------------------;

writeToBin:
	push rdi
	push rsi
	push r13
	mov rdi,rcx
	mov rsi,stringToRead
	mov r13,0
	writeBinLoop:
		mov r9,rdi
		mov r8,1
		mov rdx,64
		mov rcx,rsi
		cmp BYTE[rcx],`\0`
		je writeToBinEnd
		sub rsp,40
		call fwrite
		add rsp,40
		add rsi,64
		add r13,1
	jmp writeBinLoop

writeToBinEnd:
	pop r13
	pop rsi
	pop rdi
	ret
;end writeToBin ---------------------------------------------;

;Stored Data ------------------------------------------------;

section .data
stringToRead:
	times 1000 db `\0`
stringFormat:
	db '%s ',0
currentChar:
	db 0
stringToWrite:
	times 1000 db `\0`