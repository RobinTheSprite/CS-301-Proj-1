; iofunctions.asm
; Mark Underwood
; 9.30.17
; Contains functions designed to be run in iomain.cpp

section .text

;Getting everything in the right scope ----------------------;
global fopenASM
global fcloseASM
global readFromText
global readFromBin
global writeToText
global writeToBin
global encrypt
global decrypt

extern fopen
extern fclose
extern fscanf
extern fprintf
extern fread
extern fwrite
extern feof
extern fgetc
extern putchar
extern printf
extern rand
extern srand
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

;fwrite
;NASM wrapper for C function fwrite. Writes data to a binary file.
fwriteASM:
	sub rsp,40
	call fwrite
	add rsp,40
	ret
;end fwriteASM ----------------------------------------------;

;readFromText
;Reads strings out of a text file and prints them to the screen.
readFromText:	
	push rsi
	push rdi
	mov rsi,rcx				
	mov rdi,strings

	readTextLoop:
		mov rcx,rsi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne readFromTextEnd

		mov rcx,rsi
		call fgetc
		mov [rdi],al
		add rdi,1
	jmp readTextLoop

	readFromTextEnd:
		;Manually clears the end of file integer out of memory 
		mov BYTE[rdi],0
		add rdi,1
		mov BYTE[rdi],0
		add rdi,1
		mov BYTE[rdi],0
		sub rdi,3
		mov BYTE[rdi],0

		pop rdi
		pop rsi
		mov rax,strings
		ret
;end readFromText --------------------------------------------;

;readFromBin
;Reads bytes from a binary file, converts each byte into a character, and prints to the screen.
readFromBin:			
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
		jne readFromBinEnd

		mov rcx,[currentChar]
		mov [strings+rsi], cl
		add rsi,1
		sub rsp,40
		call putchar
		add rsp,40
		
	jmp readBinLoop

	readFromBinEnd:
		pop rsi
		pop rdi
		ret
;end readFromBin ---------------------------------------------;

clearMemory:
	push rdi
	mov rdi,0
	clearEveryByte:
		cmp rdi,1024
		je clearEnd
		mov BYTE[strings+rdi],0
		add rdi,1
	jmp clearEveryByte

	clearEnd:
		pop rdi
		ret

;writeToText
;Reads a string from a stored location in memory and prints it to a text file.
writeToText:
	
	mov rdx,stringFormat
	mov r8,strings
	sub rsp,40
	call fprintf
	add rsp,40
	call clearMemory
	
	ret
;end writeToText --------------------------------------------;

;writeToBin
;writes input from a stored location in memory and stores it to a binary file.
writeToBin:
	push rdi
	push rsi
	push r13
	mov rdi,rcx
	mov rsi,strings
	mov r13,0
	writeBinLoop:
		mov r9,rdi
		mov r8,1
		mov rdx,1
		mov rcx,rsi
		cmp r13,1024
		je writeToBinEnd
		call fwriteASM
		add rsi,1
		add r13,1
	jmp writeBinLoop

	writeToBinEnd:
		pop r13
		pop rsi
		pop rdi
		call clearMemory
		ret
;end writeToBin ---------------------------------------------;

superXOR:
	mov r8,rcx
	superLoop:
		cmp rcx,0
		je superEnd
		mov r9,rcx
		and r9,0xFF
		xor rdx,r9
		shr rcx,8
	jmp superLoop

	superEnd:
		mov rcx,r8
		mov rax,0
		mov rax,rdx
		ret

;encrypt
;Takes bytes from a file and encrypts them for storage in another file.
encrypt:
	push rdi
	push rsi
	mov rdi,strings
	mov rsi,0
	
	encryptLoop:
		cmp BYTE[rdi],`\0`
		je encryptNext
		mov dl,[rdi]
		call superXOR
		mov [rdi],al
		add rdi,1
		add rsi,1
	jmp encryptLoop

	encryptNext:
		mov r10,rdi
		moveUp:
			cmp rdi,strings
			je storeLength
			mov r9b,[rdi]
			mov r9b,[rdi+1]
			sub rdi,1
		jmp moveUp

		storeLength:
			mov rdi,r10
			mov [strings],sil
	
		garbage:
			cmp rsi,1023
			je encryptEnd
			rdtsc
			mov rcx,rax
			call srand
			call rand
			xor [rdi],al
			add rdi,1
			add rsi,1
		jmp garbage

	encryptEnd:
		pop rsi
		pop rdi
		ret
;end encrypt ----------------------------------------;

;decrypt
;Takes bytes from a binary file and decrypts them for storage in a text file.
decrypt:
	push rdi
	push rsi
	mov rdi,strings
	add rdi,1
	mov rsi,0

	decryptLoop:
		cmp sil,[strings]
		je decryptNext
		mov dl,[rdi]
		call superXOR
		mov [rdi],al
		add rdi,1
		add rsi,1
	jmp decryptLoop

	decryptNext:
		mov sil,[strings]
		add rsi,1
		mov rdi,strings
		add rdi,rsi

		zeroBytes:
			cmp rsi,1023
			je decryptEnd
			mov BYTE[rdi],0
			add rdi,1
			add rsi,1
		jmp zeroBytes

	decryptEnd:
		mov BYTE[strings],0
		pop rsi
		pop rdi
		ret
;end decrypt ------------------------------------------------;


;Stored Data ------------------------------------------------;

section .data

strings:
	times 1024 db `\0`

cushion:
	db `\0`

stringFormat:
	db '%s ',0

intFormat:
	db '%i ',0

hexFormat:
	db '%x ',0

currentChar:
	db 0

endOfMessage:
	dd 0

