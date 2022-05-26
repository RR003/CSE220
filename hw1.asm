################# Rahul Raja #################
################# rahraja #################
################# 113126572 #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""                        "

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:

##### part 1 of assignment
li $t2, 2
bne $a0, $t2, display_args_err
	li $t1, 0
	move $t5, $a1 
	
	# checking number of characters in for loop. (Result from this should be 1 to continue
	for_loop: 
		lb $t2, 0($t5)
		li $t3, 0
		beq $t2, $t3, exit_loop
		addi $t5, $t5, 1
		addi $t1, $t1, 1
		j for_loop
				
display_args_err:
	li $v0, 4
	la $a0, args_err_msg
	syscall
	
	li $v0, 10
	syscall
	
exit_loop:
	li $t2, 1
	bne $t1, $t2, display_invalid_args
	lb $t2, 0($a1)
	li $t3, 'D'
	bne $t3, $t2, else2
	j part2
else2:
	li $t3, 'O'
	bne $t3, $t2, else3
	j part2
else3: 
	li $t3, 'S'
	bne $t3, $t2, else4
	j part2
else4: 
	li $t3, 'T'
	bne $t3, $t2, else5
	j part2
else5: 
	li $t3, 'I'
	bne $t3, $t2, else6
	j part2
else6: 
	li $t3, 'F'
	bne $t3, $t2, else7
	j part2
else7: 
	li $t3, 'L'
	bne $t3, $t2, display_invalid_args
	j part2
display_invalid_args:
	li $v0, 4
	la $a0, invalid_arg_msg
	syscall
	
	li $v0, 10
	syscall

	
		
			
				
					
						
							
								
									
										
												
#Part 2

part2: 
	li $t3, 'D'
	lb $t2, 0($a1)
	bne $t2, $t3, part3
	lb $t6, 0($t0)
	li $t5, 45 ## check if first digit is neg sign
	beq $t6, $t5, next_stat
	li $t9, 0
	move $t4, $t0
	li $s2, 0
	li $s3, 0
	li $s7, 0
	j while_loop2
	
next_stat:
	addi $t0, $t0, 1
	li $t9, 1
	move $t4, $t0
	li $s2, 0
	li $s3, 0
	li $s7, 0
	j while_loop2

while_loop2:
	lb $t6, 0($t4)
	beq $t6, $zero, next_state
	li $t5, 48
	slt $t1, $t6, $t5
	bne $t1, $zero, display_invalid_args
	li $t5, 58
	slt $t1, $t6, $t5
	beq $t1, $zero, display_invalid_args
	addi $s2, $s2, 1
	addi $t4, $t4, 1
	j while_loop2
	
next_state:
	li $t8, 1
	bne $t9, $t8, for_loop2
	j for_loop4
	
	
for_loop2:
	beq $s2, $zero, done
	lb $t6 0($t0)
	addi $t6, $t6, -48
	li $s5, 1	
	for_loop3:
		slt $t2, $s5, $s2
		beq $t2, $zero, for_loop2cont
		li $s4, 10
		mult $t6, $s4
		mflo $t6
		addi $s5, $s5, 1
		j for_loop3
	for_loop2cont:
		add $s7, $s7, $t6
		addi $s2, $s2, -1
		addi $t0, $t0, 1
		j for_loop2
		
for_loop4:
	beq $s2, $zero, done
	lb $t6 0($t0)
	li $t7, -1
	mult $t6, $t7
	mflo $t6
	addi $t6, $t6, 48
	li $s5, 1	
	for_loop5:
		slt $t2, $s5, $s2
		beq $t2, $zero, for_loop4cont
		li $s4, 10
		mult $t6, $s4
		mflo $t6
		addi $s5, $s5, 1
		j for_loop5
	for_loop4cont:
		add $s7, $s7, $t6
		addi $s2, $s2, -1
		addi $t0, $t0, 1
		j for_loop4
	
	
		
done:
	 

done2:
	li $v0, 1
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall
	
	
	

	
		
			
				
					
							
## part 3 ##

# check if two char is 0x

