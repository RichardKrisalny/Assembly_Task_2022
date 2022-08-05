# Richard Krisalny    204910764
###################### data ##################################
.data
CharStr: .asciiz "AEZKLBXWZXYALKFKWZRYLAKWLQLEK"
			
ResultArray: .space 26
psik:    .asciiz ","
enter:    .asciiz "\n"
printBigestNum:    .asciiz "\n the num of Rehearsals is: "
printascii:    .asciiz "\n the ascii code of the char is: "
printchar:    .asciiz "\n The character that appears the most times is: "
new:		 .asciiz"\nthe new sreing is: \n"
strEnd:		 .asciiz"\nthe sreing is empti \n"
again:		.asciiz"\ndo you want start the program again with new string?\n1=Yes\n0=NO: \n"
###################### text ##################################
.text
.globl main   
main:
 		la     $a0,CharStr
 		la     $a1,ResultArray
 		jal	char_occurrences 
 		move	$s0,$v0	#rememder the return valus
 		move	$s1,$v1
 	        la     $a0,enter     # print \n
     	        li     $v0,4
      	        syscall 
 		jal	print_Char_by_occurrences
 		la     $a0,CharStr
 		move	$a1,$s0	#restore the return valus 	
 		jal		delete		
 		la     $a0,CharStr
 		lb 	$s1,0($a0)
 	        beqz   $s1,endProgram#if the string is 0 chars
 	        la     $a0,again     # print a question
     	        li     $v0,4
      	        syscall       
 	        li     $v0,5	#Waiting for an answer
 	        syscall    
 	        bnez   $v0,clearArray#run again
endProgram: 
	        la     $a0,strEnd    # print end
     	        li     $v0,4
      	        syscall                                                                                                                 
		li     $v0,10         # END
		syscall   
clearArray:	#procedur to clin the arry
 		la     $a1,ResultArray
 		li	$s3,0
 		li	$s5,26      
clinLoop:
		beq	$s5,$s3,main
		add	$s6,$a1,$s3
		li	$t7,0
		sb	$t7,0($s6)
		addi	$s3,$s3,1
		j	clinLoop		   
######################-1&2-#################################### 
char_occurrences:
		li	$t4,0	#caunter for chars
		add	$t4,$t4,$a0	#the place in memory of the char
loop1:
		lb  $t1,0($t4)	#get char from string
		beqz   $t1,printArry 
		sub $t0,$t1,65	#write in t0 the index in arry
 		add $t3,$a1,$t0	#write in t3 the place in memory
                lb $t2,0($t3)	#read from arry
                addi $t2,$t2,1#t2++
                sb $t2,0($t3)	#write in arry  
                addi	$t4,$t4,1	#t4++
                j loop1
 printArry:      
 		li $t5,26
 		li	$t4,0	#caunter for chars
 		li	$t6,0	#caunter for chars
		add	$t4,$t4,$a1	#the place in memory of the char
next:	
		beq $t5,$t6,theBigest
		lb	$t7,0($t4)
		move     $a0,$t7      # print sum
     	        li     $v0,1
      	        syscall 
                la     $a0,psik
                li     $v0,4
                syscall
		addi	$t4,$t4,1		#t4++
		addi	$t6,$t6,1		#t6++
		j next   
theBigest:
		li $t4,0
		li	$t0,25	#caunter to start in tne end of arry
		li $t3,0		#sum
theBigestLoop:
		li $t9,-1
		beq   $t0,$t9,dane	#if the caunter=0 end the procedur
		add	$t1,$t0,$a1	#the plase in mamory
		lb	$t2,0($t1)		#load the num from arry
		bgt	$t2,$t3,sumUP #if t2>t3
		sub	$t0,$t0,1	#t0--
		j	theBigestLoop		
sumUP:	
		move	$t4,$t0#update the num
		move	$t3,$t2#update the ascii
		sub	$t0,$t0,1	#t0--
		j	theBigestLoop
dane: 	
		addi $t4,$t4,65#t4=ascii code
		la $a0,printascii#print ascii
		 li     $v0,4
      	        syscall  
		move     $a0,$t4     # print ascii
     	        li     $v0,1
      	        syscall  
		la $a0,printBigestNum
		 li     $v0,4
      	        syscall  
		move     $a0,$t3     # print sum
     	        li     $v0,1
      	        syscall  
		la $a0,printchar#print char
		 li     $v0,4
      	        syscall       	    
		move     $a0,$t4     # print char
     	        li     $v0,11
      	        syscall 
      	        
      	        move     $v0,$t4 #return ascii
      	        move     $v1,$t3 #return num of rehearsals
       	jr	$ra	#return to caller        
######################-3-#################################### 
print_Char_by_occurrences:  
		li	    	   $t2,0#caunter
		li	    	   $t5,26#end of arry
PL:
		beq	$t2,$t5,sof# if the arry is end
                add	$t0,$a1,$t2 	#adress + caunter
                lb	$t1,0($t0)  	#loud num
                bnez   $t1,print	#if this char more then 0 times
                addi	$t2,$t2,1	#t2++
                j	PL
print:
		move $t3,$t1#get the times
		addi	$t4,$t2,65#get the ascii code
printLoop:
                beqz $t3,PL1	#if we print many times we want
                move     $a0,$t4     # print char
     	        li     $v0,11
      	        syscall 
      	        subi	$t3,$t3,1 #t3--
      	        j	printLoop
PL1:
                la     $a0,enter     # print \n
     	        li     $v0,4
      	        syscall      	        
      	        addi	$t2,$t2,1
      	        j	PL    	        
sof:     	        
        	jr	$ra	#return to caller  
######################-4-#################################### 
delete:
		addi $sp,$sp,-4#save the caller
		sw $ra,0($sp)
		move $t0,$a1#the ascii code
		#addi	$t0,$t0,65
     	        li	$t3,-1	#caunter
     	        move $t9,$a0
delLoop:
		addi $t3,$t3,1	#t3++
     	        add $t2,$t9,$t3	#adress
     	        lb $t4,0($t2)    #get the char
     	        beqz   $t4,endDelete#if the string is end
     	        bne	$t4,$t0,delLoop	#if the char is not the popular one
     	        jal reduction# while
     	        j delLoop
reduction:  
		li $t5,0	#caunter
		move $t6,$t2# the plase
rLoop:
		addi $t8,$t6,1#the text place
		lb $t7,0($t8)# chanch the charcters in string
		sb	$t7,0($t6)# move right one after one
		beqz   $t7,return# string end
		addi $t6,$t6,1#t6++
		j rLoop
return:
		 jr	$ra   		   	         	        
endDelete:   
		lw $ra,0($sp)
		addi $sp,$sp,4 	 #get the caller adress  
		la $a0,new
		 li     $v0,4
      	        syscall  
		 la    $a0,CharStr     # print the new string
     	        li     $v0,4
      	        syscall           
      	       jr	$ra	#return to caller                                       
###################### end ##################################	 
