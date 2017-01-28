# Alexander Powell
# CSCI 524
# Homework #3
# Due: 09.27.2016
# MergeSort implemented in MIPS assembly

.data
	InputPrompt1:
	.asciiz "Please enter up to 15 numbers, each followed by a newline. \n"
	
	InputPrompt2:
	.asciiz "Enter a -1 to indicate you are finished with your input. \n"
	
	NewLine:
	.asciiz "\n"
	
	Comma:
	.asciiz ","
	
	Space:
	.asciiz " "
	
	OutputMessage:
	.asciiz "\nThe sorted list is: \n"
	
	ErrorMessage:
	.asciiz "\nYou have entered an empty array. \n"

.text
	
	# Print the promp messages to the user
	la $a0, InputPrompt1
	jal Print_string
	la $a0, InputPrompt2
	jal Print_string
	la $a0, NewLine
	jal Print_string
	
	la $a0, IntArray
	la $a1, listOfInts
	li $t1, 0
	UserInput:
	li $v0, 5
	syscall
	move $t2, $v0
	beq $t2, -1, FinishedWithInput
	addi $t1, $t1, 1 # Increment the counter
	sw $t2, 0($a0)
	sw $a0, 0($a1)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	j UserInput

	FinishedWithInput:
	sw $t1, lengthOfArray

	la $a0, listOfInts
	lw $t2, lengthOfArray
	sll $t2, $t2, 2
	add $a2, $a0, $t2
	jal MergeSort
  	
  	# Sorting is complete.  Now display results back to the user
DisplaySortedList:

	lw $t1, lengthOfArray
	beqz $t1, PrintError

	li $t2, 0
	la $a0, OutputMessage
	jal Print_string
printNextItem:
	lw $t1, lengthOfArray
	bge $t2, $t1, exitProgram
	sll $t0, $t2, 2
	lw $t3, listOfInts($t0)
	lw $a0, 0($t3)
	jal Print_integer
	addi $t2, $t2, 1
abortProgram:
	bge $t2, $t1, exitProgram
	la $a0, Comma
	jal Print_string
	la $a0, Space
	jal Print_string
	j printNextItem
exitProgram:
	jal Exit
	
PrintError:
	la $a0, ErrorMessage
	jal Print_string
	addi $v0, $zero, 10
	syscall
	#jal Exit
	
# Takes in pointers to the starting and ending address of the int array

MergeSort:

	# Save values to the stack
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a2, 8($sp)
	sub $t2, $a2, $a0
	ble $t2, 4, ExitMergeSort
	srl $t2, $t2, 3
	sll $t2, $t2, 2
	add $a2, $a0, $t2
	sw $a2, 12($sp)
	
FirstRecursiveCall:
	# First recursive call back to MergeSort
	jal MergeSort
	
	lw $a0, 12($sp)
	lw $a2, 8($sp)
	
SecondRecursiveCall:
	# Second recursive call back to MergeSort
	jal MergeSort
	
	lw $a0, 4($sp)
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	
	# Merge the two halves back together
	jal Merge
	
ExitMergeSort:				

	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra

# Takes in 3 pointers - beginning, middle, and end
Merge:
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a2, 8($sp)
	sw $a1, 12($sp)
	
MoveElements:
	move $s0, $a0
	move $s1, $a2
	
mergeloop:

	lw $t2, 0($s0)
	lw $t1, 0($s1)
	lw $t2, 0($t2)
	lw $t1, 0($t1)

switchOrder:
	bgt $t1, $t2, greaterThan
	
	move $a0, $s1
	move $a2, $s0
	jal moveArrayElement
	
	addi $s1, $s1, 4
greaterThan:
	addi $s0, $s0, 4
	
	lw $a1, 12($sp)
	bge $s0, $a1, mergeloopend
	bge $s1, $a1, mergeloopend
	j mergeloop
	
mergeloopend:
	
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra

moveArrayElement:
	li $t2, 10
	ble $a0, $a2, lessThan
	subi $t6, $a0, 4
LoadAndStore:
	lw $t7, 0($a0)
	lw $t8, 0($t6)
	sw $t7, 0($t6)
	sw $t8, 0($a0)
	move $a0, $t6
	j moveArrayElement
lessThan:
	jr $ra
	
	
########## Helper functions ##########

.globl Print_integer
Print_integer: # print the integer in register a0
addi $v0, $zero, 1
syscall
jr $ra

.globl Print_string
Print_string: # print the string whose starting address is in register a0
addi $v0, $zero, 4
syscall
jr $ra

.globl Print_character
Print_character: # print the character whose address is in register a0
addi $v0, $zero, 11
syscall
jr $ra

.globl Exit
Exit: # end the program, no explicit return status
addi $v0, $zero, 10
syscall
jr $ra


.data
	IntArray:
	.word 0:15

	number:	.word	1

	lengthOfArray:	.word	15
	listOfInts:	.word	number
	
	
