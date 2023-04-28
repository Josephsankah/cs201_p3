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


