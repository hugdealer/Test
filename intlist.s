# -----------------------------------------------------------------------------
# A 64-bit Linux application that reads and prints list of n integers
# The input value n is to be read from the keyboard.
# Functions called : puts, scanf, printf
# This routine needs to be linked with C library functions
# To create object file using GNU assembler as
#	$as -gstabs intlist.s -o intlist.o
# To create an executable file after linking
#	$ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 intlist.o -o intlist -lc
# Execute the code listint generated using the following command :
#	$ ./intlist
# -----------------------------------------------------------------------------
	.global _start
# Data Declaration Section
		.data
		n:		.quad 0
		listn:		.space 800
		format1:	.asciz "ENTER LIST OF n=%ld NUMBERS\n"		# asciz puts a 0 byte at the end
		format2:	.asciz "THE GIVEN LIST OF n=%ld NUMBERS\n"
		message:	.asciz "ENTER A VALUE FOR n :"
		f1:		.string "%ld"
		f2:		.string "%ld\n"

# Program Text (code) section
		.text
_start:
		# put message by calling puts
		movq $message, %rdi 	#First message address (or pointer) parameter in %rdi
		call puts		# puts(message)
		
		# read n, number of integers
		movq $0, %rax
		movq $f1, %rdi		# put scanf 1st parameter (format f1) in %rdi
		movq $n, %rsi		# put scanf 2nd parameter - pointer to location n in %rsi,
		call scanf		# scanf(f, pointer n)

		# print message by calling printf
		movq n, %rax
		pushq %rcx		# caller-save register
		movq $format1, %rdi	# put printf 1st parameter (format1) in %rdi
		movq %rax, %rsi 	#put printf 2nd parameter ( n ) in %rsi, n is the value to be printed
		xorq %rax, %rax
		call printf		# printf(format1, n)
		popq %rcx		# restore caller-save register

		#Read list elements from Keyboard by calling scanf
		movq $listn, %rdx
		movq n, %rcx
up:		
		pushq %rdx
		pushq %rcx
		pushq %rbp
		movq $0, %rax
		movq $f1, %rdi		# put scanf 1st parameter (format f1) in %rdi
		movq %rdx, %rsi		# put scanf 2nd parameter - pointer to list element location in %rsi
		call scanf		# scanf(f1, pointer to list element)

		popq %rbp
		popq %rcx
		popq %rdx
		addq $8, %rdx
		decq %rcx
		jne up
		
	# Print message by calling printf
		movq n, %rax
		pushq %rcx		# caller-save register
		movq $format2, %rdi	# put printf 1st parameter (format2) in %rdi
		movq %rax, % rsi	# put printf 2nd parameter ( n ) in %rsi, n is the value to be printed
		xorq %rax, %rax
		call printf		# printf(format2, n)
		popq %rcx		# restore caller-save register

	# Print list of n elements read from keyboard
		movq $listn, %rdx
		movq n, %rcx
up1:
		pushq %rdx
		pushq %rcx
		pushq %rbp
		movq $0, %rax
		movq $f2, %rdi		# put printf 1st parameter (format f2) in %rdi
		movq (%rdx), %rsi	# put printf 2nd parameter - list element value in %rsi
		call printf		# printf(f2, list element value)
		popq %rbp
		popq %rcx
		popq %rdx
		addq $8, %rdx
		decq %rcx
		jne up1

		movq $60, %rax		# syscall to return 0
		xorq %rdi, %rdi
		syscall
