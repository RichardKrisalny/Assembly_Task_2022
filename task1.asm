# Richard Krisalny    204910764
###################### data ##################################
.data
num1: .word -8 , num3
num2: .word 1988 , 0
num3: .word -9034 , num5
num4: .word -100 , num2
num5: .word 1972 , num4
psik:    .asciiz ","
sep:    .asciiz "  "
test:    .asciiz "test\n"
sum:    .asciiz "\nsum = "
sumfor:    .asciiz "\nsum of %4 = "
###################### text ##################################
.text
.globl main   
main:
	     li $s1,-8# s0 is the mask
	     srl $s1,$s1,1# mask mask 011....1100
	     li $s2,3# s2 is the mask for base 4
	     li $s3,-1# s2 is the mask for chanch negativ
	     srl $s3,$s3,1# mask mask 011....1111
             la     $s0,num1       # get pointer to head
loop:     
             beqz   $s0,done       # while not null
	     lw     $t0,0($s0) 
	     add $t1,$t1,$t0     #calc sum
	     or $t3,$s1,$t0#chck if num%4=0
	     beq $t3, $s1, sum4
next:
             lw     $s0,4($s0)     #   get next
             j      printInBase4 
sum4:  
             add $t2,$t2,$t0        
	     j     next       
done:     
          la     $a0,sum
          li     $v0,4
          syscall
          move     $a0,$t1      # print sum
          li     $v0,1
          syscall   
          la     $a0,sumfor       
          li     $v0,4
          syscall
          move     $a0,$t2     #print sum of nums %4
          li     $v0,1
          syscall           
          li     $v0,10         # END
          syscall   
printInBase4:
             move     $t5,$t0
 loop2:
 	      beqz   $t5,printNum       #if the num is end go to loop
             or  $t6,$t5,$s3#chack if num is negativ
             beq $t6, $s3, loop3
             sub $t5,$t5,1
             not $t5,$t5#make positiv
loop3:   
	     and $t4,$s2,$t5		
	     addi $sp,$sp,-4# write in stack
	     sw $t4,0($sp)
	     add $t8,$t8,1# caunt haw many numbers in stack
             srl $t5,$t5,2    #take texst 2 bits and start agin
             j loop2
printNum:
	    beqz   $t8,printPsik
	    lw $a0 0($sp)# print the num from the stack
	    li     $v0,1
            syscall  
            addi $sp,$sp,4
	    sub $t8,$t8,1
	    j   printNum
printPsik:
             la     $a0,psik
             li     $v0,4
             syscall
             j loop
###################### end ##################################	                
          
