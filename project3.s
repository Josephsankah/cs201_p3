.data
	input_str: .space 1001			# -> label for user input
	error_msg: .asciiz "X"				# -> For_Invalid message
	comma_char: .asciiz ","               # -> comma string
	opening_char: .asciiz "("                # -> opening parenthesis
	closing_char: .asciiz ")"              # -> closing parenthesis

.text

                        # -> X: 03043145 (HU ID)
						# -> N: 26 + (X%11) = 26 + 6 = 32
						# -> M: 32 - 10 = 22
						# -> Hence, my code should accepts characters 0-9, A-V, and a-v

main:
	li $v0, 8                       # -> system code for taking in the user's input (string_char)
	la $a0, input_str                # -> load address of user's input in $a0
	li $a1, 1001                     # -> restrict the user's input size to 1000 characters
	syscall                          # -> invokes the system to execute the input process
	
	la $t1, ($a0)                    # -> load the base address of user's input into $t1
	addi $sp, $sp, -4                # -> reserve 4 bytes of storage in the run time stack
	sw $t1, ($sp)                    # -> save/push the value of $t1 into the first byte address on top of the running stack
	jal sub_a                        # ->  jump and link to sub_a, to process the whole input string

Exit:	li $v0, 10                    # -> setup to exit the program
	syscall                           # -> system call to exit

