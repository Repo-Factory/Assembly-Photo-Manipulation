jal main
#                         CS 240, Lab #5
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
#      Remember to fill in your name, Red ID in the designated fields.
#
#
#      
###############################################################
#                           Data Section
.data
student_name: .asciiz "Conner Sommerfield"
student_id: .asciiz "824769654"

identity_m: .word 1, 0, 0, 0, 1, 0
scale_m:    .word 2, 0, 0, 0, 1, 0
rotation_m: .word 0, 1, 0, 1, 0, 0
shear_m:    .word 1, 1, 0, 0, 1, 0

input_1: .byte 100, 60, 81, 2
input_2: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
input_3: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55
output_1: .space 4
output_2: .space 9
output_3: .space 16
input_4: .byte 1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5
input_5: .byte 210, 220, 230,10, 20, 30, 110, 127, 130, 55 , 140, 210, 220, 230, 240, 2, 3, 4, 5,10
input_6: .byte 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55, 230, 240, 250, 255, 55,230, 240, 250, 255, 55
output_4: .space 25
output_5: .space 25
output_6: .space 25

# Part 1 tests data
# thresh value = 128
test_11_expected_output: .byte 0, 0, 0, 0
test_12_expected_output: .byte 0, 0, 0, 0, 0, 255, 255, 255, 255
test_13_expected_output: .byte 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0

# Part 2 tests data
# identity and rotation on input 2
test_221_expected_output: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
test_222_expected_output: .byte 10, 110, 210, 20, 127, 220, 30, 130, 230
# identity, scale, rotation, and shear on input 3
test_231_expected_output: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55
test_232_expected_output: .byte 0, 20, 0, 0, 40, 128, 0, 0, 140, 220, 0, 0, 240, 255, 0, 0
test_233_expected_output: .byte 0, 40, 140, 240, 10, 110, 210, 250, 20, 128, 220, 255, 30, 130, 230, 55
test_234_expected_output: .byte 0, 10, 20, 30, 110, 128, 130, 0, 220, 230, 0, 0, 55, 0, 0, 0

# Part 3 tests data 
test_31_expected_output: .byte 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 
test_32_expected_output: .byte 10 230 210 20 220 130 127 30 55 110 230 220 140 240 210 5 4 2 10 3 40 30 10 110 20
test_33_expected_output: .byte 40 30 10 110 20 210 140 128 220 130 255 250 230 55 240 255 250 230 55 240 255 250 230 55 240

# Messages
new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz  "Program input:   " 
po_str: .asciiz "Program output:  " 
eo_str: .asciiz "Expected output: " 
t1_str: .asciiz "Testing part 1: \n" 
t2_str_0: .asciiz "Testing part 2 (identity): \n" 
t2_str_1: .asciiz "Testing part 2 (scale): \n" 
t2_str_2: .asciiz "Testing part 2 (rotation): \n" 
t2_str_3: .asciiz "Testing part 2 (shear): \n" 
t3_str: .asciiz "Testing part 3 (Cryptography): \n" 

line: .asciiz "__________________________________________________\n" 

# Files
fin: .asciiz "lenna.pgm"
fout_thresh: .asciiz "lenna_thresh.pgm"
fout_rotate: .asciiz "lenna_rotation.pgm"
fout_shear: .asciiz "lenna_shear.pgm"
fout_scale: .asciiz "lenna_scale.pgm"

fin2: .asciiz "textfile.pgm"
fout_crypt: .asciiz "text_crypt.pgm"

# Input/output buffers
.align 2
in_buffer: .space 400000
in_buffer_end:
.align 2
out_buffer: .space 400000
out_buffer_end:

###############################################################
#                           Text Section
.text
# Utility function to print byte arrays
#a0: array
#a1: length
print_array:
li $t1, 0
move $t2, $a0
print:
lb $a0, ($t2)
andi $a0, $a0, 0xff
li $v0, 1   
syscall
li $v0, 4
la $a0, space
syscall
addi $t2, $t2, 1
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
########################################################################################
#a0 = input array
#a1 = output array
#a2 = matrix
#s3 = input dim
#s4 = test str
#s5 = expected array
# Test transform function
########################################################################################
test_p2:
# save ra
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4
sw $a1, 0($sp)
addi $sp, $sp, -4
sw $a2, 0($sp)
addi $sp, $sp, -4
sw $a3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)


