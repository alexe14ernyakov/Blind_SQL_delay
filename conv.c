#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
	if(argc != 2) printf("Invalid format\n");
	else{
		char* arg = argv[1];
		char* output;
		long result = strtol(arg, &output, 10);
		printf("%c\n", (unsigned int)result);
	}

	return 0;
}
