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
global encryptTextfile
global decryptTextfile
global encryptBinfile
global decryptBinfile

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
	mov rsi,rcx				;rsi = file pointer
	mov rdi,stringFromText	;rdi = pointer to variable
	readTextLoop:
		mov rcx,rsi
		sub rsp,40
		call feof
		add rsp,40
		cmp rax,0
		jne readFromTextEnd

		mov rcx,rsi
		call fgetc
		mov [rdi],rax
		add rdi,1

		mov rcx, rax
		call putchar
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
		mov [stringFromBin+rsi], cl
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

;writeToText
;Reads a string from a stored location in memory and prints it to a text file.
writeToText:
	mov rdx,stringFormat
	mov r8,stringFromBin
	sub rsp,40
	call fprintf
	add rsp,40
	ret
;end writeToText --------------------------------------------;

;writeToBin
;writes input from a stored location in memory and stores it to a binary file.
writeToBin:
	push rdi
	push rsi
	push r13
	mov rdi,rcx
	mov rsi,stringFromText
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
		ret
;end writeToBin ---------------------------------------------;

;encryptTextfile
;Takes bytes from a binary file and encrypts them for storage in a text file.
encryptTextfile:
	push rdi
	push rsi
	mov rdi,stringFromBin
	mov rsi,0
	rdtsc
	mov rcx,rax
	call srand
	call rand
	
	encryptTextLoop:
		cmp BYTE[rdi],`\0`
		je encryptTextNext
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp encryptTextLoop

	encryptTextNext:
		mov [textKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		garbageText:
			cmp rsi,0
			je encryptTextEnd
			rdtsc
			mov rcx,rax
			call srand
			call rand
			xor BYTE[rdi],al
			add rdi,1
			sub rsi,1
		jmp garbageText

	encryptTextEnd:
		pop rsi
		pop rdi
		ret
;end encryptTextfile ----------------------------------------;

;decryptTextfile
;Takes bytes from a binary file and decrypts them for storage in a text file.
decryptTextfile:
	push rdi
	push rsi
	mov rdi,stringFromBin
	mov rsi,0
	mov al,[textKey]

	decryptTextLoop:
		cmp rsi,[endOfMessage]
		je decryptTextNext
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp decryptTextLoop

	decryptTextNext:
		mov [textKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		zeroText:
			cmp rsi,0
			je encryptTextEnd
			mov BYTE[rdi],0
			add rdi,1
			sub rsi,1
		jmp zeroText

	decryptTextEnd:
		pop rsi
		pop rdi
		ret
;end decryptTextfile ---------------------------------------;

;encryptBinfile
;Encrypts bytes from a text file to prepare them for storage in a binary file.
encryptBinfile:
	push rdi
	push rsi
	mov rdi,stringFromText
	mov rsi,0
	rdtsc
	mov rcx,rax
	call srand
	call rand
	
	encryptBinLoop:
		cmp BYTE[rdi],`\0`
		je encryptBinNext
		xor BYTE[rdi],al
		add rdi,1
		add rsi,1
	jmp encryptBinLoop

	encryptBinNext:
		mov [binKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		garbageBin:		;Not intentional, but still funny
			cmp rsi,0
			je encryptBinEnd
			rdtsc
			mov rcx,rax
			call srand
			call rand
			xor BYTE[rdi],al
			add rdi,1
			sub rsi,1
		jmp garbageBin
		
	encryptBinEnd:
		pop rsi
		pop rdi
		ret
;end encryptBinfile ----------------------------------------;

;decryptBinfile
;Decrypts bytes from a text file to prepare them for storage in a binary file.
decryptBinfile:
	push rdi
	mov rdi,stringFromText
	push rsi
	mov rsi,0
	mov al,[binKey]

	decryptBinLoop:
		cmp rsi,[endOfMessage]
		je decryptBinNext
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp decryptBinLoop

	decryptBinNext:
		mov [binKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		zeroBin:
		cmp rsi,0
		je encryptTextEnd
		mov BYTE[rdi],0
		add rdi,1
		sub rsi,1
		jmp zeroBin

	decryptBinEnd:
		pop rsi
		pop rdi
		ret
;Stored Data ------------------------------------------------;

section .data

stringFromText:
	times 1024 db `\0`

stringFromBin:
	times 1024 db `\0`

stringFormat:
	db '%s ',0

intFormat:
	db '%i ',0

currentChar:
	db 0

textKey:
	db 0

binKey:
	db 0

endOfMessage:
	dq 0

