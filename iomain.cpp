/*
iomain.cpp
Mark Underwood
10.2.17
Uses some assembly language to play with text files
*/

#include <iostream>

extern "C" FILE * fopenASM(const char * filename, const char * mode);
extern "C" void fcloseASM(FILE * fptr);
extern "C" void readStrings(FILE * fptr);
extern "C" void printfASM(char * string);
extern "C" int spellItOut(FILE * bptr);

void microsoftWhy()
{
	FILE * nonsense = nullptr;
	int moreNonsense = 0;
	#pragma warning(suppress : 4996)
	fscanf(nonsense, "%i", &moreNonsense);
}

int main()
{
	FILE * fptr = fopenASM("strings.txt", "r");
	FILE * bptr = fopenASM("strings_in_disguise.bin", "r");

	std::cout << "A string from a text file: ";
	readStrings(fptr);

	std::cout << std::endl;
	std::cout << "A string printed from a series of bytes in a binary file: ";
	spellItOut(bptr);
	std::cout << std::endl;
	std::cout << std::endl;

	fcloseASM(bptr);
	fcloseASM(fptr);

	std::cout << "Press ENTER to exit" << std::endl;
	while (std::cin.get() != '\n')

	return 0;
}