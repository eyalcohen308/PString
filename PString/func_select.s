    .data
    .section    .rodata

str_len:
	.string	"first pstring length: %d, second pstring length: %d\n"
str_52_and_53:
	.string "length: %d, string: %s\n"
str_scanf:
	.string	"%d"
str_cmp:
	.string	"compare result: %d\n"
str_replace_char:
	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
str_invalid:
	.string "invalid option!\n"
scanf_swap_char:	   .string " %c %c"
scanf_Case52:	   .string " %d %d"	
  .align 8  # Align address to multiple of 8
.L1:
  .quad .Case50 # Case 50: loc_A
  .quad .Case51 # Case 51: loc_def
  .quad .Case52 # Case 52: loc_B
  .quad .Case53 # Case 53: loc_C
  .quad .Case54 # Case 54: loc_D
  .quad .Case_Defult # Case 55: 
  
    .text



#*******************************************************************************
# function name:run_func.
# input: %rdi = int choice, %rsi: string 1, %rdx: string 2.
# output: depand on the choice.
#******************************************************************************
.global	run_func
	.type	run_func, @function
run_func:
  # Set up the jump table access
        pushq	    %rbp		    #save the old frame pointer
        movq	    %rsp,     %rbp   #create the new frame pointer
    
        leaq     -50(%rdi),%r10     # Compute function choice.
        cmpq      $4,%r10           # Compare and find which case
        jg       .Case_Defult       # if >, goto default-case
        cmpq      $0,%r10           # Compare and find which case
        jl       .Case_Defult       # if >, goto default-case
        jmp      *.L1(,%r10,8)      # Goto jt[xi]
	
         
        # Case 50
.Case50:                                 # print size of str1, str2. input for printlengths: rdi - 50, rsi - str1, rdx - str2.s
        call      print_lengths     # call function that print the size of str1, and str2.
        jmp      .Done
          
.Case51:                                     # print size of str1, str2.
     
        	addq	$-2, %rsp		#increase stack by two byte - for the chars
        pushq    %rdx                     # save str2 in stack
        pushq    %rsi                     # save str1 in stack
	movq	$scanf_swap_char, %rdi	#getting old and new char
	leaq	16(%rsp), %rsi		#address of old char
	leaq	17(%rsp), %rdx		#address of new char
	movq	$0, %rax

	call	scanf

	popq	%rdi		        #retore str1 to %rdi
        movq     %rdi,%r12               #save str1 to %r12
	movq	8(%rsp), %rsi		#save and prepare the old char argument
	movzbq	%sil, %rsi
	movq	9(%rsp), %rdx		#save and prepare the new char argument
	movzbq	%dl, %rdx
	call	replaceChar
	popq	%rdi		         #%rdi = str2
        movq     %rdi, %r13               #save rdi for printing, str2!!!
	movq	(%rsp), %rsi		#save and prepare the old char argument
	movzbq	%sil, %rsi
	movq	1(%rsp), %rdx		#save and prepare the new char argument
	movzbq	%dl, %rdx
	call	replaceChar

#popping chars from the stack
	movq	(%rsp), %rsi              #move the old char to first argument of the printf.
	movzbq	%sil, %rsi                #make it only one byte.
	leaq	1(%rsp), %rdx             #add by 1 to skip print the size of string.
	movq	(%rdx), %rdx              #save the new char as one byte.
	movzbq	%dl, %rdx                 # make it 1 byte.
	movq	$str_replace_char, %rdi
	addq	$1, %r12		        #increase by 1 because of the first byte that is size of string
	movq	%r12, %rcx
	addq	$1, %r13		        #increase by 1 because of the first byte that is size of string
	movq	%r13, %r8
	movq	$0, %rax
	call	printf
        movq	$0, %rax
	addq	$2, %rsp		        #decrease stack by two byte - for the chars


          jmp      .Done
.Case52:                                  # print size of str1, str2.
        addq	$-8, %rsp		#increase stack by two byte - for the chars
        pushq    %rdx                     # save str2 in stack
        pushq    %rsi                     # save str1 in stack
	movq	$scanf_Case52, %rdi	#getting old and new char
	leaq	16(%rsp), %rsi		#address of first int
	leaq	20(%rsp), %rdx		#address of new second
	movq	$0, %rax

	call	scanf


        popq	%rdi		        #retore str1 to %rdi
        movq     %rdi,%r12               #save str1 to %r12
        popq	%rsi		         #%rdi = str2
        movq     %rsi, %r13               #save rdi for printing, str2!!!
	movl	(%rsp), %edx		#save and prepare first int argument
	#movzbl	 %edx, %rdx
	movl	4(%rsp), %ecx		#save and prepare the second int argument
	#movzbl	%ecx, %rcx               #now we are ready to call function with parameters(string str1,string str2,int i,int j)


	call	pstrjcpy