#a0: input buffer address
#a1: output buffer address
#a2: transform matrix address
#a3: image dimension  (Image will be square sized, i.e. total size = a3*a3)
jal transform 

lw $s5, 0($sp)    
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

# s5: exp arraay
# s4: input string
# s3: input dimenstion
# s2: matrix
# s1: user out
# s0: inputd

mul $s3, $s3, $s3

move $a0, $s4
syscall
la $a0, i_str
syscall
move $a0, $s0
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
move $a0, $s1
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
move $a0, $s5
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# restore ra
lw $ra, 0($sp)
addi $sp, $sp, 4

jr $ra
###############################################################
###############################################################
#                       PART 1 (Image Thresholding)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e., number of pixels = a2*a2)
#a3: threshold value 
###############################################################
.globl threshold
threshold:
############################## Part 1: your code begins here ###

# ** simulate while loop which iterates a2*a2 number of times ** #
mul $t3, $a2, $a2
move $t2, $zero # $t2 is counter variable
while:
beq $t2, $t3 break

# ** grab pixel ** #
lbu $t0, 0($a0)

# ** perform logic ** #
blt $t0, $a3 setZero

setOne:		 # set to one if greater than threshold 
move $t0, $zero
addi $t0, $t0, 255
j logicDone

setZero:	 # set to zero if less than threshold
move $t0, $zero

logicDone:
# ** Output Pixel ** #
sb $t0, 0($a1)

# ** Increment Variables for Loop ** #
addi $a0, $a0, 1
addi $a1, $a1, 1
addi $t2, $t2, 1
j while

break:
	
############################### Part 1: your code ends here ###
jr $ra
###############################################################
###############################################################
#                           PART 2 (Matrix Transform)
#a0: input buffer address
#a1: output buffer address
#a2: transform matrix address
#a3: image dimension  (Image will be square sized, i.e., number of pixels = a3*a3)
###############################################################
.globl transform
transform:
############################### Part 2: your code begins here ##

# ** simulate while loop which iterates a3*a3 number of times ** #
mul $t3, $a3, $a3
move $t2, $zero # $t2 is counter variable
while2:
beq $t2, $t3 break2

# ** perform logic ** # - 
# * get the x, y coordinate of pixel by dividing loop counter by dimension * #
div $t2, $a3
mfhi $t4	# remainder is x
mflo $t5	# quotient is y

# * generate new x y by applying matrix transform with equation * #
# x0 = M00 x X + M01 x y + M02
# y0 = M10 x X + M11 x y + M12
# As a note, make sure to use increments of 4 for the offset since the matrix values are words

# x0 logic
lw $t6, 0 ($a2)		# M00 x X
mul $t7, $t6, $t4

lw $t6, 4 ($a2)		# M01 x y
mul $t8, $t6, $t5	

add $t9, $t7, $t8	# add above terms

lw $t6, 8 ($a2)		# + M02
add $t9, $t9, $t6

move $t1, $t9		# x coordinate moved to $t1 *****

# y0 logic
lw $t6, 12 ($a2)	# M10 x X
mul $t7, $t6, $t4

lw $t6, 16 ($a2)	# M11 x y
mul $t8, $t6, $t5	

add $t9, $t7, $t8	# add above terms

lw $t6, 20 ($a2)	# + M12
add $t9, $t9, $t6

			# y coordinate stored in $t9 *****
			
			
# ** find appropriate value to store to output buffer ** #
blt $t1, $a3 checkTwo	# check that x and y are within parameters of dimensions, otherwise store 0
j noStore
checkTwo:
blt $t9, $a3 willStore

noStore:		# store zero to current output buffer pixel
sb $zero, 0($a1)
j doneStore

willStore:
# determine appropriate pixel to load			
move $t4, $zero
mul $t4, $t9, $a3	# multiply y by dimension and add x to get pixel number we must grab from input
add $t4, $t4, $t1
add $t4, $a0, $t4	# Then add input buffer start point to get pixel number relative to the address of input buffer
# load and store
lbu $t0, 0($t4)		# load byte from appropriate address determined above
sb $t0, 0($a1)		# store that byte to the current output buffer

