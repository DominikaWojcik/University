/* Jarosław Dzikowski 273233

	Czwarte zadanko
	
	
*/
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <execinfo.h>
#include <ucontext.h>
#define BUF_SIZE 128
#define STACK_POINTER 15
#define INSTRUCTION_POINTER 16

char* errorMsg = "Dostepne parametry:\n\ta - odczyt z niezmapowanej pamięci\n\tb - zapis do pamięci tylko do odczytu";

void itoa(long unsigned int i, char* buffer, size_t size)
{
	unsigned int index = 0;
	while(i>0 && index < size)
	{
		buffer[index++] = i%10 + '0';
		i /= 10;
	}

	if(index == 0 && index < size)
		buffer[index++] = '0';

	buffer[index] = 0;

	//Teraz sobie zamienie miejscami literki
	--index;
	for(unsigned int i=0; i <= index/2; i++)
	{
		char tmp = buffer[i];
		buffer[i] = buffer[index-i];
		buffer[index-i] = tmp;
	}
}

void handleSigsegv(int sig, siginfo_t* info, void* oldContext)
{
	// rejestr nr 16 - RIP - next instruction pointer
	// kod może być 1 - SEGV_MAPERR - Address not mapped to object.
	// lub 2 - SEGV_ACCERR - Invalid permissions for mapped object.

	ucontext_t context = *((ucontext_t*) oldContext);
	long unsigned int memoryAddress = (long unsigned int)info->si_addr;
	int errorType = info->si_code;
	long long int stackTop = context.uc_mcontext.gregs[STACK_POINTER];
	long long int instructionAddress = context.uc_mcontext.gregs[INSTRUCTION_POINTER];
	//Wypisujemy info
	/*
	printf("pid %d\n", info->si_pid);
	printf("si addr %p\n", info->si_addr);
	printf("si signo %d\nsi code %d\n",info->si_signo, info->si_code);
	printf("stack pointer %lld\n", context.uc_mcontext.gregs[STACK_POINTER]);
	printf("instruction address %lld\n",context.uc_mcontext.gregs[INSTRUCTION_POINTER]);
	*/


	char buf[BUF_SIZE] = "\nInformacje: \n";
	write(STDERR_FILENO, buf, strlen(buf));

	strcpy(buf, "Adres pamieci wywolujacy blad: ");
	write(STDERR_FILENO, buf, strlen(buf));
	itoa(memoryAddress, buf, BUF_SIZE);
	write(STDERR_FILENO, buf, strlen(buf));

	strcpy(buf, "\nKod bledu: ");
	write(STDERR_FILENO, buf, strlen(buf));
	itoa(errorType, buf, BUF_SIZE);
	write(STDERR_FILENO, buf, strlen(buf));

	strcpy(buf, "\nAdres wierzcholka stosu: ");
	write(STDERR_FILENO, buf, strlen(buf));
	itoa(stackTop, buf, BUF_SIZE);
	write(STDERR_FILENO, buf, strlen(buf));

	strcpy(buf, "\nAdres instrukcji powodujacej blad: ");
	write(STDERR_FILENO, buf, strlen(buf));
	itoa(instructionAddress, buf, BUF_SIZE);
	write(STDERR_FILENO, buf, strlen(buf));

	strcpy(buf, "\n");
	write(STDERR_FILENO, buf, strlen(buf));

	//Slad programu
	strcpy(buf, "\nBacktrace (return adresy): ");
	write(STDERR_FILENO, buf, strlen(buf));

	void *addressBuffer[BUF_SIZE];
	int howMany = backtrace(addressBuffer, BUF_SIZE);
	for(int i=0; i < howMany; ++i)
	{
		strcpy(buf, "\n");
		write(STDERR_FILENO, buf, strlen(buf));
		itoa((unsigned long int)addressBuffer[i], buf, BUF_SIZE);
		write(STDERR_FILENO, buf, strlen(buf));
	}

	strcpy(buf, "\n");
	write(STDERR_FILENO, buf, strlen(buf));

	// Po ludzku napisane
	/*
	char **names = backtrace_symbols(addressBuffer, howMany);
	for(int i=0;i<howMany;i++)
	{
		fprintf(stderr, "%s\n", names[i]);
	}
	free(names);
	*/

	//Konczymy dzialanie
	_exit(128 + SIGSEGV);
}

int main(int argc, char* argv[])
{
	if(argc != 2)
	{
		printf("%s\n", errorMsg);
		return 1;
	}
		
	//sa_handler jest domyslnie i bierze tylko inta
	//sa_sigaction bierze inta, i dwa argumenty: 
	//	siginfo (duzo informacji)
	//	wskaznik na ucontext - informacje o przelaczaniu kontekstu
	//		stos, maska sygnalow
	struct sigaction sigsegvAction;
	sigsegvAction.sa_sigaction = handleSigsegv;
	sigsegvAction.sa_flags |= SA_SIGINFO;
	sigaction(SIGSEGV, &sigsegvAction, NULL);

	if(argv[1][0] == 'a')
	{
		printf("Dostep do niezmapowanej pamieci\n");
		char ch = argv[argc][0];
	}
	else if(argv[1][0] == 'b')
	{
		printf("Zapis do pamieci read only\n");
		char* pointerToText;
		pointerToText = (void*)0x400004; // gdzieś w .text sie wstrzelam
		*pointerToText = 'a'; // error
	}


	return 0;
}