part3: 
	li $t1, 'F'
	lb $t2, 0($a1)
	beq $t1, $t2, part_4
	
	li $t1, 'L'
	lb $t2, 0($a1)
	beq $t1, $t2, part_5
	
	move $t1, $t0
	move $s1, $t0
	li $t3, 48
	lb $t2, 0($t1) ## first character must be 0
	bne $t2, $t3, display_invalid_args

	addi $t1, $t1, 1

	lb $t2, 0($t1)
	li $t3, 120
	bne $t2, $t3, display_invalid_args

	addi $t1, $t1, 1
	addi $t0, $t0, 2
	addi $s1, $s1, 2
	li $t5, 0
	j part3_while_loop

part3_while_loop:
	lb $t2, 0($t1)
	beq $t2, $zero, verify
	
	li $t4, 48
	slt $t3 $t2, $t4 ## should display 0 if its correct
	bne $t3, $zero, display_invalid_args
	
	li $t4, 58
	slt $t3, $t2, $t4 ## if its integer, then it should be 1
	bne $t3, $zero, part3_while_loop_cont
	
	li $t4, 65
	slt $t3, $t2, $t4 ## if its char, then it should be 0
	bne $t3, $zero, display_invalid_args
	
	li $t4, 71
	slt $t3, $t2, $t4 ## if its char, then it should be 1
	beq $t3, $zero, display_invalid_args
	
	part3_while_loop_cont: 
	
		addi $t1, $t1, 1
		addi $t5, $t5, 1
	
		li $t4, 8
		slt $t3, $t4, $t5 ## should be 0 if its correct
		bne $t3, $zero, display_invalid_args
		
		j part3_while_loop
	
verify:
	li $t2, 1
	slt $t3, $t5, $t2 ## should be 0 if correct
	bne $t3, $zero, display_invalid_args
	
	j next_step
	
next_step:
	li $t3, 'O'
	li $t1, 0
	lbu $t2, 0($a1)
	bne $t3, $t2, next2_step
	
	li $t4, 8
	bne $t4, $t5, next1_step_prereqs
	
	lbu $t1, 0($s1)
	addi $s1, $s1, 1
	addi $t5, $t5, -1
	j next1_step2
	
	next1_step_prereqs:	
		li $t1, 48
	
	next1_step2:
		li $t4, 7
		bne $t4, $t5, next1_step_prereqs2
		lbu $t2, 0($s1)
		j next1_step3
	
	next1_step_prereqs2:
		li $t2, 48

	next1_step3: 
	li $t3, 58
	slt $t4, $t1, $t3 ## if first part is number, should be 1
	beq $t4, $zero, next_step_1l
	addi $t1, $t1, -48
	j next_step_2n
		
	next_step_1l: 
		addi $t1, $t1, -55	
		j next_step_2n
	
	next_step_2n: 
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next_step_2l
		addi $t2, $t2, -48
		j next_step_final
	next_step_2l:
		addi $t2, $t2, -55	
	
	next_step_final: 
		sll $t1, $t1, 2
		srl $t2, $t2, 2
		add $t1, $t1, $t2
		j final_result_part3
		
next2_step:
	li $t4, 8
	bne $t5, $t4, next2_step_prereq
	addi $s1, $s1, 1
	li $t5, 7
	
	next2_step_prereq: 
	li $t3, 'S'
	lbu $t2, 0($a1)
	bne $t3, $t2, next3_step
	
	li $t4, 7
	bne $t5, $t4, next2_step_prereq2
	lbu $t1, 0($s1)
	addi $s1, $s1, 1
	addi $t5, $t5, -1
	j next2_step_prereq3
	
	next2_step_prereq2: 
		li $t1, 48


	next2_step_prereq3:
	li $t4, 6
	bne $t5, $t4, next2_step_prereq4
	lbu $t2, 0($s1)
	j next2_step_prereq5
	next2_step_prereq4:
		li $t2, 48
	
	next2_step_prereq5:
	li $t3, 58
	slt $t4, $t1, $t3 ## if first part is number, should be 1
	beq $t4, $zero, next2_step_1l
	addi $t1, $t1, -48
	j next2_step_2n
		
	next2_step_1l: 
		addi $t1, $t1, -55	
		j next2_step_2n
	
	next2_step_2n: 
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next2_step_2l
		addi $t2, $t2, -48
		j next2_step_final
	next2_step_2l:
		addi $t2, $t2, -55	
		j next2_step_final
	
	next2_step_final:
		li $t3, 3 
		and $t1, $t1, $t3 
		sll $t1, $t1, 3
		srl $t2, $t2, 1
		add $t1, $t1, $t2
		j final_result_part3

		
