~NASM I/O Madness by Mark Underwood~

This program can encrypt or decrypt open files (.txt or .bin) and write the modified version back to the disk.
Its operation goes something like this:

	-Friendly prompts ask you whether you wish to encrypt or decrypt, the name of 
	 the file you want to operate on, and a password. Pressing "enter" with an empty line  
	 at any of these prompts closes the program.

	-When a file is opened and read, it writes the data inside to a buffer in memory.

	-Once the file is in memory, it is encrypted or decrypted with the user's password.
	 It is important to note that choosing to decrypt a file that is already in plaintext
	 will result in encrypted text. It is up to user disgression to remember this.

	-Finally, the encrypted or decrypted text is written to a separate file called 
	 output.txt. The code could be modified to write back to the same file that was
	 read from, but I have written it this way so that the file that is read into memory
	 remains either plaintext or ciphertext.

For your convenience, I have included the files strings.txt and strings_in_disguise.bin as
plaintext files, and encrypted.txt and .bin as encrypted files using "qw" as a password. Feel
Free to write your own files and experiment.