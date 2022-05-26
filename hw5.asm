############## Rahul Raja ##############
############## ***** #################
############## ***** ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:
	## t registers using: t0, t1
	
	beq $a0, $zero, invalid_arg_part1
	slt $t0, $a1, $zero ## should be 0 if valid
	bne $t0, $zero, invalid_arg_part1

	## a0 -> coeff, a1 -> exp
	move $t1, $a0
	## allocating memory
	li $a0, 12
	li $v0, 9
	syscall
	
	## lbu $t0, 0($a0) ## getting value from a0
	## lbu $t1, 0($a1) ## getting value from a1
	
	sw $t1, 0($v0)
	sw $a1, 4($v0)
	sw $zero, 8($v0)
	
	lb $t0, 0($v0)
		
	## $v0 contains first term!
	jr $ra
	
	invalid_arg_part1:
		li $v0, -1
 		jr $ra
	
	
	
	
	
	
	
.globl create_polynomial
create_polynomial:
	move $t0, $a0

	li $t1, 0
	
	li $a0, 0
	li $v0, 9
	syscall
	
	
	
	move $t8, $v0
	
	merging_loop:
		
		lb $t2, 0($t0) ## coef
		lb $t3, 4($t0) ## exp
		
		
		
		bne $t2, $zero, merging_loop_cont2
		li $t4, -1
		beq $t4, $t3, part2_cont
		
	merging_loop_cont2:	
		li $t4, 0 ## iterator for common loop
		move $t6, $t8
		
	merging_loop_cont3:
		slt $t4, $t3, $zero ## valid if t3 is > zero so must be 0
		bne $t4, $zero, part2_invalid
		
		beq $t2, $zero, part2_invalid
		
	check_for_repeat:
		beq $t4, $t1, inner_loop_part2
		lb $t5, 4($t6)
		
		beq $t3, $t5, same_term_part2
	
		addi $t4, $t4, 1
		addi $t6, $t6, 8
		j check_for_repeat
		
	inner_loop_part2:
		li $a0, 8
		li $v0, 9
		syscall
		
		sw $t2, 0($v0)
		sw $t3, 4($v0)
		
		bne $t1, $zero, inner_loop_part2_cont
		
	first_time_iter:
		move $t8, $v0
	
	inner_loop_part2_cont:	
		addi $t1, $t1, 1 ## total count
		j merging_loop_cont
			
	same_term_part2:
		lb $t7, 0($t6)
		add $t7, $t7, $t2
		sw $t7, 0($t6)
		
	merging_loop_cont:
		addi $t0, $t0, 8
		j merging_loop
	

part2_cont:	
	## creating polynomial structure
	move $t0, $t8 ## t0 now has the terms
	li $a0, 8
	li $v0, 9
	syscall
	
	move $t4, $v0
	li $t5, 0 ## iterator
	li $t9, 0 ## real iterator
	
	beq $t1, $zero, part2_invalid
	
	
	while_loop_part2:
		beq $t5, $t1, part2_cont2
		lb $t2, 0($t0)
		lb $t3, 4($t0)
		
	while_loop_part2_cont:
		move $a0, $t2
		move $a1, $t3
		
		addi $sp, $sp, -12
		sw $t0, 8($sp)
		sw $t1, 4($sp)
		sw $ra, 0($sp)
		
		jal create_term
		
		lw $ra, 0($sp)
		lw $t1, 4($sp)
		lw $t0, 8($sp)
		addi $sp, $sp, 12
		
		li $t8, -1
		beq $v0, $t8, while_loop_part2_cont3
		
		
		
		## result in $v0
		beq $t9, $zero, first_iteration_part2
		addi $t9,$t9, 1
		sw $v0, 8($t6)
		
		j while_loop_part2_cont2
		
	first_iteration_part2:
		addi $t9,$t9, 1
		move $t7, $v0
					
	while_loop_part2_cont2:
		move $t6, $v0
	while_loop_part2_cont3:		
		addi $t5, $t5, 1
		addi $t0, $t0, 8
		j while_loop_part2
		
	