next3_step:
	li $t4, 7
	bne $t5, $t4, next3_step_prereq
	addi $s1, $s1, 1
	li $t5, 6




	next3_step_prereq:
	li $t3, 'T'
	lbu $t2, 0($a1)
	bne $t3, $t2, next4_step
	
	li $t4, 6
	bne $t5, $t4, next3_step_prereq2
	lbu $t1, 0($s1)
	addi $s1, $s1, 1
	addi $t5, $t5, -1
	j next3_step_prereq3
	
	next3_step_prereq2: 
		li $t1, 48
	
	next3_step_prereq3:
	li $t4, 5
	bne $t5, $t4, next3_step_prereq4
	lbu $t2, 0($s1)
	addi $t5, $t5, -1
	addi $s1, $s1, 1
	j next3_step_prereq5
	
	next3_step_prereq4:
		li $t2, 48
	
	next3_step_prereq5: 
	li $t3, 58
	slt $t4, $t1, $t3 ## if first part is number, should be 1
	beq $t4, $zero, next3_step_1l
	addi $t1, $t1, -48
	j next3_step_2n
		
	next3_step_1l: 
		addi $t1, $t1, -55	
		j next3_step_2n
	
	next3_step_2n: 
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next3_step_2l
		addi $t2, $t2, -48
		j next3_step_final
	next3_step_2l:
		addi $t2, $t2, -55	
		j next3_step_final
	
	 next3_step_final:
	 	li $t3, 1 
		and $t1, $t1, $t3
		sll $t1, $t1, 4
		add $t1, $t1, $t2
		j final_result_part3		

next4_step:
	li $t3, 'I'
	lbu $t2, 0($a1)
	bne $t3, $t2, part_4
	li $t4, 6
	bne $t5, $t4, next4_step_prereq
	
	addi $s1, $s1, 2
	li $t5, 4
	j next4_step_prereq
	
	next4_step_prereq1:
		addi $s1, $s1, 1
		li $t5, 4
		j next4_step_prereq2
	
	next4_step_prereq:
	li $t4, 5
	beq $t5, $t4, next4_step_prereq1
	
	next4_step_prereq2:
	li $t4, 4
	bne $t4, $t5, next4_step2
	
	lbu $t1 0($s1)
	addi $s1, $s1, 1
	addi $t5, $t5, -1
	
	li $t3, 58
	slt $t4, $t1, $t3 ## if first part is number, should be 1
	beq $t4, $zero, next4_step_1l
	addi $t1, $t1, -48
	sll $t1, $t1, 12
	j next4_step2
		
	next4_step_1l: 
		addi $t1, $t1, -55
		sll $t1, $t1, 12	
		j next4_step2
	
	next4_step2:
		li $t4, 3
		bne $t4, $t5, next4_step3
		
		lbu $t2 0($s1)
		addi $s1, $s1, 1
		addi $t5, $t5, -1
	
		li $t3, 58
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next4_step_2l
		addi $t2, $t2, -48
		sll $t2, $t2, 8
		add $t1, $t1, $t2
		j next4_step3
		
		next4_step_2l: 
			addi $t2, $t2, -55
			sll $t2, $t2, 8
			add $t1, $t1, $t2	
			j next4_step3
			
	next4_step3:
		li $t4, 2
		bne $t4, $t5, next4_step4
		
		lbu $t2 0($s1)
		addi $s1, $s1, 1
		addi $t5, $t5, -1
		
		li $t3, 58
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next4_step_3l
		addi $t2, $t2, -48
		sll $t2, $t2, 4
		add $t1, $t1, $t2
		j next4_step4
		
		next4_step_3l: 
			addi $t2, $t2, -55
			sll $t2, $t2, 4
			add $t1, $t1, $t2	
			j next4_step4
	
	next4_step4:
		li $t4, 1
		bne $t4, $t5, next4_step5
		
		lb $t2 0($s1)
		addi $s1, $s1, 1
		addi $t5, $t5, -1
		
		li $t3, 58
		slt $t4, $t2, $t3 ## if first part is number, should be 1
		beq $t4, $zero, next4_step_4l
		addi $t2, $t2, -48
		add $t1, $t1, $t2
		j next4_step5
		
		next4_step_4l: 
			addi $t2, $t2, -55
			add $t1, $t1, $t2	
			j next4_step5
	
		
	next4_step5:
		srl $t2, $t1, 15
		beq $t2, $zero, final_result_part3
		
		## if t1 starts with 1
		li $t2, -65536
		add $t1, $t1, $t2
		
		j final_result_part3
		
	
