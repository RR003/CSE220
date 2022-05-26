########### Rahul Raja ############
########### rahraja ################
########### 113126572 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl substr
substr:
	addi $sp,$sp, -4 ## using only 1 preserved var ($s0)
	sw $s0, 0($sp) ## storing $s0 in stack
	
	## checking length of string
	li $t0, 0 ## t0 is length of string
	move $s0, $a0
	length_of_string:
		lb $t1, 0($s0)
		beq $t1, $zero, substr_cont
		addi $t0, $t0, 1
		addi $s0, $s0, 1
		j length_of_string
		
	substr_cont:
		slt $t1, $a1, $zero ## if argument 1 is less than 0, it should be 1
		bne $t1, $zero, invalid_arg_substring
		
		sgt $t1, $a2, $t0 ## if arg 2 is greater than length, it should be 1
		bne $t1, $zero, invalid_arg_substring
		
		move $s0, $a0
		## at this point, arguments are right
		add $a0, $a0, $a1		
	for_loop_substring:
		beq $a1, $a2, end_of_substring
		lb $t1 0($a0)
		sb $t1 0($s0)
		
		addi $a0, $a0, 1
		addi $s0, $s0, 1
		addi $a1, $a1, 1
		j for_loop_substring
		
	end_of_substring:
		sb $zero 0($s0)
		move $v0, $s0
		li $v0, 0
		
		## restoring stack space
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra	
		
		
	invalid_arg_substring:
		li $v0, -1
		
		## restoring stack space
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra	

