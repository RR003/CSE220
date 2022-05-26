############## Rahul Raja ##############
############## 113126572 #################
############## rahraja ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:
	
	
	
	move $t0, $a0 ## storing arg in t0
	
	lbu $t1, 0($a0) ## max number of nodes in network
	lbu $t2, 16($a0) ## current number of nodes in network
	
	slt $t3, $t2, $t1 ## if valid, then result should be 1
	beq $t3, $zero, no_more_adding
	
	lbu $t1, 8($a0) ## size of node to store
	
	## finding current index to store 
	mult $t2, $t1 
	mflo $t3 ## index to search through
	
	addi $t0, $t0, 24
	add $t0, $t0, $t3
	
	li $t4, 0 ## iterator
	
	for_loop_part1:
		beq $t4, $t1, part1_cont
		sb $zero, 0($t0)
		addi $t0, $t0, 1
		addi $t4, $t4, 1
		j for_loop_part1
		
part1_cont:
	## going to the original part of setting to zero	
	li $t5, -1
	mult $t5, $t1
	mflo $t4
	add $t0, $t0, $t4 
	
	move $v0, $t0
	
	## going back to the original part of $t0
	mult $t5, $t3
	mflo $t3
	add $t0, $t0, $t3	
	addi $t0, $t0, -24
	move $a0, $t0 ## setting a0 to altered t0
	
	addi $t2, $t2, 1 ## adding 1 to the current node count
	sb $t2, 16($a0) 		
			
  	jr $ra
  	
no_more_adding:
	li $v0, -1
	jr $ra

.globl add_person_property
add_person_property:

## checking if a2 is equal to NAME
	lbu $t0, 0($a2)
	li $t1, 78
	bne $t0, $t1, not_valid_part2
	
	lbu $t0, 1($a2)
	li $t1, 65
	bne $t0, $t1, not_valid_part2
	
	lbu $t0, 2($a2)
	li $t1, 77
	bne $t0, $t1, not_valid_part2
	
	lbu $t0, 3($a2)
	li $t1, 69
	bne $t0, $t1, not_valid_part2
	
	## if here, then it passed NAME test
	
## checking if len(prop_value) <= Network.size_of_node
	lbu $t0, 8($a0) ## max size of node
	move $t2, $a3
	li $t1, 0
	while_loop_part2:
		lbu $t3, 0($t2)
		beq $t3, $zero, part2_cont
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		j while_loop_part2
		
part2_cont:
	sgt $t2, $t1, $t0 ## if valid, then should be 0
	bne $t2, $zero, not_valid_part2	
	
	move $t0, $a1
	
	addi $sp, $sp, -8
	sw $t0, 4($sp)
	sw $ra, 0($sp)
	
	## make call
	move $a1, $a3
	
	jal get_person ## $v0 should be 0 if there is 
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	
	move $a1, $t0
	
	bne $v0, $zero, not_valid_part2
	
## checking if person exists
	move $t0, $a0
	
	lbu $t1, 0($t0)	## max number of nodes
	lbu $t2, 8($t0) ## number of chars in node
	addi $t0, $t0, 24
	
	li $t3, 0
	
	for_loop_part2_3:
		beq $t3, $t1, not_valid_part2 ## went through all nodes, none were valid
		
		beq $t0, $a1, exit_loop
		
		add $t0, $t0, $t2
		addi $t3, $t3, 1
		
		j for_loop_part2_3

exit_loop: ## if reached here, then you can append the letters
	lbu $t7, 8($a0) ## length to change
	addi $a0, $a0, 24
	li $t4, 0
	for_loop_part2_4:
		beq $t4, $t3, exit_loop_cont
		add $a0, $a0, $t2
		addi $t4, $t4, 1
		j for_loop_part2_4
		
exit_loop_cont:
	li $t6, 0 ## iterator
	move $t8, $a3
	while_loop_part2_3:
		lbu $t5, 0($t8)
		beq $t5, $zero, while_loop_part2_4
		sb $t5, 0($a0)
		addi $a0, $a0, 1
		addi $t8, $t8, 1
		addi $t6, $t6, 1
		j while_loop_part2_3
	while_loop_part2_4:
		beq $t6, $t7 exit_loop_cont_2
		sb $zero, 0($a0)
		addi $a0, $a0, 1
		addi $t6, $t6, 1
		j while_loop_part2_4
		
