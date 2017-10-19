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
extern fprintf
extern fread
extern fwrite
extern feof
extern fgetc
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
	mov rdi,stringsIn

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
		;Manually clear the end of file integer out of memory 
		mov BYTE[rdi],0
		add rdi,1
		mov BYTE[rdi],0
		add rdi,1
		mov BYTE[rdi],0
		sub rdi,3
		mov BYTE[rdi],0

		pop rdi
		pop rsi
		mov rax,stringsIn
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
		mov [stringsIn + rsi], cl	;Put the byte into memory
		add rsi,1
		
	jmp readBinLoop

	readFromBinEnd:
		pop rsi
		pop rdi
		mov rax,stringsIn
		ret
;end readFromBin ---------------------------------------------;

;clearMemory
;Zeros the memory buffers so they can be reused.
clearMemory:
	push rdi
	mov rdi,0
	clearEveryByte:
		cmp rdi,1024
		je clearEnd
		mov BYTE[stringsIn + rdi],0				
		mov BYTE[stringsPlusOne + rdi],0	
		add rdi,1
	jmp clearEveryByte

	clearEnd:
		pop rdi
		ret

;writeToText
;Reads a string from a stored location in memory and prints it to a text file.
writeToText:
	
	mov rdx,stringFormat
	mov r8,stringsPlusOne
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
	mov rsi,stringsPlusOne
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

;superXOR
;XORs each byte with every character in the password.
superXOR:
	mov r8,rcx
	superLoop:
		cmp rcx,0
		je superEnd
		mov r9,rcx
		and r9,0xFF		;Extract low bits of password
		xor rdx,r9		
		shr rcx,8		;Get new byte into lowest position
	jmp superLoop

	superEnd:
		mov rcx,r8
		mov rax,0
		mov rax,rdx
		ret
;end superXOR -----------------------------------------------;

;encrypt
;Takes bytes from a file and encrypts them for storage in another file.
encrypt:
	push rdi
	mov rdi,0

	encryptLoop:
		cmp BYTE[stringsIn + rdi],`\0`
		je encryptNext
		mov dl,[stringsIn + rdi]
		call superXOR
		mov [stringsPlusOne + rdi + 1],al	;In the new buffer, put an empty 
		add rdi,1								;byte right at the beginning.
	jmp encryptLoop

	encryptNext:
		mov [stringsPlusOne],dil			;Put the length of the message in that empty byte
	
		garbage:							;Make everything after the message random junk
			cmp rdi,1023
			je encryptEnd
			rdtsc
			mov rcx,rax
			call srand
			call rand
			xor [stringsPlusOne + rdi + 1],al
			add rdi,1
		jmp garbage

	encryptEnd:
		pop rdi
		ret
;end encrypt ----------------------------------------;

;decrypt
;Takes bytes from a binary file and decrypts them for storage in a text file.
decrypt:
	push rdi
	push rsi
	mov rsi,0
	xor rdi,rdi
	mov dil,[stringsIn]

	decryptLoop:
		cmp sil,[stringsIn]
		je decryptNext
		mov dl,[stringsIn + rsi + 1]
		call superXOR
		mov [stringsPlusOne + rsi],al		;Now that the size of the message
		add rsi,1								;is in memory, we can get rid
	jmp decryptLoop								;of that extra byte at the beginning.

	decryptNext:
		
		zeroBytes:							;Get rid of the random junk from the encryption.
			cmp rdi,1023
			je decryptEnd
			mov BYTE[stringsPlusOne + rdi],0
			add rdi,1
			add rsi,1
		jmp zeroBytes

	decryptEnd:
		pop rsi
		pop rdi
		ret
;end decrypt ------------------------------------------------;


;Stored Data ------------------------------------------------;

section .data

stringsIn:
	times 1024 db `\0`

stringsPlusOne:
	times 1024 db `\0`

currentChar:
	db 0

stringFormat:
	db '%s ',0

intFormat:
	db '%i ',0

hexFormat:
	db '%x ',0