part2_cont2:
	sw $t7, 0($t4)
	sw $t9, 4($t4)
	move $v0, $t4
	jr $ra
	
part2_invalid:
	move $v0, $zero
	jr $ra
	

	





.globl sort_polynomial
sort_polynomial:
	move $t0, $a0
	lw $t1, 4($a0) ## length of polynomial
	
	lw $t2, 0($t0)
	move $t0, $t2
	
	li $t2, 0
	for_loop_part3:
		beq $t2, $t1, part3_cont
		lw $t3, 0($t0)
		lw $t4, 4($t0)
		
		addi $t5, $t2, 1
		lw $t6, 8($t0)
		
		
		inner_loop_part3:
			beq $t5, $t1, for_loop_part3_cont
			lw $t7, 0($t6)
			lw $t8, 4($t6)
			
			slt $t9, $t8, $t4 ## should be 1 in order to not change
			beq $t9, $zero, swap_elements
			
			j inner_loop_part3_cont
			
			swap_elements:
				sw $t3, 0($t6)
				sw $t7, 0($t0)
				sw $t4, 4($t6)
				sw $t8, 4($t0)
				
				move $t3, $t7
				move $t4, $t8
			
		inner_loop_part3_cont:
			lw $t9, 8($t6)
			move $t6, $t9
			addi $t5, $t5, 1
			j inner_loop_part3
			
	for_loop_part3_cont:
		lw $t5, 8($t0)
		move $t0, $t5
		addi $t2, $t2, 1
		j for_loop_part3
	
	
part3_cont:
jr $ra