exit_loop_cont_2:
	li $t7, -1
	mult $t6, $t7
	mflo $t6
	add $a0, $a0, $t6
	
	mult $t3, $t2
	mflo $t2
	mult $t2, $t7
	mflo $t2	
	
	add $a0, $a0, $t2	
	addi $a0, $a0, -24
		
	li $v0, 1	
	jr $ra
	
  
 not_valid_part2:
 	li $v0, 0
 	jr $ra	





.globl get_person
get_person:
	## checking if length is greater
	move $t0, $a0
	move $t1, $a1
	
	lbu $t2, 8($a0)
	move $t3, $a1
	li $t4, 0
	
	while_loop_part3:
		lbu $t5, 0($t3)
		beq $t5, $zero, part3_cont
		addi $t3, $t3, 1
		addi $t4,$t4, 1
		j while_loop_part3

part3_cont:
	sgt $t5, $t4, $t2 ## should be 0
	bne $t5, $zero, part3_cont_2

	lbu $t3, 8($a0) ## max length of the string
	lbu $t4, 0($a0) ## current number of nodes in network
	li $t5, 0 ## iterator
	
	addi $t0, $t0, 24
	inner_forloop_part3:	
		beq $t5, $t4, part3_cont_2 ## when you didnt find the string
		li $t6, 0
		outer_loop_part3:
			beq $t6, $t3, found_string ## if reached end, then it must be equal
			lbu $t7, 0($t0)
			lbu $t8, 0($t1)
			bne $t7, $t8, inner_forloop_part3_cont
			beq $t8, $zero, found_string ## reached end of string, therefore, you have found the string			
			
			
			addi $t0, $t0, 1
			addi $t1, $t1, 1
			addi $t6, $t6, 1
			j outer_loop_part3	
	inner_forloop_part3_cont:
		sub $t7, $t3, $t6
		add $t0, $t0, $t7
		move $t1, $a1
		
		addi $t5, $t5, 1
		j inner_forloop_part3
	
found_string:
	
	sub $t0, $t0, $t6
	move $v0, $t0	
	jr $ra
									
part3_cont_2:
	li $v0, 0										
  	jr $ra



.globl add_relation
add_relation:
## CHECKING IF THE TWO WORDS ARE IN THE NETWORK
	addi $sp,$sp, -4 ## using only 1 preserved var ($s0)
	sw $ra, 0($sp)
	
	jal get_person
	
	move $t8, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, $zero, invalid_part4
	
	move $t0, $a1
	move $a1, $a2
	
	addi $sp,$sp, -12
	sw $t8, 8($sp)
	sw $t0, 4($sp)
	sw $ra, 0($sp) 
	
	jal get_person
	
	move $t9, $v0
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t8, 8($sp)
	addi $sp, $sp, 12
	
	beq $v0, $zero, invalid_part4
	
	move $a2, $a1 ## prolly unnecesary but whatever
	move $a1, $t0

## CHECKING IF MAX NUMBER OF EDGES IS REACHED OR NOT
	lbu $t0, 4($a0)
	lbu $t1, 20($a0) ## t1 should be less than t0 for validity
	
	slt $t2, $t1, $t0 ## should be 1
	beq $t2, $zero, invalid_part4
	
## CHECKING IF NAME1 == NAME2
	move $t0, $a1
	move $t1, $a2
	
	while_loop_part4:
		lbu $t2, 0($t0)
		lbu $t3, 0($t1)
		
		beq $t2, $zero, could_be_same
		bne $t2, $t3, part4_cont
		
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j while_loop_part4

could_be_same:
	beq $t3, $zero, invalid_part4

part4_cont:

