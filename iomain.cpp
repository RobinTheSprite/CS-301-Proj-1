/*
iomain.cpp
Mark Underwood
10.2.17
Uses some assembly language to play with text files
*/

#include <iostream>


extern "C" FILE * fopenASM(const char * filename, const char * mode);
extern "C" void fcloseASM(FILE * fptr);
extern "C" void hideStrings(FILE * fptr);
extern "C" void printfASM(char * string);

void microsoftWhy()
{
	FILE * nonsense = nullptr;
	int moreNonsense = 0;
	#pragma warning(suppress : 4996)
	fscanf(nonsense, "%i", &moreNonsense);
}

int main()
{
	FILE * fptr = fopenASM("test.txt", "r");

	hideStrings(fptr);
	
	//printfASM("Hallo");

	fcloseASM(fptr);

	while (std::cin.get() != '\n')

	return 0;
}