.globl add_polynomial
add_polynomial:

	## preliminary checks
	beq $a0, $zero, return_second_part4
	beq $a1, $zero, return_first_part4
	
	move $t0, $a0
	move $t1, $a1
	addi $sp, $sp, -8
	sw $t0, 4($sp)
	sw $t1, 0($sp)
	
	
	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	
	## sorting the two polynomials
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal sort_polynomial
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t0, $a0
	move $a0, $a1
	
	addi $sp, $sp, -8
	sw $t0, 4($sp)
	sw $ra, 0($sp)
	
	jal sort_polynomial
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	
	
	
	
	
	move $a1, $a0
	move $a0, $t0
	
	move $t0, $a0
	move $t1, $a1
	
	lb $t2, 4($a0) ## max1
	lb $t3, 4($a1) ## max2
	
	lw $t4, 0($t0)
	lw $t5, 0($t1)
	move $t0, $t4
	move $t1, $t5
		
	
	li $a0, 8
	li $v0, 9
	syscall
	
	
	
	
	move $t5, $v0 ## s0 contains beg of polynomial
	move $s0, $v0 
	
	
	
	li $t6, 0 ## arg1 iterator
	li $t7, 0 ## arg2 iterator
	li $t4, 0 ## total iterator
	
	while_loop_part4:
		beq $t6, $t2, add_second_arg
		beq $t7, $t3, add_first_arg
		
		lb $t8, 4($t0)
		lb $t9, 4($t1)
		
		bne $t8, $t9, not_equal
		
	equal:
		lb $t8, 0($t0)
		lb $t9, 0($t1)
		add $t8, $t8, $t9 ## storing coefficient in $t0
		
		beq $t8, $zero, while_loop_part4_cont3 ## when coef is 0
		lb $t9, 4($t0)
		
		addi $sp, $sp, -20
		sw $t1, 16($sp)
		sw $t0, 12($sp)
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		sw $a1, 0($sp)
		
		move $a0, $t8
		move $a1, $t9
		
		jal create_term
		
		lw $a1, 0($sp)
		lw $a0, 4($sp)
		lw $ra, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		addi $sp, $sp, 20
			
		addi $t6, $t6, 1
		addi $t7, $t7, 1
		lw $t8, 8($t0)
		lw $t9, 8($t1)
		move $t0, $t8
		move $t1, $t9
			
		j while_loop_part4_cont	
		
		
	not_equal:
		addi $sp, $sp, -4
		sw $t6, 0($sp)
		
		slt $t6, $t8, $t9 ##
		bne $t6, $zero, second_first
		
		first_first:
			lw $t6, 0($sp)
			addi $sp, $sp, 4
			## arguments
			
			addi $sp, $sp, -20
			sw $t1, 16($sp)
			sw $t0, 12($sp)
			sw $ra, 8($sp)
			sw $a0, 4($sp)
			sw $a1, 0($sp)
			
			
			lb $a0, 0($t0)
			lb $a1, 4($t0)
			
			jal create_term
			
			lw $a1, 0($sp)
			lw $a0, 4($sp)
			lw $ra, 8($sp)
			lw $t0, 12($sp)
			lw $t1, 16($sp)
			addi $sp, $sp, 20
			
			addi $t6, $t6, 1
			lw $t8, 8($t0)
			move $t0, $t8
			
			j while_loop_part4_cont			
			
		second_first:
			lw $t6, 0($sp)
			addi $sp, $sp, 4
			
			addi $sp, $sp, -20
			sw $t1, 16($sp)
			sw $t0, 12($sp)
			sw $ra, 8($sp)
			sw $a0, 4($sp)
			sw $a1, 0($sp)
			
			
			lb $a0, 0($t1)
			lb $a1, 4($t1)
			
			jal create_term
			
			lw $a1, 0($sp)
			lw $a0, 4($sp)
			lw $ra, 8($sp)
			lw $t0, 12($sp)
			lw $t1, 16($sp)
			addi $sp, $sp, 20
			
			addi $t7, $t7, 1
			lw $t8, 8($t1)
			move $t1, $t8
			
			j while_loop_part4_cont
	
	while_loop_part4_cont:
		beq $t4, $zero, first_iter_part4
		sw $v0, 8($t5)
		j while_loop_part4_cont2
		
	first_iter_part4:
		move $s1, $v0
		
	while_loop_part4_cont2:
		move $t5, $v0
		addi $t4, $t4, 1
		j while_loop_part4
		
	while_loop_part4_cont3:
		addi $t6, $t6, 1
		addi $t7, $t7, 1
		lw $t8, 8($t0)
		lw $t9, 8($t1)
		move $t0, $t8
		move $t1, $t9
		j while_loop_part4
		
			
		
		
	add_second_arg:
		beq $t7, $t3, part4_cont2
		
		addi $sp, $sp, -20
		sw $t1, 16($sp)
		sw $t0, 12($sp)
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		sw $a1, 0($sp)
			
			
		lb $a0, 0($t1)
		lb $a1, 4($t1)
			
		jal create_term
			
		lw $a1, 0($sp)
		lw $a0, 4($sp)
		lw $ra, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		addi $sp, $sp, 20
		
		sw $v0, 8($t5)
		move $t5, $v0
		addi $t7, $t7, 1
		lw $t8, 8($t1)
		move $t1, $t8
		addi $t4, $t4, 1
		j add_second_arg
			
	add_first_arg:
		beq $t6, $t2, part4_cont2
		
		addi $sp, $sp, -20
		sw $t1, 16($sp)
		sw $t0, 12($sp)
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		sw $a1, 0($sp)
			
			
		lb $a0, 0($t0)
		lb $a1, 4($t0)
			
		jal create_term
			
		lw $a1, 0($sp)
		lw $a0, 4($sp)
		lw $ra, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		addi $sp, $sp, 20
		
		sw $v0, 8($t5)
		move $t5, $v0
		addi $t6, $t6, 1
		addi $t4, $t4, 1
		lw $t8, 8($t0)
		move $t0, $t8
		j add_first_arg
	
	part4_cont2:
	
	beq $t4, $zero, return_null_part4
		
	move $t6, $s0
	move $t7, $s1
	
	sw $t7, 0($t6)
	sw $t4, 4($t6)
	
	move $v0, $t6

