; iofunctions.asm
; Mark Underwood
; 9.30.17
; Contains functions designed to be run in iomain.cpp

section .text

;Getting everything in the right scope ----------------------;
global fopenASM
global fcloseASM
global readStrings
global printfASM
global spellItOut

extern fopen
extern fclose
extern fscanf
extern putchar
extern printf
extern fread
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

;printfASM	
;NASM wrapper for C function printf. Prints stuff to the screen.
printfASM:		
	sub rsp,40
	call printf
	add rsp,40
	ret

;fcloseASM
;NASM wrapper for C function fclose. Closes a file when given a file pointer.
fcloseASM:		
	sub rsp,40
	call fclose
	add rsp,40
	ret

;readStrings
;Reads strings out of a text file and prints them to the screen.
readStrings:	
	push rsi	
	mov rsi,rcx
	readLoop:
		mov rcx,rsi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne readStringsEnd

		mov rcx,rsi
		mov rdx, stringFormat
		mov r8,stringInput

		sub rsp,40
		call fscanf
		add rsp,40

		mov rdx,stringInput
		mov rcx, stringFormat
		sub rsp,40
		call printfASM
		add rsp,40

	jmp readLoop

	readStringsEnd:
		pop rsi
		ret
;end readStrings --------------------------------------------;

;spellItOut
;Reads hex bytes from a binary file, converts each byte into a character, and prints to the screen.
spellItOut:			
	push rdi		
	mov rdi,rcx
	binLoop:
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
		sub rsp,40
		call putchar
		add rsp,40

	jmp binLoop

	spellItOutEnd:
		pop rdi
		ret
;end spellItOut ---------------------------------------------;

;Stored Data ------------------------------------------------;

section .data
stringInput:
	times 1000 db 'x'
	db ` \0`
stringFormat:
	db '%s ',0
currentChar:
	db 0