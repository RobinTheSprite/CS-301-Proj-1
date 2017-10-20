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

//Tells the .asm that yes, it is okay to use these functions.
//You have Microsoft™ 's permission.
void microsoft™Why()
{
	FILE * nonsense = nullptr;
	int moreNonsense = 0;
	#pragma warning(suppress : 4996)
	fscanf(nonsense, "%i", &moreNonsense);
	char * extraStupid = "No, really";
	printf("AAAAAGGH: %s", extraStupid);
	fprintf(nonsense, "%i", moreNonsense);
}

//castPasswordToInt
//Turn the string that the user put in into a series of bytes.
//Because int is 4 bytes, the password can only be 4 characters.
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
	cout << "Enter a blank line at any time to exit." << endl;
	cout << endl;

	string line; //Password input
	string filename; //File name input
	bool encryptSelected = false; //Check for encryption or decryption

	while (1) //Get the user's preference: encrypt or decrypt
	{
		cout << "Encrypt or Decrypt: ";
		getline(cin, line);
		if (!cin)
		{
			cout << "Error readling input" << endl;
			continue;
		}
		else if (line == "")
		{
			return 0;
		}
		else if (line == "encrypt")
		{
			encryptSelected = true;
		}
		else if (line == "decrypt")
		{
			cout << endl;
			break;
		}
		else
		{
			cout << "Not valid input" << endl;
			continue;
		}
		cout << endl;
		break;
	}

	while (1) //Get the filename that the user wants to use
	{
		cout << "Enter the name of the file you wish to operate on: ";
		getline(cin, filename);
		if (!cin)
		{
			cout << "Error readling input" << endl;
			continue;
		}
		if (line == "")
		{
			return 0;
		}

		const char * cstrFilename = filename.c_str();
		FILE * fptr = fopenASM(cstrFilename, "r");

		if (!fptr)	//Was there actually a file by that name?
		{
			cout << endl;
			cout << "Not a valid file name" << endl;
			continue;
		}
		
		fcloseASM(fptr);
		cout << endl;
		break;
	}

	while (1)	//Get the user's password
	{
		cout << "Enter a Password: ";
		getline(cin, line);
		if (!cin)
		{
			cout << "Error readling input" << endl;
			continue;
		}
		if (line == "")
		{
			return 0;
		}
		cout << endl;
		break;
	}
	
	//Open file and read it in
	const char * cstrFilename = filename.c_str();
	FILE * fptr = fopenASM(cstrFilename, "r");
	if (!fptr)
	{
		cout << "Error Reading File" << endl;
		return 1;
	}
	readFromText(fptr);
	std::cout << "File Read" << std::endl;
	std::cout << std::endl;
	fcloseASM(fptr); 

	//What did the user want to do?
	if (encryptSelected)
	{
		encrypt(castPasswordToInt(line));
	}
	else
	{
		decrypt(castPasswordToInt(line));
	}
	
	//Write to output file
	FILE * fptrWrite = fopenASM("output.txt", "w");
	if (!fptrWrite)
	{
		cout << "Error Writing File" << endl;
		return 1;
	}
	writeToText(fptrWrite);
	fcloseASM(fptrWrite);

	std::cout << std::endl;
	std::cout << "Press ENTER to exit" << std::endl;
	while (std::cin.get() != '\n')

	return 0;
}