doneStore:

# ** Increment Variables for Loop ** #
addi $a1, $a1, 1	# output buffer
addi $t2, $t2, 1	# loop counter
j while2

break2:

############################### Part 2: your code ends here  ##
jr $ra
###############################################################
###############################################################
#                       PART 3 (Image Cryptography)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e., number of pixels = a2*a2)
###############################################################
.globl cryptography
cryptography:
############################## Part 3: your code begins here ###

# ** simulate while loop which iterates a2*a2 number of times ** #
mul $t3, $a2, $a2
move $t2, $zero # $t2 is counter variable
while3:
beq $t2, $t3 break3

# ** grab pixel ** #
lbu $t0, 0($a0)

# ** perform logic ** # - 
# Identity values: 1 2 3 4 5
# Transform: 	   4 3 1 5 2
# Shift values: +2, +3, -1, -3, -1    <-- note this isn't by difference of values, its found by observing how much 
# each value is shifted to the left or right from its original position to its new position

# * mod 5 the value of $t2 to find loop cycle * #
move $t4, $zero
addi $t4, $t4, 5
div $t2, $t4
mfhi $t4 	# <-- answer "returns" value in range 0-4 to $t4

# * use switch cases to perform appropriate logic * #
beq $t4, 0, case1
beq $t4, 1, case2
beq $t4, 2, case3
beq $t4, 3, case4
beq $t4, 4, case5

# perform add instruction based off shift logic to output buffer to manipulate where information will be stored
case1:
addi $t5, $a1, 2
j logicDone3

case2:
addi $t5, $a1, 3
j logicDone3

case3:
addi $t5, $a1, -1
j logicDone3

case4:
addi $t5, $a1, -3
j logicDone3

case5:
addi $t5, $a1, -1
j logicDone3

logicDone3:
# ** Output Pixel ** #
# instead of outputing directly to output buffer value, we will output to manipulated value $t5
sb $t0, 0($t5)

# ** Increment Variables for Loop ** #
addi $a0, $a0, 1
addi $a1, $a1, 1
addi $t2, $t2, 1
j while3

break3:
		
############################### Part 3: your code ends here ###
jr $ra
###############################################################
###############################################################
###############################################################
#                          Main Function
main:

.text

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall


# Test threshold function
li $v0, 4
la $a0, t1_str
syscall

la $a0, input_1
la $a1, output_1
li $a2, 2
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_11_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_2
la $a1, output_2
li $a2, 3
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_12_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_3
la $a1, output_3
li $a2, 4
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_13_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# Part 2 testing
#a0 = input array
#a1 = output array
#a2 = matrix
#s3 = input dim
#s4 = test str
#s5 = expected array

la $a0, input_2
la $a1, output_2
la $a2, identity_m
li $a3, 3 # dim
la $s4, t2_str_0
la $s5, test_221_expected_output
jal test_p2

la $a0, input_2
la $a1, output_2
la $a2, rotation_m
li $a3, 3 # dim
la $s4, t2_str_2
la $s5, test_222_expected_output
jal test_p2

########
la $a0, input_3
la $a1, output_3
la $a2, identity_m
li $a3, 4 # dim
la $s4, t2_str_0
la $s5, test_231_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, scale_m
li $a3, 4 # dim
la $s4, t2_str_1
la $s5, test_232_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, rotation_m
li $a3, 4 # dim
la $s4, t2_str_2
la $s5, test_233_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, shear_m
li $a3, 4 # dim
la $s4, t2_str_3
la $s5, test_234_expected_output
jal test_p2


#Test Part 3
li $v0, 4
la $a0, t3_str
syscall

la $a0, input_4
la $a1, output_4
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_4
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_4
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_31_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_5
la $a1, output_5
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_5
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_5
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_32_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_6
la $a1, output_6
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_6
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_6
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_33_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall


#### Test on images
#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall

## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 512
li $a3, 80
jal threshold 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_thresh      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

###################################
#### Test on images for cryptography
#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin2      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall

## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 500
li $a3, 80
jal cryptography 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_crypt      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

###################################



#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Rotate
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, rotation_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_rotate      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Shear
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, shear_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_shear      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall




#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# scale
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, scale_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_scale      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall


_end_program:
# end program
li $v0, 10
syscall