return_null_part4:
	move $t6, $s0
	move $t7, $s1
		
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $a1, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 16
	
	move $v0, $t6
		
	jr $ra

return_first_part4:
	
	move $t0, $a0
	
	addi $sp, $sp, -12
	sw $t0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	jal sort_polynomial
	
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	
	move $a0, $t0
	move $v0, $a0
	jr $ra	

return_second_part4:
	beq $a1, $zero, return_real_null_part4
	
	move $t0, $a0
	
	addi $sp, $sp, -12
	sw $t0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	move $a0, $a1
	
	jal sort_polynomial
	
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	
	move $a1, $a0
	move $a0, $t0

	move $v0, $a1
	jr $ra
	
return_real_null_part4:
	move $t0, $a0
	li $a0, 8
	li $v0, 9
	syscall
	
	sw $zero, 0($v0)
	li $t1, 0
	sw $t1, 4($v0)
	
	move $a0, $t0
	jr $ra




.globl mult_polynomial
mult_polynomial:
	beq $a0, $zero, null_element_part5
	beq $a1, $zero, null_element_part5
	move $t0, $a0
	move $t1, $a1
	
	lb $t2, 4($t0) ## number of polynomials, also length of arg1
	lb $t3, 4($t1) ## length of each polynomial, also length of arg2
	
	beq $t2, $zero, null_element_part5
	beq $t3, $zero, null_element_part5
	
	lw $t4, 0($t0)
	move $t0, $t4
	
	li $t4, 0
	
	## creating memory space
	li $t5, 4
	mult $t2, $t5
	mflo $t5
	
	move $a0, $t5
	li $v0, 9
	syscall
	
	move $t5, $v0 ## t5 contains the memory for the pointers for the polynomials
	
	li $t6, 0
	
	for_loop_part5:
		beq $t6, $t2, part5_cont
		
		addi $sp, $sp, -40
		sw $a1, 36($sp)
		sw $a0, 32($sp)
		sw $t6, 28($sp)
		sw $ra, 24($sp)
		sw $t5, 20($sp)
		sw $t4, 16($sp)
		sw $t3, 12($sp)
		sw $t2, 8($sp)
		sw $t1, 4($sp)
		sw $t0, 0($sp)
		
		lb $a0, 0($t0)
		move $a2, $a1
		lb $a1, 4($t0)
		 
		
		jal multiply_polynomial_helper
		
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)
		lw $ra, 24($sp)
		lw $t6, 28($sp)
		lw $a0, 32($sp)
		lw $a1, 36($sp)		
		addi $sp, $sp, 40
		
		sw $v0, 0($t5) ## storing the polynomial in t5
		
		addi $t6, $t6, 1
		addi $t5, $t5, 4
		lw $t7, 8($t0)
		move $t0, $t7
		j for_loop_part5
		
		


part5_cont:
	li $t8, 1
	beq $t2, $t8, return_singular_multiplix
	addi $t5, $t5, -8
	
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	
	li $t8, 0
	addi $t2, $t2, -1
	
	part5_forloop_2:
		beq $t8, $t2, part5_cont2
	
		addi $sp, $sp, -32
		sw $t8, 28($sp)
		sw $t7, 24($sp)
		sw $a1, 20($sp)
		sw $a0, 16($sp)
		sw $t6, 12($sp)
		sw $ra, 8($sp)
		sw $t5, 4($sp)
		sw $t2, 0($sp)
		
		move $a0, $t6
		move $a1, $t7
		
		jal add_polynomial
		

		lw $t2, 0($sp)
		lw $t5, 4($sp)
		lw $ra, 8($sp)
		lw $t6, 12($sp)
		lw $a0, 16($sp)
		lw $a1, 20($sp)
		lw $t7, 24($sp)	
		lw $t8, 28($sp)	
		addi $sp, $sp, 32
		
		move $t6, $v0 ##
		addi $t5, $t5, -4
		lw $t7, 0($t5)
		
		addi $t8, $t8, 1
		j part5_forloop_2
	
part5_cont2:
	move $v0, $t6	
  	jr $ra
  	
