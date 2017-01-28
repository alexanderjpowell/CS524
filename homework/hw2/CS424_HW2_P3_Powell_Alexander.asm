.data
TheStringLabel:
.asciiz "The string "
Label_is:
.asciiz " is a palindrome\n"
Label_is_not:
.asciiz " is not a palindrome\n"
Space:
.asciiz " "
myWord:
.space 20

.text

.globl main
main:

la $a0, myWord
li $a1, 12
li $v0, 8
syscall

# myWord now contains the string, and $a0 contains starting address
# First get the count of the string
la $t0, myWord
loop:
lb $t1, 0($t0)
beq $t1, $zero, End
addi $t0, $t0, 1
j loop
End:
la $t1, myWord
sub $t0, $t0, $t1
subi $t0, $t0, 1
add $a0, $zero, $t0

la $a0, TheStringLabel
jal Print_string

# Print the word without the newline character
la $t1, myWord
addi $s7, $0, '\n' #stores newline
str_len:
lb $s1, 0($t1)
beq $s1, $s7, end_new
addi $t1, $t1, 1
j str_len
end_new:
sb $0, 0($t1)
la $a0, myWord
jal Print_string

add $t2, $zero, $t0
li $t3, 0
subi $t4, $t2, 1
la $t0, myWord
# $t2 contains length of the string
# $t3 stores a counter variable
# $t4 stores counter from other end of word
# $t0 contains starting address of work

add $t5, $t0, $t2
subi $t5, $t5, 1

loop2: #loop label

lb $a0, 0($t0) # $a0 has head, and $a1 has tail
#jal Print_character
lb $a1, 0($t5)

# compare $a0 and $a1
bne $a0, $a1, NotPalindrome

subi $t5, $t5, 1  #decrement
addi $t0, $t0, 1  #increment

addi $t3, $t3, 1
beq $t3, $t2, End2
j loop2

End2:

# Print whether the string is or is not a palindrome
IsPalindrome:
la $a0, Label_is
jal Print_string
jal Exit

NotPalindrome:
la $a0, Label_is_not
jal Print_string
jal Exit

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
