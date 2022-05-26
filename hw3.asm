######### Rahul Raja ##########
######### 113126572 ##########
######### rahraja ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
		
	move $t0, $a0 ## set contents of a0 to t0
	move $t9, $a1 ## set contents of a1 to t1
	
	
	li $a1, 0 ## going to be reading a file
	li $v0, 13
	syscall	
		
	slt $t2,$v0, $zero ## must be greater than or equal to 0
	bne $t2, $zero, not_valid_path
	
	
	## if valid
	move $a0, $v0
	move $a1, $t9
	li $a2, 1 ## first read the first argument for the total number of values in matrix
	li $v0, 14 ## reading file
	syscall	
	lbu $t2, 0($a1)
	addi $t2, $t2, -48
	sb $t2, 0($a1)
	
	## check if its between 1-9
	li $t6, 1
	slt $t7, $t2, $t6 ## should be zero if valid
	bne $t7, $zero, not_valid_path
			
	li $t6, 10
	slt, $t7, $t2, $t6 ## should be 1 if valid
	beq $t7, $zero, not_valid_path

	
	## end of line must be new line
	addi $a1, $a1, 4
	li $v0, 14 ## reading file
	syscall	
	lbu $t0, 0($a1)
	
	li $t6, 13
	bne $t0, $t6, part1_next1
	addi $a1, $a1, 4
	li $v0, 14 ## reading file
	syscall	
	lbu $t0, 0($a1)

part1_next1:	
	li $t6, 10
	bne $t0, $t6, not_valid_path
	
	
	
	
	## getting next arg
	li $v0, 14 ## reading file
	syscall	
	lbu $t3, 0($a1)
	addi $t3, $t3, -48
	sb $t3, 0($a1)
	
	## check if its between 1-9
	li $t6, 1
	slt $t7, $t3, $t6 ## should be zero if valid
	bne $t7, $zero, not_valid_path
			
	li $t6, 10
	slt, $t7, $t3, $t6 ## should be 1 if valid
	beq $t7, $zero, not_valid_path
	
	## end of second arg must be new line
	addi $a1, $a1, 4
	li $v0, 14 ## reading file
	syscall	
	lbu $t0, 0($a1)
	
	li $t6, 13
	bne $t0, $t6, part1_next2
	addi $a1, $a1, 4
	li $v0, 14 ## reading file
	syscall	
	lbu $t0, 0($a1)

part1_next2:
	li $t6, 10	
	bne $t0, $t6, not_valid_path
	

	
	li $t4, 0
	li $t5, 0
	
	row_loop_part1:
		beq $t2, $t4, part1_continue
		
		li $t5, 0
		col_loop_part1:
			beq $t3, $t5, row_loop_cont
			li $v0, 14 ## reading file
			syscall
			
			lbu $t1, 0($a1)
			li $t6, 10
			beq $t1, $t6, not_valid_path
			addi $t1, $t1, -48
			
			## check if its between 0-9
			li $t6, 0
			slt $t7, $t1, $t6 ## should be zero if valid
			bne $t7, $zero, not_valid_path
			
			li $t6, 10
			slt, $t7, $t1, $t6 ## should be 1 if valid
			beq $t7, $zero, not_valid_path
			
			sb $t1, 0($a1)
			addi $a1, $a1, 4
			
			addi $t5, $t5, 1
			j col_loop_part1
	row_loop_cont:
		addi $t4, $t4, 1
		beq $t2, $t4, part1_continue
		
		li $v0, 14 ## reading file
		syscall
		li $t6, 10
		lbu $t1, 0($a1)
		
		li $t6, 13
		bne $t1, $t6, part1_next3
		addi $a1, $a1, 4
		li $v0, 14 ## reading file
		syscall	
		lbu $t1, 0($a1)

	part1_next3:
		li $t6, 10		
		bne $t1, $t6, not_valid_path	
		j row_loop_part1
		

part1_continue:
	mult $t2, $t3
	mflo $t2
	li $t3, -4
	mult $t2, $t3
	mflo $t2
	add $a1, $a1, $t2
	addi $a1, $a1, -8	
	j return_statement1
	
	
