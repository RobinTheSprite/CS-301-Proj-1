; iofunctions.asm
; Mark Underwood
; 9.30.17
; Contains functions designed to be run in iomain.cpp

section .text

;Getting everything in the right scope ----------------------;
global fopenASM
global fcloseASM
global readFromText
global spellItOut
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
		mov [stringFromBin+rsi], cl
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
		je next
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp encryptTextLoop

	next:
		mov [textKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		garbage:
		cmp rsi,0
		je encryptTextEnd
		rdtsc
		mov rcx,rax
		call srand
		call rand
		xor BYTE[rdi],al
		add rdi,1
		sub rsi,1
		jmp garbage

	encryptTextEnd:
		pop rsi
		pop rdi
		mov rax,0
		ret
;end encryptTextfile ----------------------------------------;

decryptTextfile:
	push rdi
	push rsi
	mov rdi,stringFromBin
	mov rsi,0
	mov al,[textKey]

	decryptTextLoop:
		cmp rsi,[endOfMessage]
		je nexxt
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp decryptTextLoop

	nexxt:
		mov [textKey],al
		mov QWORD[endOfMessage],rsi
		mov rdx,1024
		imul rsi,4
		sub rdx,rsi
		mov rsi,rdx

		zero:
		cmp rsi,0
		je encryptTextEnd
		mov BYTE[rdi],0
		add rdi,1
		sub rsi,1
		jmp zero

	decryptTextEnd:
		pop rsi
		pop rdi
		mov rax,0
		ret
;end decryptTextfile ---------------------------------------;

encryptBinfile:
	push rdi
	push rsi
	mov rdi,stringFromText
	mov rsi,0
	rdtsc
	
	encryptBinLoop:
		cmp rsi,1024
		je encryptBinEnd
		xor BYTE[rdi],al
		add rdi,1
		add rsi,1
	jmp encryptBinLoop

	encryptBinEnd:
		pop rsi
		pop rdi
		mov [binKey],al
		mov rax,0
		ret
;end encryptBinfile ----------------------------------------;

decryptBinfile:
	push rdi
	mov rdi,stringFromText
	push rsi
	mov rsi,0
	mov al,[binKey]

	decryptBinLoop:
		cmp rsi,1024
		je decryptBinEnd
		xor [rdi],al
		add rdi,1
		add rsi,1
	jmp decryptBinLoop

	decryptBinEnd:
		pop rsi
		pop rdi
		mov rax,0
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
endOfMessage:
	dq 0
binKey:
	db 0
