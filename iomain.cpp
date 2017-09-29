
#include <iostream>
#include <stdio.h>
#include <string.h>
extern "C" int bar(const char * filename, const char * mode);

int main()
{
	bar("test.txt", "r");

	while (std::cin.get() != '\n')

	return 0;
}