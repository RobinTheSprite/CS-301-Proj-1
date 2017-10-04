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
extern puts
extern putchar
extern fread
extern fwrite
extern feof
extern ftell
;------------------------------------------------------------;

;Functions --------------------------------------------------;

;fopenASM
;NASM wrapper for C function fopen. Gets a file open.
fopenASM:		
	sub rsp,40
	call fopen
	add rsp,40
	ret

;printASM	
;NASM wrapper for C function puts. Prints a string to the screen.
putsASM:		
	sub rsp,40
	call puts
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
;Reads the first string in from a .txt file. All the extra gubbins that you see here
;is an attempt to loop the function and get every string out of the file, but 
;that is WIP for now, so the loop is commented out.
readStrings:	
	push rsi	
	mov rsi,rcx
	readLoop:
		mov rcx,rsi
		mov rdx, inputForFscanf
		mov r8,readString

		sub rsp,40
		call fscanf
		add rsp,40

		mov rcx,rsi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne readStringsEnd

		mov rcx,readString
		sub rsp,40
		call putsASM
		add rsp,40

		;mov rcx,rsi
		;ub rsp,40
		;call ftell
		;add rsp,40
		;mov rsi,rax
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
		mov rax,0
		ret
;end spellItOut --------------------------------------------;

;Stored Data ------------------------------------------------;

section .data
readString:
	db '',`\n\0`
inputForFscanf:
	db '%s',0
currentChar:
	db 0