not_valid_path:
	move $a1, $t9
	li $t1, 0
	li $t2, 81
	## filling in zeros for the buffer
	fill_in_zeros:
		beq $t1, $t2, not_valid_path_cont
		sb $zero, 0($a1)
		addi $t1, $t1, 1
		addi $a1, $a1, 4
		j fill_in_zeros
		
not_valid_path_cont:	
	addi $a1, $a1, -324
	li $v0, -1	
	jr $ra

return_statement1:
	li $v0, 1	
	jr $ra
	
	



.globl write_file
write_file:
	
	move $t1, $a1
	## first need to open the file
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	
	li $a2, 1 ## reading one character
	move $a0, $v0 ## file descriptor
	move $a1, $t1
	
	lbu $t3, 0($a1) ## number of rows
	addi $t2, $t3, 48
	sb $t2, 0($a1)
	
	li $v0, 15
	syscall ## storing first character in file
	
	li $t2, 10
	sb $t2, 0($a1)
	li $v0, 15
	syscall ## storing next line character
	
	addi $a1, $a1, 4
	lbu $t4, 0($a1) ## number of columns
	addi $t2, $t4, 48
	sb $t2, 0($a1)
	li $v0, 15
	syscall ## storing second character in file
	
	addi $a1, $a1, 4
	
	li $t5, 0 ## row iterator
	
	row_loop_part_2:		
		beq $t5, $t3, part2_cont
		
		addi $a1, $a1, -4
		li $t2, 10
		sb $t2, 0($a1)
		li $v0, 15
		syscall ## storing next line character
		
		addi $a1, $a1, 4
		
		li $t6, 0 ## column iterator
		
		col_loop_part_2:
			beq $t6, $t4, row_loop_part_2_cont
			
			lbu $t2, 0($a1) ## number of columns
			addi $t2, $t2, 48
			sb $t2, 0($a1)
			li $v0, 15
			syscall ## storing second character in file
				
			addi $t6, $t6, 1
			addi $a1, $a1, 4
			
			j col_loop_part_2
	
	row_loop_part_2_cont:
		addi $t5, $t5, 1
		j row_loop_part_2	

	
part2_cont:	
	## closing file
	li $v0, 16
	syscall
	
	 jr $ra





.globl rotate_clkws_90
rotate_clkws_90:
	move $a2, $a0
	move $t0, $a0

	## start from end of t0 and work way to beg of buffer. This should then work
	
	lbu $t1, 0($a2) ## number of rows
	addi $a2, $a2, 4
	lbu $t2, 0($a2) ## number of columns
	
	
	li $t4, 0 ## col iterator
	
	addi $a2, $a2, 4
	
	row_loop_part3:
		beq $t4, $t2, part3_cont
		
		## moving pointer
		addi $t5, $t1, -1
		mult $t5, $t2
		mflo $t5
		li $t6, 4
		mult $t5, $t6
		mflo $t7
		add $a2, $a2, $t7
		
		li $t3, 0 ## row iterator
		
		col_loop_part3:
						
			lbu $t5, 0($a2)
			## sb $t5, 0($t0)
			
			## storing in stack
			
			addi $sp,$sp, -4 ## using only 1 preserved var ($s4)
			sw $t5, 0($sp)
						
			## printing out the integer
			## move $a0, $t5
			## li $v0, 1
			## syscall
			
			## addi $t0, $t0, 4 ## go to next element
			
			addi $t3, $t3, 1 ## add 1 to row iterator
			beq $t1, $t3, row_loop_part3_cont
			
			li $t6, -4
			mult $t2, $t6
			mflo $t7
			add $a2, $a2, $t7 ## next element
			
			j col_loop_part3
						
	row_loop_part3_cont:
		addi $t4, $t4, 1
		addi $a2, $a2, 4
		j row_loop_part3
		

