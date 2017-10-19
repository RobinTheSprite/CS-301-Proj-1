/*
iomain.cpp
Mark Underwood
10.2.17
Uses assembly language to encrypt and decrypt files
*/

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <string>
using std::string;
using std::getline;

extern "C" FILE * fopenASM(const char *, const char *);
extern "C" void fcloseASM(FILE *);
extern "C" const char * readFromText(FILE *);
extern "C" const char * readFromBin(FILE *);
extern "C" void writeToText(FILE *);
extern "C" void writeToBin(FILE *);
extern "C" void encrypt(int);
extern "C" void decrypt(int);

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

int castPasswordToInt(string password)
{
	int iPassword = 0;

	for (int i = 0; i != password.size(); ++i)
	{
		iPassword += password[i];
		iPassword = iPassword << 8;
	}
	return iPassword;
}

int main()
{
	cout << "The Most Inefficiently Written File Encrypter Ever Made" << endl;
	cout << endl;
	cout << "Thanks, NASM, for making me value actual programming languages." << endl;
	cout << endl;

	cout << "Enter a Password: ";
	string line;
	getline(cin, line);
	if (!cin)
	{
		cout << "Error readling input" << endl;
		return 1;
	}
	cout << endl;

	FILE * fptr = fopenASM("encrypted.txt", "r");
	if (!fptr)
	{
		cout << "Error Reading File" << endl;
	}

	const char * memory = readFromText(fptr);
	std::cout << "Text File Read" << std::endl;
	std::cout << std::endl;
	fcloseASM(fptr);

	//encrypt(castPasswordToInt(line));
	decrypt(castPasswordToInt(line));

	FILE * fptrWrite = fopenASM("text_output.txt", "w");
	if (!fptrWrite)
	{
		cout << "Error Reading File" << endl;
	}
	writeToText(fptrWrite);
	fcloseASM(fptrWrite);

	FILE * bptr = fopenASM("encrypted.bin", "r");
	std::cout << "Bin File Read";
	readFromBin(bptr);
	if (!bptr)
	{
		cout << "Error Reading File" << endl;
	}
	std::cout << std::endl;
	fcloseASM(bptr);

	//encrypt(castPasswordToInt(line));
	decrypt(castPasswordToInt(line));
	
	FILE * bptrWrite = fopenASM("bin_output.bin", "w");
	if (!bptrWrite)
	{
		cout << "Error Reading File" << endl;
	}
	writeToBin(bptrWrite);
	fcloseASM(bptrWrite);

	std::cout << std::endl;
	std::cout << "Press ENTER to exit" << std::endl;
	while (std::cin.get() != '\n')

	return 0;
}