return_singular_multiplix:
	addi $t5, $t5, -4
	lw $t4, 0($t5)
	
	move $t0, $t4
	## SORT THIS VALUE
	
	addi $sp, $sp, -16
	sw $t0, 12($sp)
	sw $a1, 8($sp)
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	move $a0, $t0
	jal sort_polynomial
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 12($sp)
	addi $sp, $sp,16

	move $v0, $t0
	jr $ra
	
null_element_part5:	
	li $a0, 8
	li $v0, 9
	syscall
	
	sw $zero, 0($v0)
	sw $zero, 4($v0)
  	jr $ra
  
  
  
  
  
## arguments: a0: coef, a1: exp, a2: second polynomial 
multiply_polynomial_helper:
	
	move $t0, $a2
	lb $t1, 4($t0) ## number of terms in second polynomial
	
	move $t2, $a0 ## t2 contains the coef
	
	## creating the space for the polynomial
	li $a0, 8
	li $v0, 9
	syscall
	
	move $t3, $v0 ## t3 contains the start of the polynomial which is what we are returning
	
	lw $t4, 0($t0)
	move $t0, $t4
	
	li $t4, 0
	li $t9, 0
	
	for_loop_part5_helper:
		beq $t4, $t1, multiply_polynomial_cont
		
		lb $t5, 0($t0) ## coef
		lb $t6, 4($t0) ## exp
		
		mult $t5, $t2
		mflo $t5 ## new coef
		add $t6, $a1, $t6 ## new exp
		
		addi $sp, $sp, -20
		sw $t1, 16($sp)
		sw $t0, 12($sp)
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		sw $a1, 0($sp)
			
		move $a0, $t5
		move $a1, $t6
			
		jal create_term
			
		lw $a1, 0($sp)
		lw $a0, 4($sp)
		lw $ra, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		addi $sp, $sp, 20
		
		li $t6, -1
		beq $v0, $t6, part5_helper_for_loop_end
		
		
		beq $t9, $zero, first_iter_part5_helper 
		sw $v0, 8($t8)
		
		move $t8, $v0
		addi $t9, $t9, 1
		
		j part5_helper_for_loop_end
		
		first_iter_part5_helper:
			move $t7, $v0
			move $t8, $v0
			addi $t9, $t9, 1
		
		
		
		part5_helper_for_loop_end:
			addi $t4, $t4, 1
			lw $t6, 8($t0)
			move $t0, $t6
			j for_loop_part5_helper	
			

			
	
	multiply_polynomial_cont:
		sw $t7, 0($t3)
		sw $t9, 4($t3)
		
		move $v0, $t3
		jr $ra
		
.globl instructors_hw5_sort_poly_test
instructors_hw5_sort_poly_test:
 addi $sp, $sp, -8
 sw $ra, 0($sp)
 sw $s0, 4($sp)
 jal create_polynomial
 move $s0, $v0
 move $a0, $v0
 jal sort_polynomial
 move $v0, $s0
 lw $ra, 0($sp)
 lw $s0, 4($sp)
 addi $sp, $sp, 8
 jr $ra

.globl instructors_hw5_add_poly_test
instructors_hw5_add_poly_test:
addi $sp, $sp, -20
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
move $s1, $a0
move $s2, $a1
move $a0, $s1
jal create_polynomial
move $s0, $v0
move $a0, $s2
jal create_polynomial
move $s3, $v0
move $a0, $s0
move $a1, $s3
jal add_polynomial
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
addi $sp, $sp, 20
jr $ra

.globl instructors_hw5_mult_poly_test
instructors_hw5_mult_poly_test:
addi $sp, $sp, -20
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
move $s1, $a0
move $s2, $a1
move $a0, $s1
jal create_polynomial
move $s0, $v0
move $a0, $s2
jal create_polynomial
move $s3, $v0
move $a0, $s0
move $a1, $s3
jal mult_polynomial
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
addi $sp, $sp, 20
jr $ra
		
	
	
	