## CHECK IF RELATION BETWEEN NAME1 AND NAME2 EXIST
	lbu $t0, 0($a0)	
	lbu $t1, 8($a0)
	mult $t0, $t1
	mflo $t0
	addi $t1, $t0, 24
	
	move $t0, $a0
	add $t0, $t0, $t1 ## adding the offset to t0
	
	lbu $t1, 20($a0) ## current number of nodes
	
	li $t2, 0 ## iterator
	## t8 -> address for a1
	## t9 -> address for a2
	
	for_loop_part4:
		beq $t2, $t1, part4_cont2
		lw $t3, 0($t0)
		
		## check if t3 is equal to first arg
		while_loop_part4_2:
			beq $t8, $t3, while_loop_part4_3
			j for_loop_4_cont	
			## lbu $t6, 0($t4)
			## lbu $t7, 0($t3)
		
			## beq $t6, $zero, could_be_same2 
			## bne $t6, $t7, for_loop_4_cont ## if not equal check other case
		
			## addi $t4, $t4, 1
			## addi $t3, $t3, 1
			## j while_loop_part4_2
			
		## could_be_same2:
			## lw $t3, 4($t0)
			## move $t5, $a2
			## beq $t7, $zero, while_loop_part4_3
			## j for_loop_4_cont
			
		while_loop_part4_3: ## only here if first arg matches,
			lw $t3, 4($t0)
			beq $t9, $t3, invalid_part4
		
			## beq $t6, $zero, could_be_same3 
			## bne $t6, $t7, for_loop_4_cont ## if not equal check other case
		
			## addi $t5, $t5, 1
			## addi $t3, $t3, 1
			## j while_loop_part4_3
			
		## could_be_same3:
			## beq $t7, $zero, invalid_part4 ## invalid part
			
			
	for_loop_4_cont:	
		lw $t3, 4($t0)
		
		
		while_loop_part4_4:
			beq $t3, $t8, while_loop_part4_5
			j for_loop_4_cont2
			## lbu $t6, 0($t4)
			## lbu $t7, 0($t3)
		
			## beq $t6, $zero, could_be_same4 
			## bne $t6, $t7, for_loop_4_cont2 ## if not equal check other case
		
			## addi $t4, $t4, 1
			## addi $t3, $t3, 1
			## j while_loop_part4_4
			
		## could_be_same4:
			## lw $t3, 0($t0)
			## move $t5, $a2
			## beq $t7, $zero, while_loop_part4_5
			## j for_loop_4_cont
			
		while_loop_part4_5: ## only here if first arg matches,
			lw $t3, 0($t0)
			beq $t3, $t9, invalid_part4
			## lbu $t6, 0($t5)
			## lbu $t7, 0($t3)
		
			## beq $t6, $zero, could_be_same5 
			## bne $t6, $t7, for_loop_4_cont2 ## if not equal check other case
		
			## addi $t5, $t5, 1
			## addi $t3, $t3, 1
			## j while_loop_part4_5
			
		## could_be_same5:
			## beq $t7, $zero, invalid_part4 ## invalid part
		
		
	for_loop_4_cont2:
		addi $t0, $t0, 12
		move $t4, $a1
		move $t5, $a2
		addi $t2, $t2, 1
		j for_loop_part4
		
	
	


part4_cont2:
	move $t0, $a0
	lbu $t1, 0($a0) ## max # of nodes
	lbu $t2, 8($a0)
	mult $t1, $t2
	mflo $t1 ## offset for ndoes
	
	addi $t0, $t0, 24
	add $t0, $t0, $t1
	
	lbu $t2, 20($a0)
	li $t3, 12
	mult $t2, $t3
	mflo $t2 ## offset for edges
	
	add $t0, $t0, $t2		
	
	sw $t8, 0($t0)
	sw $t9, 4($t0)
	li $t4, 0
	sb $t4, 8($t0)
	
	li $t3, -1
	mult $t2, $t3
	mflo $t2
	add $t0, $t0, $t2
	
	mult $t1, $t3
	mflo $t1
	add $t0, $t0, $t1
	
	addi $t0, $t0, -24
	
	move $a0, $t0	
								
	li $v0, 1
	
	## updating number of edges
	lbu $t1, 20($a0)
	addi $t1, $t1, 1
	sb $t1, 20($a0)
 	jr $ra
 	
 	
invalid_part4:
 	li $v0, 0
 	jr $ra

.globl add_relation_property
add_relation_property:
	move $fp, $sp
	lb $t0, 0($fp)
	
## check if t0 is equal to t1
	li $t1, 1
	bne $t1, $t0, invalid_arg_part5
	
