# CSCI 424, Homework 2

# switch to the Data segment
.data
# global data is defined here
# Don't forget the backslash-n (newline character)
Homework:
.asciiz "CSCI 424 Homework 2\n"
Name_1:
.asciiz "Alexander\n"
Name_2:
.asciiz "Powell\n"

# switch to the Text segment
.text
# the program is defined here
.globl main
main:
# Whose program is this?
la $a0, Homework
jal Print_string
la $a0, Name_1
jal Print_string
la $a0, Name_2
jal Print_string

# int i, n = 2;
# for (i = 0; i <= 16; i++)
# {
# ... calculate n from i
# ... print i and n

# Algorithm taken from https://en.wikipedia.org/wiki/Hammering_weight

# tmp = i;
#i = i >> 1;
#i = i & 0x55555555;
#i = tmp - i;
#tmp = i;
#i = i >> 2;
#i = i & 0x33333333;
#tmp = tmp & 0x33333333;
#i = tmp + i;
#tmp = i >> 4;
#i = i + tmp;
#i = i & 0x0F0F0F0F;
#i = i * 0x01010101;
#i = i >> 24;
# }

# register assignments
# $s0 i
# $s1 n
# $s2 tmp
# $s3 = 1431655765
# $s4 = 858993459
# $s5 = 252645135
# $s6 = 16843009
# $a0 argument to Print_integer, Print_string
# add to this list if you use any other registers

# initialization
li $s1, 2 # n = 2

# converted hex values
li $s3, 1431655765
li $s4, 858993459
li $s5, 252645135
li $s6, 16843009

# for (i = 0; i <= 16; i++)
li $s0, 0 # i = 0
bgt $s0, 16, bottom
top:
# calculate n from i
# Your part starts here
add $s1, $zero, $s0
add $s2, $zero, $s0
sra $s1, $s1, 1
and $s1, $s1, $s3
sub $s1, $s2, $s1
add $s2, $zero, $s1
sra $s1, $s1, 2
and $s1, $s1, $s4
and $s2, $s2, $s4
add $s1, $s2, $s1
sra $s2, $s1, 4
add $s1, $s1, $s2
and $s1, $s1, $s5
mult $s1, $s6
#add $s1, $zero, lo
mflo $s1
sra $s1, $s1, 24

# Your part ends here

# print i and n
move $a0, $s0 # i
jal Print_integer
la $a0, sp # space
jal Print_string
move $a0, $s1 # n
jal Print_integer
la $a0, cr # newline
jal Print_string

# for (i = 0; i <= 16; i++)
add $s0, $s0, 1 # i++
ble $s0, 16, top # i <= 16
bottom:

la $a0, done # mark the end of the program
jal Print_string

jal Exit # end the program, no explicit return status


# switch to the Data segment
.data
# global data is defined here
sp:
.asciiz " "
cr:
.asciiz "\n"
done:
.asciiz "All done!\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
# Wrapper functions around some of the system calls
# See P&H COD, Fig. A.9.1, for the complete list.

# switch to the Text segment
.text

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

.globl Exit
Exit: # end the program, no explicit return status
addi $v0, $zero, 10
syscall
jr $ra

.globl Exit2
Exit2: # end the program, with return status from register a0
addi $v0, $zero, 17
syscall
jr $ra