final_result_part3:
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 10
	syscall
	
	

	
		
			
				
					
						
### PART 4 ####
##############								
part_4:
	li $t1, 'F'
	lb $t2, 0($a1)
	bne $t2, $t1, part_5
	li $t1, 0
	move $t2, $t0
	
	part4_for_loop:
		lb $t3, 0($t2)
		beq $t3, $zero, verify_part4 ## if end of string, check if counter is 8 or not
				
		li $t4, 48
		slt $t5 $t3, $t4 ## should display 0 if its correct
		bne $t5, $zero, display_invalid_args
	
		li $t4, 58
		slt $t5, $t3, $t4 ## if its integer, then it should be 1
		bne $t5, $zero, part4_while_loop_cont
	
		li $t4, 65
		slt $t5, $t3, $t4 ## if its char, then it should be 0
		bne $t5, $zero, display_invalid_args
	
		li $t4, 71
		slt $t5, $t3, $t4 ## if its char, then it should be 1
		beq $t5, $zero, display_invalid_args
		
	part4_while_loop_cont:
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		j part4_for_loop	

	
	verify_part4:
		li $t3, 8
		bne $t1, $t3, display_invalid_args
	
	part4_edge_cases:
		move $t2, $t0
		
	part4_edge_case1:
		li $t1, 48
		lb $t3, 0($t2)  
		beq $t3, $t1, part4_edge_case1cont
		
		li $t1, 56
		beq $t3, $t1, part4_edge_case1cont
			
		j part4_edge_case2
		
		part4_edge_case1cont:
			addi $t2, $t2, 1
			lb $t3, 0($t2) ## should be zeros from now on
			
			beq $t3, $zero, special_case_1 
			li $t4, 48
			bne $t3, $t4, part4_edge_case2
			
			j part4_edge_case1cont
			
		special_case_1:
			li $v0, 4
			la $a0, zero
			syscall	
			li $v0, 10
			syscall

	
	part4_edge_case2:
		move $t2, $t0
		lb $t3, 0($t2)
		li $t4, 70 
		beq $t3, $t4, part4_edge_case2cont

		j part4_edge_case3	
		
		part4_edge_case2cont:
			addi $t2, $t2, 1
			lb $t3, 0($t2)			
			li $t4, 70
			bne $t3, $t4, part4_edge_case3
			
			addi $t2, $t2, 1
			lb $t3, 0($t2)			
			li $t4, 56
			bne $t3, $t4, part4_edge_case3
			
			part4_edge_case2cont_for_loop:
				addi $t2, $t2, 1
				lb $t3, 0($t2) ## should be zeros from now on
			
				beq $t3, $zero, special_case_2
				li $t4, 48
				bne $t3, $t4, special_case_3
			
				j part4_edge_case2cont_for_loop
			
			special_case_2:
				li $v0, 4
				la $a0, inf_neg
				syscall	
				li $v0, 10
				syscall
				
			special_case_3:
				li $v0, 4
				la $a0, nan
				syscall	
				li $v0, 10
				syscall
				
			
				
	part4_edge_case3:
		move $t2, $t0
		lb $t3, 0($t2)
		li $t4, 55
		bne $t3, $t4, part4_main
		
		addi $t2, $t2, 1
		lb $t3, 0($t2)			
		li $t4, 70
		bne $t3, $t4, part4_main
			
		addi $t2, $t2, 1
		lb $t3, 0($t2)			
		li $t4, 56
		bne $t3, $t4, part4_main
		
		part4_edge_case3cont_for_loop:
				addi $t2, $t2, 1
				lb $t3, 0($t2) ## should be zeros from now on
			
				beq $t3, $zero, special_case_4
				li $t4, 48
				bne $t3, $t4, special_case_3
			
				j part4_edge_case3cont_for_loop
				
				special_case_4:
					li $v0, 4
					la $a0, inf_pos
					syscall	
					li $v0, 10
					syscall
					
		
		
	part4_main:
		move $t1, $t0
		lbu $t2, 0($t1)
		
		li $t3, 58
		slt $t4, $t2, $t3
		beq $t4, $zero, part4_main_letter1
		addi $t2, $t2, -48
		j part4_main2
		
		part4_main_letter1:
			addi $t2, $t2, -55
			
		part4_main2:
		
		srl $s6, $t2, 3 ## s1 is the sign
		
		li $t3, 7
		and $t3, $t3, $t2
		sll $s2, $t3, 5
		
		addi $t1, $t1,1
		lbu $t2, 0($t1)
		
		li $t3, 58
		slt $t4, $t2, $t3
		beq $t4, $zero, part4_main_letter2
		addi $t2, $t2, -48
		j part4_main3
		
		part4_main_letter2:
			addi $t2, $t2, -55
		
		
		
		
		part4_main3:
		
		sll $t2, $t2, 1
		add $s2, $s2, $t2
		addi $t1,$t1, 1
		lbu $t2, 0($t1)
		
		li $t3, 58
		slt $t4, $t2, $t3
		beq $t4, $zero, part4_main_letter3
		addi $t2, $t2, -48
		j part4_main4
		
		part4_main_letter3:
			addi $t2, $t2, -55	
		
			
					
		part4_main4:
		move $t3, $t2
		srl $t3, $t3, 3
		add $s2, $s2, $t3
		
		addi $s2, $s2, -127
		
		move $a0, $s2
		
		
		
				
		
		
		la $a1, mantissa
		li $t3, 1
		beq $s6, $t3, insert_neg_sign ## checking to see if its negative, then adding negative sign
		j part_4_cont1
		
	insert_neg_sign:
			li $t3, 45
			sb $t3, 0($a1)
			addi $a1, $a1,1	
			
		
	part_4_cont1:
			
		
		li $t3, 49
		sb $t3, 0($a1) ## first character is 1
		addi $a1, $a1,1	
	
				
		li $t3, 46
		sb $t3, 0($a1) ## second character is dot
		addi $a1, $a1,1	
		
		move $t3, $t2	#### Getting second bit of third hex
		andi $t3, $t3, 7
		srl $t3, $t3, 2
		addi $t3, $t3, 48
		sb $t3, 0($a1)
		addi $a1, $a1,1
		
		move $t3, $t2  #### Getting third bit of third hex
		andi $t3, $t3, 3
		srl $t3, $t3, 1
		addi $t3, $t3, 48
		sb $t3, 0($a1)
		addi $a1, $a1,1
		
		move $t3, $t2	  #### Getting fourth bit of third hex
		andi $t3, $t3, 1
		addi $t3, $t3, 48
		sb $t3, 0($a1)
		addi $a1, $a1,1
		

		for_loop_part_four:
			addi $t1, $t1, 1 ## next byte of arg 2 string
			lb $t2, 0($t1)
			
			beq $t2, $zero, print_result_part_four ## if its end of string, go print result
			
			li $t3, 58
			slt $t4, $t2, $t3
			beq $t4, $zero, part4_main_letter16
			addi $t2, $t2, -48
			j for_loop_part_four_cont
		
			part4_main_letter16:
				addi $t2, $t2, -55
				
		for_loop_part_four_cont:
			li $t4, 0 ## iterator for inner loop
			li $t5, 4 ## max is 4
			
			inner_for_loop_part_four:
				beq $t4, $t5, break_inner_loop
				move $t3, $t2
				
				bne $t4, $zero, other_option1
				andi $t3, $t3, 15
				srl $t3, $t3, 3
				addi $t3, $t3, 48
				sb $t3, 0($a1)
				addi $a1, $a1,1
				j end_of_inner_loop
				
			other_option1:	
				li $t5, 1
				bne $t4, $t5, other_option2
				andi $t3, $t3, 7
				srl $t3, $t3, 2
				addi $t3, $t3, 48
				sb $t3, 0($a1)
				addi $a1, $a1,1
				j end_of_inner_loop
			
			other_option2:	
				li $t5, 2
				bne $t4, $t5, other_option3
				andi $t3, $t3, 3
				srl $t3, $t3, 1
				addi $t3, $t3, 48
				sb $t3, 0($a1)
				addi $a1, $a1,1
				j end_of_inner_loop
				
			other_option3:
				andi $t3, $t3, 1
				addi $t3, $t3, 48
				sb $t3, 0($a1)
				addi $a1, $a1,1
							
			end_of_inner_loop:	
				li $t5, 4
				addi $t4, $t4, 1
				j inner_for_loop_part_four
				
		
		break_inner_loop:
			j for_loop_part_four
		
		print_result_part_four:
		sb $zero, 0($a1) ## ending string with null character
		
		la $a1, mantissa
		
		#li $v0, 1
		#syscall
		
		#li $v0, 4
		#la $a0, mantissa
		#syscall
		
		
		
		li $v0, 10
		syscall					

						
												
																		
																								
																														