## check if prop_name is equal to “FRIEND”
	move $t3, $a3

	li $t0, 70
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	li $t0, 82
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	li $t0, 73
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	li $t0, 69
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	li $t0, 78
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	li $t0, 68
	lbu $t1, 0($t3)
	bne $t0, $t1, invalid_arg_part5
	
	addi $t3, $t3, 1
	lbu $t1, 0($t3)
	bne $zero, $t1, invalid_arg_part5
	
	## get address of a1 in network
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_person
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t1, $v0 ## name1 address in t1
		
	## get address of a1 in network
	move $t2, $a1
	move $a1, $a2
	
	addi $sp, $sp, -12
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $ra, 0($sp)
	
	jal get_person
	
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12
	
	move $a1, $t2
	move $t2, $v0 ## name2 address in t2
	
	move $t0, $a0
	addi $t0, $t0, 24
	
	lbu $t3, 0($a0)
	lbu $t4, 8($a0)
	mult $t3, $t4
	mflo $t3 ## number of steps to move back from node add. 
	add $t0, $t0, $t3
	
	lbu $t4, 20($a0) ## current number of nodes
	li $t5, 0
	
	for_loop_part5:
		beq $t5, $t4, part5_cont
		
		lw $t6, 0($t0)
		lw $t7, 4($t0)
		
		bne $t6, $t1, for_loop_part5_cont
		beq $t7, $t2, part_5_valid
		
	for_loop_part5_cont:
		bne $t6, $t2, for_loop_part5_cont2
		beq $t7, $t1, part_5_valid
	for_loop_part5_cont2:
		addi $t0, $t0, 12
		addi $t5, $t5, 1
		j for_loop_part5
	
part5_cont:	
	j invalid_arg_part5
  	
part_5_valid:
	li $t6, 1
	sb $t6, 8($t0)
	
	li $t6, -12
	mult $t5, $t6
	mflo $t5
	add $t0, $t0, $t5
	
	li $t6, -1
	mult $t3, $t6
	mflo $t3
	add $t0, $t0, $t3
	
	addi $t0, $t0, -24
	
	move $a0, $t0
	li $v0, 1
	jr $ra
		
 invalid_arg_part5:
 	li $v0, 0
 	jr $ra

.globl is_a_distant_friend
is_a_distant_friend:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_person
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t1, $v0 ## a1 address in t1
	
	move $t0, $a1
	move $a1, $a2
	
	addi $sp, $sp, -12
	sw $t1, 8($sp)
	sw $t0, 4($sp)
	sw $ra, 0($sp)
	
	jal get_person
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12
	
	
	
	move $t2, $v0 ## a2 address in t2
	
	beq $t1, $zero, part6_inv_arg
	beq $t2, $zero, part6_inv_arg
	
	move $a2, $a1
	move $a1, $t0
	
## check if the two edges are a relation
	
	move $t0, $a0
	addi $t0, $t0, 24
	
	lbu $t3, 0($a0)
	lbu $t4, 8($a0)
	mult $t3, $t4
	mflo $t3 ## number of steps to move back from node add. 
	add $t0, $t0, $t3
	
	lbu $t4, 20($a0) ## current number of nodes
	li $t5, 0
	
	move $t9, $t0
	
	for_loop_part6:
		beq $t5, $t4, part6_cont
		
		lw $t6, 0($t0)
		lw $t7, 4($t0)
		
		bne $t6, $t1, for_loop_part6_cont
		beq $t7, $t2, check_if_friend1
		
		j for_loop_part6_cont
		
	check_if_friend1:
		lbu $t8, 8($t0)	
		bne $zero, $t8, is_direct_relation
		
	for_loop_part6_cont:
		bne $t6, $t2, for_loop_part6_cont2
		beq $t7, $t1, check_if_friend2
		
		j for_loop_part6_cont2
		
	check_if_friend2:
		lbu $t8, 8($t0)	
		bne $zero, $t8, is_direct_relation
		
	for_loop_part6_cont2:
		addi $t0, $t0, 12
		addi $t5, $t5, 1
		j for_loop_part6

