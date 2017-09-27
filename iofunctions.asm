section .text
global bar

bar:
	extern fopen
	extern fclose
	extern puts

	mov rcx, string
	call puts
	;call fopen
	;mov rcx, rax
	;call fclose

	mov rax,0
	ret


section .data

string:
	db "test.txt",0