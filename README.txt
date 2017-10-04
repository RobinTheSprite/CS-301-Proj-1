~NASM I/O Madness by Mark Underwood~
This program, in its present state, can do a few different things:
	1. Open and close files,
	2. Print the first string written inside a text file,
	3. Take each byte from a binary file, convert it into a character, and print it to the screen.

In future, I would like to take the strings that are in the binary file and put them in the text file, and vice versa.
Dealing with the binary file is easy, but figuring out how to move the file pointer to grab the next string from the 
text file is a little more of a challenge. There is a lot of unused code hanging out in the function that reads from
the text file right now because of that.