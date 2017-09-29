section .text
global bar

bar:
	extern fopen
	extern fclose
	extern fgetc
	extern putchar

	sub rsp,40
	call fopen
	mov rcx, rax
	add rsp,40
	push rcx

	sub rsp,40
	call fgetc
	mov rcx,rax
	call putchar
	add rsp,40

	pop rcx
	sub rsp,40
	call fclose
	add rsp,40
	
	mov rax,0
	ret