## PART 5 ###																																																																																	
part_5:
	li $t1, 'L'
	lb $t2, 0($a1)
	bne $t1, $t2, part_6
	
	move $t1, $t0 ## load value of arg2 into t1
	li $t2, 0 ## iterator starting at 0
	
	li $s1, 0
	li $s2, 0
	
	part5_for_loop:
		li $t3, 6
		beq $t2, $t3, part5_verify
		
		lb $t3, 0($t1)
		beq $t3, $zero, display_invalid_hand ##  checking if its equal to null string, which it shouldn't
		
		li $t4, 'M'
		beq $t3, $t4, part5_for_loop_cont_m
				
		li $t4, 'P'
		bne $t3, $t4, display_invalid_hand ## if not equal to N, it didnt equal M either so its invalid argument
		
		j part5_for_loop_cont_n
		
	
	part5_for_loop_cont_m:
		addi $t1, $t1,1
		lb $t3, 0($t1)
		beq $t3, $zero, display_invalid_hand##  checking if its equal to null string, which it shouldn't
		
		li $t4, 51
		slt $t5, $t3, $t4 ## should be 0 if it an integer
		bne $t5, $zero, display_invalid_hand
		
		li $t4, 57
		slt $t5, $t3, $t4 ## should be 1 if it an integer
		beq $t5, $zero, display_invalid_hand
		
		addi $s1, $s1, 1
		addi $t1, $t1,1
		addi $t2, $t2, 1
		j part5_for_loop
		
	part5_for_loop_cont_n:
		addi $t1, $t1,1
		lb $t3, 0($t1)
		beq $t3, $zero, display_invalid_hand##  checking if its equal to null string, which it shouldn't
		
		li $t4, 49
		slt $t5, $t3, $t4 ## should be 0 if it an integer
		bne $t5, $zero, display_invalid_hand
		
		li $t4, 53
		slt $t5, $t3, $t4 ## should be 1 if it an integer
		beq $t5, $zero, display_invalid_hand
		
		addi $s2, $s2, 1
		addi $t1, $t1,1
		addi $t2, $t2, 1
		j part5_for_loop
		
		
	part5_verify: ## verify if the last digit is null string
		lb $t3, 0($t1)
		bne $t3, $zero, display_invalid_hand	## if last digit not 0, then its invalid
		
		
		sll $s1, $s1, 3
		add $s1, $s1, $s2
		
		li $v0, 1
		move $a0, $s1
		syscall
	
		li $v0, 10
		syscall
		
	
display_invalid_hand:
	li $v0, 4
	la $a0, invalid_hand_msg
	syscall
	
	li $v0, 10
	syscall	
	
	
	
	
part_6:
						
