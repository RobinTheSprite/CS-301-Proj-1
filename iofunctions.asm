; iofunctions.asm
; Mark Underwood
; 9.30.17
; Contains functions designed to be run in iomain.cpp

section .text

;------ Getting everything in the right scope ---------------;
global fopenASM
global fcloseASM
global hideStrings
global printfASM

extern fopen
extern fclose
extern fscanf
extern puts
;------------------------------------------------------------;

;------ Functions -------------------------------------------;
fopenASM:
	sub rsp,40
	call fopen
	add rsp,40
	ret
	
printfASM:
	sub rsp,40
	call puts
	add rsp,40
	ret

fcloseASM:	
	sub rsp,40
	call fclose
	add rsp,40
	ret

hideStrings:
	mov rdx, inputForFscanf
	mov r8,readString

	sub rsp,40
	call fscanf
	add rsp,40

	mov rcx,readString

	sub rsp,40
	call printfASM
	add rsp,40
	
	ret

;------------------------------------------------------------;

section .data
readString:
	db '',0
inputForFscanf:
	db '%s',0