.globl encrypt_block
encrypt_block: 	
	li $t0, 0
	
	lb $t1, 0($a0)
	lb $t2, 0($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 24
	add $t0, $t0, $t1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	
	lb $t1, 0($a0)
	lb $t2, 0($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 16
	add $t0, $t0, $t1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	
	lb $t1, 0($a0)
	lb $t2, 0($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 8
	add $t0, $t0, $t1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	
	lb $t1, 0($a0)
	lb $t2, 0($a1)
	xor $t1, $t1, $t2
	add $t0, $t0, $t1
	
	move $v0, $t0
	jr $ra





.globl add_block
add_block:
	addi $sp,$sp, -4 ## using only 1 preserved var ($s0)
	sw $s3, 0($sp) ## storing $s0 in stack


	move $s3, $a0
	li $t0, 4
	mult $t0, $a1
	mflo $t5
	add $s3, $s3, $t5
		
	move $t0, $a2 ## load big number in t0
	andi $t1, $t0, 255 ## and operation, store in t1
	
	## checking if first number is a 1
	srl $t2, $t1, 7 
	beq $t2, $zero, continue_add_block1
	
	manip_first:
		andi $t1, $t1, 127
		addi $t1, $t1, -128 ## t1 is negative signed now

continue_add_block1:		
	sb $t1, 0($s3)
	
	
	srl $t0, $t0, 8
	andi $t1, $t0, 255 ## and operation, store in t1
	
	## checking if first number is a 1
	srl $t2, $t1, 7 
	beq $t2, $zero, continue_add_block2
	
	manip_second:
		andi $t1, $t1, 127
		addi $t1, $t1, -128 ## t1 is negative signed now

continue_add_block2:		
	sb $t1, 1($s3)
	

	srl $t0, $t0, 8
	andi $t1, $t0, 255 ## and operation, store in t1
	
	## checking if first number is a 1
	srl $t2, $t1, 7 
	beq $t2, $zero, continue_add_block3
	
	manip_third:
		andi $t1, $t1, 127
		addi $t1, $t1, -128 ## t1 is negative signed now

continue_add_block3:		
	sb $t1, 2($s3)
	
	srl $t0, $t0, 8
	andi $t1, $t0, 255 ## and operation, store in t1
	
	## checking if first number is a 1
	srl $t2, $t1, 7 
	beq $t2, $zero, continue_add_block4
	
	manip_fourth:
		andi $t1, $t1, 127
		addi $t1, $t1, -128 ## t1 is negative signed now

continue_add_block4:		
	sb $t1, 3($s3)
	

	## restoring stack space
	
	lw $s3, 0($sp)
	addi $sp, $sp, 4
 	jr $ra

.globl gen_key
gen_key:
	addi $sp,$sp, -4 ## using only 1 preserved var ($s0)
	sw $s2, 0($sp) ## storing $s0 in stack
	
	move $s2, $a0
	li $t0, 4
	mult $t0, $a1
	mflo $t0
	add $s2, $s2, $t0
	
	li $a1, 127
	li $v0, 42
	syscall
	move $t1, $a0
	sb $t1 0($s2)
	

	syscall
	move $t1, $a0
	sb $t1 1($s2)
	

	syscall
	move $t1, $a0
	sb $t1 2($s2)
	

	syscall
	move $t1, $a0
	sb $t1 3($s2)
	
	## restoring stack space
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	
 	jr $ra


.globl encrypt
encrypt:
	addi $sp,$sp, -4 ## using only 1 preserved var ($s4)
	sw $s4, 0($sp)
		
	move $t0, $a0 ## t0 is now mainString
	move $t3, $a1
	move $s4, $a2
	
	li $t1, 0 ## t1 is iterator
	li $t2, 4
	move $t5, $a3
	
	for_loop_while:
	
		div $a3, $t2
		mfhi $t4
		beq $t4, $zero, quit_while
	
		li $a1, 127
		li $v0, 42
		syscall
		move $t6, $t0
		add $t6, $t6, $t5
		sb $a0, 0($t6)
		sub $t6, $t6, $t5
		move $t0, $t6
		addi $a3, $a3, 1
		j for_loop_while
		
quit_while:
	mflo $t2 ## number of complete iterations in $t2
	li $t9, 4
	mult $t9, $t2
	mflo $t2
	
	for_loop_encrypt:
		beq $t1, $t2, more_encrypt
		
		## getting substring
		
		
		
		## generating key
		
		li $a1, 127
		li $v0, 42
		syscall
		move $t6, $a0
		sb $t6 0($t3)
		
		syscall
		move $t6, $a0
		sb $t6 1($t3)
		
		syscall
		move $t6, $a0
		sb $t6 2($t3)
		
		syscall
		move $t6, $a0
		sb $t6 3($t3)
		
		
		
		
		
		#move $a0, $t3 ## arg 1 
		li $t9, 4
		div $t1, $t9
		mflo $t9
		#move $a1, $t9  ## arg 2
		
		
		
		
		
		addi $sp, $sp, -16
		sw $ra, 12($sp)
		sw $t0, 8($sp)
		sw $t1, 4($sp)
		sw $t2, 0($sp)
		
		
		## encrpyting block
		move $a0, $t3
		move $a1, $t0
				
		
		jal encrypt_block 
		
		

		lw $t2, 0($sp)
		lw $t1, 4($sp)
		lw $t0, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, -16
		
		move $t5, $v0
		
		
		
		
		addi $sp, $sp, -16
		sw $ra, 12($sp)
		sw $t0, 8($sp)
		sw $t1, 4($sp)
		sw $t2, 0($sp)
		
		move $a0, $s4
		move $a1, $t9
		move $a2, $t5
	
		jal add_block
		
		lw $t2, 0($sp)
		lw $t1, 4($sp)
		lw $t0, 8($sp)
		lw $ra, 12($sp)

		addi $sp, $sp, 16
		
		
		addi $t1, $t1, 4
		addi $t3, $t3, 4
		addi $t0, $t0, 4
		j for_loop_encrypt
				
more_encrypt:
	## maybe you do not use that function, but u must implement it :)
	## need to work on edge case if not multiple of 4, but work on it later
	

## restoring stack space
lw $s4, 0($sp)
addi $sp,$sp, 4 ## using only 1 preserved var ($s0)	
	
jr $ra



.globl decrypt_block
decrypt_block:

li $t0, 0
	
	lb $t1, 0($a0)
	lb $t2, 3($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 24
	add $t0, $t0, $t1

	
	lb $t1, 1($a0)
	lb $t2, 2($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 16
	add $t0, $t0, $t1

	
	lb $t1, 2($a0)
	lb $t2, 1($a1)
	xor $t1, $t1, $t2
	sll $t1, $t1, 8
	add $t0, $t0, $t1

	
	lb $t1, 3($a0)
	lb $t2, 0($a1)
	xor $t1, $t1, $t2
	add $t0, $t0, $t1
	
	move $v0, $t0
	jr $ra
	

.globl decrypt
decrypt:
	addi $sp,$sp, -4 ## using only 1 preserved var ($s4)
	sw $s6, 0($sp)
	
	move $t0, $a0 ## ciphertext
	move $t1, $a1 ## key
	
	li $t2, 4
	div $a2, $t2
	mflo $t2 ## number of iterations
	
	li $t3, 0 ## iteratr
	move $s6, $a3
	
	for_loop_decryptor:
		beq $t3, $t2, break_out_decrypt		
		
		## using reg t0,t1,t2,t3, ra
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		sw $t3, 12($sp)
		sw $t2, 8($sp)
		sw $t1, 4($sp)
		sw $t0, 0($sp)
		
		move $a0, $t0
		move $a1, $t1
		jal decrypt_block ## result stored in v0
		
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		
		li $t4, 4
		mult $t4, $t3
		mflo $t4
		
		add $s6, $s6, $t4
		sw $v0, 0($s6)
		sub $s6, $s6, $t4
	
	
		addi $t3, $t3, 1
		addi $t0, $t0, 4
		addi $t1, $t1, 4
		
		j for_loop_decryptor

break_out_decrypt:
lw $s6, 0($sp)
addi $sp, $sp, 4	
 jr $ra
 
 