part3_cont:
	mult $t1, $t2
	mflo $t3
	
	li $t4, 4
	mult $t3, $t4
	mflo $t4
		
	add $t0, $t0, $t4 ## going to the end of the array
	addi $t0, $t0, 4
	
	li $t4, 0
	
	add_to_buffer_3:
		beq $t4, $t3, part3_cont2
		
		lw $t5, 0($sp)
		addi $sp, $sp, 4
		
		## printing out the integer
		## move $a0, $t5
		## li $v0, 1
		## syscall
		
		sw $t5, 0($t0)
		addi $t0, $t0, -4
		addi $t4, $t4, 1
		j add_to_buffer_3
	
part3_cont2:
	addi $t0, $t0, -4
		
	sb $t1, 4($t0)
	sb $t2, 0($t0)
	
	
	move $a0, $a1
	move $a1, $t0
	
	addi $sp,$sp, -4 
	sw $ra, 0($sp)
	
	jal write_file
	
	lw $ra, 0($sp)
	addi $sp,$sp, 4
	
	
 	jr $ra
 	

.globl rotate_clkws_180
rotate_clkws_180:

	
	move $t0, $a0
	move $t9, $a0
	
	lbu $t1, 0($t0) ## number of rows
	lbu $t2, 4($t0) ## number of cols
	
	mult $t1, $t2
	mflo $t3 ## total
	li $t4, 4
	mult $t4, $t3
	mflo $t4 ## number of spaces to allocate
	
	li $t5, 0 ## iterator
	
	addi $t0, $t0, 4
	add $t0, $t0, $t4
	
	addi $t9, $t9, 4
	add $t9, $t9, $t4
	
	for_loop_part4:
		beq $t5, $t3, part4_cont
		
		lbu $t6, 0($t0)
		addi $sp, $sp, -4
		sw $t6, 0($sp)
		
		addi $t0, $t0, -4
		addi $t5, $t5, 1
		j for_loop_part4
	
part4_cont:
	li $t5, 0 ## another iterator
	
	part4_buffer_loop:
		beq $t5, $t3, part4_cont2
		
		lw $t6, 0($sp)
		addi $sp, $sp, 4
		
		sb $t6, 0($t9)
		
		addi $t5, $t5, 1
		addi $t9, $t9, -4
		
		j part4_buffer_loop
part4_cont2:
	addi $t9, $t9, -4
	
	addi $sp,$sp, -4 
	sw $ra, 0($sp)
	
	move $a0, $a1
	move $a1, $t9
	
	jal write_file
	
	lw $ra, 0($sp)
	addi $sp,$sp, 4
	
 	jr $ra

.globl rotate_clkws_270
rotate_clkws_270:

	move $t0, $a0
	move $t9, $a0
	
	lbu $t1, 0($t0) ## number of rows
	lbu $t2, 4($t0) ## number of cols
	
	mult $t1, $t2
	mflo $t3 ## total
	li $t4, 4
	mult $t4, $t3
	mflo $t4 ## number of spaces to allocate
	
	li $t5, 0 ## iterator
	
	addi $t0, $t0, 4
	add $t0, $t0, $t4
	
	addi $t9, $t9, 4
	add $t9, $t9, $t4
	
	for_loop_part5:
		beq $t5, $t3, part5_cont
		
		lbu $t6, 0($t0)
		addi $sp, $sp, -4
		sw $t6, 0($sp)
		
		addi $t0, $t0, -4
		addi $t5, $t5, 1
		j for_loop_part5
	
part5_cont:
	li $t5, 0 ## another iterator
	
	part5_buffer_loop:
		beq $t5, $t3, part5_cont2
		
		lw $t6, 0($sp)
		addi $sp, $sp, 4
		
		sb $t6, 0($t9)
		
		addi $t5, $t5, 1
		addi $t9, $t9, -4
		
		j part5_buffer_loop
part5_cont2:
	addi $t9, $t9, -4
	
	move $a0, $t9
	
	addi $sp,$sp, -4 
	sw $ra, 0($sp)
	
	jal rotate_clkws_90 ## result in file
	
	lw $ra, 0($sp)
	addi $sp,$sp, 4
	
 	jr $ra