part6_cont:
## DFS APPROACH!!! 
	move $t0, $t9 ## t0 now contains the edges list
	move $t4, $a0
	move $t5, $a1
	move $t6, $a2
	
	lbu $a3, 20($a0)
	
	addi $sp, $sp, -16
	sw $t4, 12($sp)
	sw $t5, 8($sp)
	sw $t6, 4($sp)
	sw $ra, 0($sp)
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	## already have a3
	
	jal dfs
	
	lw $ra, 0($sp)
	lw $t6, 4($sp)
	lw $t5, 8($sp)
	lw $t4, 12($sp)
	addi $sp, $sp, 16
	
	move $a0, $t4
	move $a1, $t5
	move $a2, $t6
	
	## return value will be in v0 anyways
 	jr $ra
 
 	
## a0 is edges_list, a1 -> addy of current_name, a2 -> addy of name2, a3 -> max_number		
dfs:
	move $t0, $a0
	li $t1, 0
	dfs_for_loop:
		beq $t1, $a3, dfs_fail	
		
		## check if visited
		lbu $t2, 8($t0)
		li $t3, 84
		beq $t2, $t3, dfs_for_loop_final
		beq $t2, $zero, dfs_for_loop_final
		
		lw $t3, 0($t0)
		lw $t4, 4($t0)
		
		bne $t3, $a1, dfs_for_loop_cont
		
		found_a_match:
			beq $t4, $a2, is_match1 ##FOUND A MATCH
			
			li $t5, 84
			move $t6, $t0
			lbu $t2, 8($t6)
			sb $t5, 8($t6)
			
			
			li $t5, -12
			mult $t5, $t1
			mflo $t5 
			add $t6, $t6, $t5 ## contains beg of edge arr, with updated update
			
			move $t7, $a0
			move $t8, $a1
			
			addi $sp, $sp -32
			sw $t2, 28($sp)
			sw $t8, 24($sp)
			sw $t7, 20($sp)
			sw $t4, 16($sp)
			sw $t3, 12($sp)
			sw $t1, 8($sp)
			sw $t0, 4($sp)
			sw $ra, 0($sp)
			
			move $a0, $t6
			move $a1, $t4 ## update to proper arg
			
			jal dfs
			
			lw $ra, 0($sp)
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			lw $t3, 12($sp)
			lw $t4, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t2, 28($sp)
			addi $sp, $sp 32
			
			move $a0, $t7
			move $a1, $t8
			
			sb $t2, 8($t0)
			
			li $t9, 1
			beq $v0, $t9, is_match1			
			
			j dfs_for_loop_cont
			
		is_match1:
			li $v0, 1
			jr $ra
	
	dfs_for_loop_cont:
		beq $t4, $a1, found_a_match2
		j dfs_for_loop_final
		
		found_a_match2:
			beq $t3, $a2, is_match1 ##FOUND A MATCH
			li $t5, 84
			move $t6, $t0
			lbu $t2, 8($t6)
			sb $t5, 8($t6)
			
			li $t5, -12
			mult $t5, $t1
			mflo $t5 
			add $t6, $t6, $t5 ## contains beg of edge arr, with updated update
			
			move $t7, $a0
			move $t8, $a1
			
			addi $sp, $sp -32
			sw $t2, 28($sp)
			sw $t8, 24($sp)
			sw $t7, 20($sp)
			sw $t4, 16($sp)
			sw $t3, 12($sp)
			sw $t1, 8($sp)
			sw $t0, 4($sp)
			sw $ra, 0($sp)
			
			move $a0, $t6
			move $a1, $t3 ## update to proper arg
			
			jal dfs
			
			lw $ra, 0($sp)
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			lw $t3, 12($sp)
			lw $t4, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t2, 28($sp)
			addi $sp, $sp 32
			
			sb $t2, 8($t0)
			
			move $a0, $t7
			move $a1, $t8
			
			li $t9, 1
			beq $v0, $t9, is_match2
			
			j dfs_for_loop_final
			
		is_match2:
			li $v0, 1
			jr $ra
		
	dfs_for_loop_final:
		addi $t0, $t0, 12
		addi $t1, $t1, 1
		j dfs_for_loop		
	
dfs_fail:
	li $v0, 0
	jr $ra

	
			
is_direct_relation:
 	li $v0, 0
 	jr $ra
  
 part6_inv_arg:
 	 li $v0, -1
 	 jr $ra
 
  

  
.globl instructors_test_add_relation_prop
instructors_test_add_relation_prop:
addi $sp, $sp, -8
addi $t0, $0, 1
sw $t0, 0($sp)
sw $ra, 4($sp)
jal add_relation_property
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
