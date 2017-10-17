/*
iomain.cpp
Mark Underwood
10.2.17
Uses some assembly language to play with text files
*/

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <string>
using std::string;
using std::getline;

extern "C" FILE * fopenASM(const char * filename, const char * mode);
extern "C" void fcloseASM(FILE * fptr);
extern "C" void readFromText(FILE * fptr);
extern "C" void readFromBin(FILE * bptr);
extern "C" void writeToText(FILE * fptr);
extern "C" void writeToBin(FILE * bptr);
extern "C" void encryptTextfile(string password);
extern "C" void decryptTextfile();
extern "C" void encryptBinfile();
extern "C" void decryptBinfile();

void microsoftWhy()
{
	FILE * nonsense = nullptr;
	int moreNonsense = 0;
	#pragma warning(suppress : 4996)
	fscanf(nonsense, "%i", &moreNonsense);
	char * extraStupid = "No, really";
	printf("AAAAAGGH: %s", extraStupid);
	fprintf(nonsense, "%i", moreNonsense);
}

int main()
{
	FILE * fptr = fopenASM("strings.txt", "r");
	std::cout << "Secret Message #1: ";
	readFromText(fptr);
	std::cout << std::endl;
	std::cout << std::endl;
	fcloseASM(fptr);

	FILE * bptr = fopenASM("strings_in_disguise.bin", "r");
	std::cout << "Secret Message #2: ";
	readFromBin(bptr);
	std::cout << std::endl;
	std::cout << std::endl;
	fcloseASM(bptr);
	
	string line;
	getline(cin, line);
	if (!cin)
	{
		cout << "Error readling input" << endl;
		return 1;
	}

	encryptTextfile(line);
	decryptTextfile();
	encryptBinfile();
	//decryptBinfile();
	
	FILE * fptrWrite = fopenASM("text_output.txt", "w");
	writeToText(fptrWrite);
	fcloseASM(fptrWrite);
	
	FILE * bptrWrite = fopenASM("bin_output.bin", "w");
	writeToBin(bptrWrite);
	fcloseASM(bptrWrite);

	std::cout << std::endl;
	std::cout << "Press ENTER to exit" << std::endl;
	while (std::cin.get() != '\n')

	return 0;
}