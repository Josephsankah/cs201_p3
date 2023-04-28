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

sub_a:	            
	la $t6, ($ra)                    # -> load the address of the $ra into $t6               
	lw $t1, ($sp)                    # -> load word, the first 4 byte from the sp pointer into $t1
	addi $sp, $sp, 4                 # -> moves stack pointer back to former address after freeing the reserved space used
	
	Loop:
	li $t7, 0                        # -> set up $t7 with value 0
	addi $sp, $sp, -8                # -> reserve 8 bytes of storage in the runtime stack
	sw $t1, ($sp)                    # -> save word in $t1 into the address where the stack pointer is currently at

	LoopSub:
	lb $t7, ($t1)                           # -> load byte the first byte from $t1 into $t7
	beq $t7, 44, Send_to_sub_b              # -> branch to "Send_to_sub_b" if value in $t7 == 44
	beq $t7, 10, Send_to_sub_b              # -> branch to "Send_to_sub_b" if vallue in $t7 == 10
	beq $t7, 0, Send_to_sub_b               # -> branch to "Send_to_sub_b" if value in $t7 == 0
	addi $t1, $t1, 1                        # -> otherwise increment $t1 by 1
	j LoopSub                               # -> and jump to LoopSub

	Send_to_sub_b:                      
	sw $t1, 4($sp)                          # -> save the word in $t1 into the runtime stack for 4 bytes offset
	
	jal sub_b                               # -> jump and link to sub_b
	
	lw $t8, ($sp)                           # -> load word from the address of the current stack pointer into $t8
	beq $t8, -1, print_error_msg            # -> branch to "print_error_msg" if val of $t8 == -1