#popping chars from the stack

	movq	$str_52_and_53, %rdi            #first argument.
        movq     (%rax), %rsi             #size of string1, second argument.
        movzbq   %sil,%rsi                #pump with zeros.
        addq	$1, %rax		        #increase by 1 because of the first byte that is size of string
        movq     %rax,%rdx                #third paramter. the string2.
        
	movq	$0, %rax
	call	printf
        movq	$0, %rax
	addq	$8, %rsp		        #decrease stack by two byte - for the chars.





###############second print################################3
	movq	$str_52_and_53, %rdi            #first argument.
        movq     (%r13), %rsi             #size of string1, second argument.
        movzbq   %sil,%rsi                #pump with zeros.
        addq	$1, %r13		        #increase by 1 because of the first byte that is size of string
        movq     %r13,%rdx                #third paramter. the string2.
        
	movq	$0, %rax
	call	printf
        movq	$0, %rax
	addq	$2, %rsp		        #decrease stack by two byte - for the chars.



        jmp      .Done
          
.Case53:                                          # print size of str1, str2.
        pushq     %rdx                          #save str2.
          
        movq      %rsi, %rdi                     #prepare the input for function. input: str1.
     
        call      swapCase                       # call function that swap lower and capital letters.
        #prepare for printing.
        movq	$str_52_and_53, %rdi            #first argument. print.
        movq     (%rax), %rsi                    #size of string1, second argument.
        movzbq   %sil,%rsi                       #pump with zeros.
        addq	$1, %rax		                #increase by 1 because of the first byte that is size of string
        movq     %rax,%rdx                       #third paramter. the string2.
        
	movq	$0, %rax
	call	printf
        movq	$0, %rax
        
        ###prepare for second printing.########
        popq    %rdi                            #save str2 in rdi.
        call      swapCase                       # call function that swap lower and capital letters.
        #prepare for printing.
        movq	$str_52_and_53, %rdi            #first argument. print.
        movq     (%rax), %rsi                    #size of string1, second argument.
        movzbq   %sil,%rsi                       #pump with zeros.
        addq	$1, %rax		                #increase by 1 because of the first byte that is size of string
        movq     %rax,%rdx                       #third paramter. the string2.
        
	movq	$0, %rax
	call	printf
        movq	$0, %rax
           
        jmp      .Done
          
.Case54:                                  # print size of str1, str2.
        addq	$-8, %rsp		#increase stack by two byte - for the chars
        pushq    %rdx                     # save str2 in stack
        pushq    %rsi                     # save str1 in stack
	movq	$scanf_Case52, %rdi	#getting old and new char
	leaq	16(%rsp), %rsi		#address of first int
	leaq	20(%rsp), %rdx		#address of new second
	movq	$0, %rax

	call	scanf


        popq	%rdi		        #retore str1 to %rdi
        movq     %rdi,%r12               #save str1 to %r12
        popq	%rsi		         #%rdi = str2
        movq     %rsi, %r13               #save rdi for printing, str2!!!
	movl	(%rsp), %edx		#save and prepare first int argument
	#movzbl	 %edx, %rdx
	movl	4(%rsp), %ecx		#save and prepare the second int argument
	#movzbl	%ecx, %rcx               #now we are ready to call function with parameters(string str1,string str2,int i,int j)


	call	pstrijcmp


#popping chars from the stack
        movq     $str_cmp,%rdi          #"compare result: %d\n"    
        xorq     %rsi, %rsi             #clear %rsi.
        movq     %rax, %rsi             #size of string1, second argument.
                                          #prepre  to print  "compare result: %d\n"
	movq	$0, %rax
	call	printf
        movq	$0, %rax
        addq	$8, %rsp		        #decrease stack by two byte - for the chars.
        jmp      .Done
                        
          # default case, error.
.Case_Defult:
        movq    $str_invalid,%rdi   #preapre to call print("invalid option")
        movq    $0,%rax          # zero the rax, like should to before print.
        call    printf           #call printf
        movq    $0,%rax          # zero the rax, like should to.
.Done:
	movq	%rbp,     %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)

        
