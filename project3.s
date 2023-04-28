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
	j print_val                              # -> jump to print_val
	
	print_error_msg:                             
	li $v0, 4                               # -> setup to print a string char
	la $a0, error_msg                           # -> load the error_msg string
	syscall                                 # -> invoke a system call for action
	j checking_pos                      # -> jump to "checking_pos"
	
	print_val:                               
	li $v0, 1                               # -> set up to print an integer
	addi $a0, $t8, 0                        # -> store val in $t8 into $a0
	syscall                                 # -> invokes the system call to execute
	
	li $v0, 4                               # -> set up to print a string char
	la $a0, opening_char                            # -> load the opening parenthesis char
	syscall                                 # -> make a system call
	
	li $v0, 1                               # -> set up to print an integer
	addi $a0, $t5, 0                        # -> store val in $t5 into $a0
	syscall                                 # -> make a system call
	
	li $v0, 4                               # -> set up to print a string char
	la $a0, closing_char                          # -> load the closing parenthesis char
	syscall                                 # -> make a system call
	
	j checking_pos                      # -> jump to "checking_pos"
	
	checking_pos:
	lw $t9, 4($sp)                          # -> load word from the 4th offset from the current stack pointer into $t9
	addi $sp, $sp, 8                        # -> free up 8 bytes of storage from the running stack
	lb $t7, ($t9)                           # -> load byte from $t9 into $t7
	beq $t7, 10, end                        # -> branch to "end" if val in $t7 == 10
	beq $t7, 0, end                         # -> ...else if val in $t7 == 0
	beq $t7, 44, next_substr                    # -> Else if val in $t7 == 44, branch to next_substr 
	
	next_substr:
	la $t1, ($t9)                           # -> load address of $t9 into $t1
	addi $t1, $t1, 1                        # -> increment the val in $t1 by 1

	
	li $v0, 4                               # -> set up to print a string char
	la $a0, comma_char                           # -> load the comma string into into $a0
	syscall                                 # -> make a system call
	
	j Loop                                  # -> jump to Loop
	
	end:
	la $ra, 0($t6)                          # -> load the return address into $ra
	jr $ra                                  # -> jump to return address

sub_b:	
	li $t5, 0                               # -> initialize the vals of $t5, $t3 and $t8 to 0
	li $t3, 0
	li $t8, 0
	
	lw $t2, ($sp)                           # -> load word on top of the running stack into $t2
	lw $t9, 4($sp)                          # -> load word in the address 4 bytes (from top to bottom of the running stack) into $t9
	lb $t0, ($t9)                           # -> load byte from $t9 into $t0
	addi $sp, $sp, 8                        # -> free up 8 bytes of space used in the running stack
	
	LoopLeading:
	lb $t4, ($t2)                           # -> load byte from $t2 into $t4
	beq $t4, $t0, For_Valid                     # -> branch to "For_Valid" if val in $t4 == val in $t0
	bne $t4, 32, TabL                       # -> branch to "TabL" if val in $t4 is not equal to 32
	j SkipL                                 # -> jump to SkipL
	
	TabL:	bne $t4, 9, Loop_Main            # -> branch to "Loop_Main" if val in $t4 not equal to 9
	SkipL:	addi $t2, $t2, 1                # -> increment $t2 by 1
	j LoopLeading                           # -> jump to "LoopLeading"
	
	Loop_Main:
	lb $t4, ($t2)                           # -> load byte from $t2 into $t4 
	bgt $t5, 4, For_Invalid                     # -> branch to "For_Invalid" val in $t5 greater than 4
	beq $t4, $t0, For_Valid                     # -> branch to "For_Valid" if val in $t4 == val in $t0
	beq $t4, 32, Loop_Trailing               # -> branch to "Loop_Trailing" if val in $t4 == 32
	beq $t4, 9, Loop_Trailing                # -> branch to $t4 if val in $t4 == 9
	
	number:	bgt $t4, 57, upper_case		
		blt $t4, 48, For_Invalid		
		li $t3, -48			                  # -> make $t3 -48 for conversion to decimal
		j calculations		                  # -> jump to calculate and update $t8
		
	upper_case:	bgt $t4, 86, lower_case		          # -> check if character in A-V
		blt $t4, 65, For_Invalid		          # -> print For_Invalid if not A-v
		li $t3, -55			                  # -> make $t3 -55 for conversion to decimal
		j calculations			              # -> jump to calculate and update $t8
		
	lower_case:	bgt $t4, 118, For_Invalid		      # -> check if character in a-v
		blt $t4, 97, For_Invalid		          # -> print For_Invalid if not a-v
		li $t3, -87			                  # -> make $t3 -87 for conversion to decimal
	
	calculations:
		add $t3, $t4, $t3		              # -> convert the character to its decimal value
		add $t8, $t8, $t3		              # -> add that value to $t8 in every iteration
		mul $t8, $t8, 32		              # -> multiply $t8 with 32 in every iteration
	
	move_to_next:	addi $t2, $t2, 1		          # -> go to the next byte address
		addi $t5, $t5, 1		              # -> increase input length counter by 1
		j Loop_Main			                  # -> loop again
	
	Loop_Trailing:
	lb $t4, ($t2)				              # -> loading the subsequent bit to $t4
	beq $t4, $t0, For_Valid			          # -> branch to For_valid if val in $t4 == val in $t0
	bne $t4, 32, TabT			              # -> check if a trailing space found
	j SkipT					                  # -> continue loop
	
	TabT:	bne $t4, 9, For_Invalid		          # -> check if a trailing tab found
	
	SkipT:	addi $t2, $t2, 1		          # -> go to the next byte address
		j Loop_Trailing			              # -> loop again
	