.globl mirror
mirror:
	move $t0, $a0
	move $t9, $a0
	lbu $t1, 0($t0) ## rows
	lbu $t2, 4($t0) ## columns
	
	li $t3, 0 ## row iterator
	
	
	addi $t0, $t0, 8
	
	for_loop_part6:
		beq $t3, $t1, mirror_cont
		
		li $t5, 4
		addi $t6, $t2, -1
		mult $t6, $t5 ## number of spaces to add
		mflo $t6
		add $t0, $t0, $t6
		
		li $t4, 0 ## col iterator
		inner_loop6:
			beq $t4, $t2, for_loop_part6_cont
			
			lbu $t5, 0($t0)
			
			## printing out the integer
			#move $a0, $t5
			#li $v0, 1
			#syscall
			
			sw $t5, 0($sp)
			addi $sp, $sp, -4
						
			addi $t0, $t0, -4						
			addi $t4, $t4, 1
			j inner_loop6
			
	for_loop_part6_cont:
		addi $t0, $t0, 4
	
		li $t5, 4
		mult $t5, $t2
		mflo $t5
		add $t0, $t0, $t5
		addi $t3, $t3, 1
		j for_loop_part6
	
mirror_cont:
	mult $t1, $t2
	mflo $t3
	
	li $t4, 4
	mult $t3, $t4
	mflo $t4
		
	add $t9, $t9, $t4 ## going to the end of the array
	addi $t9, $t9, 4
	addi $t0, $t0, 4
	
	li $t4, 0
	
	add_to_buffer_6:
		beq $t4, $t3, mirror_cont2
		
		addi $sp, $sp, 4
		lw $t5, 0($sp)
		
		
		## printing out the integer
		#move $a0, $t5
		#li $v0, 1
		#syscall
		
		sw $t5, 0($t9)
		addi $t9, $t9, -4
		addi $t4, $t4, 1
		j add_to_buffer_6

mirror_cont2:	
	addi $t9, $t9, -4

	move $a0, $a1
	move $a1, $t9
	
							
	addi $sp,$sp, -4 
	sw $ra, 0($sp)
	
	jal write_file
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4																																										
																									
 	jr $ra
 	
 	

.globl duplicate
duplicate:

	lbu $t0, 0($a0)
	lbu $t1, 4($a0)
	
	li $v0, -1
	li $v1, 0
	
	addi $a0, $a0, 8
	
	li $t2, 0 ## row iterator
	li $t9, 4 
	
	for_loop_part7:
		beq $t2, $t0, part7_cont
		
		addi $t3, $t2, 1 ## inner_row iterator
		inner_for_loop_part7:
			beq $t3, $t0, for_loop_part7_cont
			
			## calculating number of spaces to move for the new row
			sub $t4, $t3, $t2 ## row diff
			mult $t1, $t4
			mflo $t4
			mult $t4, $t9
			mflo $t4
			
			## adding the number of spaces for the new row
			add $t8, $a0, $t4 ## new word @ $t8
						
			li $t4, 0 ## column iterator
			
			move $t7, $a0
			
			col_iterator_part7:
				beq $t4, $t1, update_result_part7
				lbu $t5, 0($t7)
				lbu $t6, 0($t8)
				
				bne $t5, $t6, inner_for_loop_part7_cont
				addi $t4, $t4, 1
				addi $t7, $t7, 4
				addi $t8, $t8, 4
				j col_iterator_part7
				
		update_result_part7:
			li $v0, 1
			li $t5, 0
			bne $v1, $t5, other_update
			
			addi $v1, $t3, 1 ## update new result in 1 
			
			j inner_for_loop_part7_cont
		other_update:
			addi $t5, $t3, 1 ## update new result in 1
			slt $t6, $t5, $v1 ## if less than v1, then it is 1
			li $t7, 1
			bne $t6, $t7, inner_for_loop_part7_cont
			
			move $v1, $t5
		
		inner_for_loop_part7_cont:
			addi $t3, $t3, 1
			j inner_for_loop_part7	
					
	for_loop_part7_cont:
		mult $t9, $t1
		mflo $t5
		add $a0, $a0, $t5
		addi $t2, $t2, 1
		j for_loop_part7
		
part7_cont:			
 	jr $ra
