	.text
#	.align	2		# MARS doesn't like this
	.globl	main
main:
	subu	$sp, $sp, 40	# this number depends on how much will be put on the stack
	sw	$ra, 20($sp)	# save return address register
	sd	$a0, 32($sp)	# save registers a0, a1
	sw	$0, 24($sp)	# sum = 0
	sw	$0, 28($sp)	# i = 0
loop:
	lw	$t6, 28($sp)	# i
	mul	$t7, $t6, $t6	# i * i
	lw	$t8, 24($sp)	# sum
	addu	$t9, $t8, $t7	# sum + i*i
	sw	$t9, 24($sp)	# sum = sum + i*i
	addu	$t0, $t6, 2	# i + 2
	#addi $s0, $s0, 1 # calculates number of times loop occurs
	sw	$t0, 28($sp)	# i = i + 2
	ble	$t0, 100, loop	# if (i <= 100) goto loop
	
	la	$a0, str1
	jal	Print_string	# print the string whose starting address is in register a0
	lw	$a0, 24($sp)	# sum
	jal	Print_integer	# print the integer in register a0
	la	$a0, str2
	jal	Print_string	# print the string whose starting address is in register a0
	
	# MARS doesn't like this exit sequence, since the initial value of ra is 0
#	move	$v0, $0		# return status 0
#	lw	$ra, 20($sp)	# restore saved return address
#	addu	$sp, $sp, 40	# pop the stack (important - same number as before!)
#	jr	$ra		# return from main() to the OS
	
	# MARS likes this, but we need to demo Exit2
#	jal	Exit		# end the program, no explicit return status
	
	# MARS likes this
	move	$a0, $0
	jal	Exit2		# end the program, with return status from register a0

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	.data
	.align	0
str1:
	.asciiz "The sum from 0 .. 100 is :"
str2:
	.asciiz	":\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Wrapper functions around some of the system calls
# See P&H COD, Fig. A.9.1, for the complete list.

# switch to the Text segment
	.text

	.globl	Print_integer
Print_integer:	# print the integer in register a0
	addi	$v0, $zero, 1
	syscall
	jr	$ra

	.globl	Print_string
Print_string:	# print the string whose starting address is in register a0
	addi	$v0, $zero, 4
	syscall
	jr	$ra

	.globl	Exit
Exit:		# end the program, no explicit return status
	addi	$v0, $zero, 10
	syscall
	jr	$ra

	.globl	Exit2
Exit2:		# end the program, with return status from register a0
	addi	$v0, $zero, 17
	syscall
	jr	$ra