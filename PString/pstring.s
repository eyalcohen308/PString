    .data
    .section    .rodata
str_len:
	.string	"first pstring length: %d, second pstring length: %d\n"
str_invalid_input:
	.string	"invalid input!\n"
  .align 8  # Align address to multiple of 8
  .text
  
.global main
.global	pstrlen
	.type	pstrlen, @function
#*****************************************************************************************************
#function: pstrlen.
#input: rdi:string str1.
#output: return size of str1.
#*****************************************************************************************************
pstrlen:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,     %rbp	#create the new frame pointer
        
	movsbq	(%rdi),   %rax	#return the first byte of the pstring- the length

	movq	%rbp,     %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)

#****************************************************************************************************
#function 1: print_lengths(50).
#input: rdi:int option = 50 rsi: string str1, rdx: string str2
#output: print size of string 1, and string 2.
#****************************************************************************************************
.global	print_lengths
	.type	print_lengths, @function
print_lengths:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,     %rbp	#create the new frame pointer
        	movq	%rsi,     %rdi	#move the second parameter to first parameter of function
        pushq    %rdx            #save rdx colee
        
        call    pstrlen
        
        popq	%rdi	        #move privius %rdx to first argument, rdi before calling pstrlen
        movq	%rax,      %r8	#save the size of first string.
        call    pstrlen          # find the second string size.    
          
        movq    $str_len, %rdi   # prepare the argumetns for printf, first is the string.
        movq    %r8, %rsi        #second parameter, string 1 size.
        movq    %rax,%rdx        # third parameter, string2 size.
        movq    $0,%rax          # zero the rax, like should to.
        call    printf           #call printf
        movq    $0,%rax          # zero the rax, like should to.
	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)
             
.tempPStrlen:
#get the first value of rdi(first char in array, size value)
    movsbq (%rdi), %rax
    ret
    
#****************************************************************************************************************
#function 3: replaceChar(51).
#input:rdi:string str1, rsi:char ch1 - char we want to replace, rdx:char ch2 - char to replace to.
        #pointer to the array,first argument, p=arr.
#output: print size of string 1, and string 2.
#*******************************************************************************************************************
.global	replaceChar
	.type	replaceChar, @function
replaceChar:
        #rdi/p - array pointer, rsi/ch1 - char we want to replace, rdx/ch2 - char to replace to,.
        #pointer to the array,first argument, p=arr.
        
        pushq	%rbp		   #save the old frame pointer
	movq	%rsp,	%rbp	   #create the new frame pointer

        movq     %rdi,   %rax       #save the pointer assing it to the return value.
        leaq     1(%rdi), %rdi      #skip the first char, represent size.
        cmpb     $0, (%rdi)        #check if the char is '\0', and end the loop if not, arr[i]=='\0' end loop.
        je       .EndLoop1
        
.StartLoop1:
        cmpb      (%rdi),%sil       # if(arr[i]==ch1)
        jne       .EndIf1
        movb      %dl, (%rdi)      # arr[i] = ch2
        
.EndIf1:
        leaq      1(%rdi), %rdi     #p=p+1: p<-arr+1
        
        cmpb      $0, (%rdi)       #check if to start again.
        jne       .StartLoop1
        
.EndLoop1:
        	movq	  %rbp, %rsp	  #restore the old stack pointer - release all used memory.
	popq	  %rbp		  #restore old frame pointer (the caller function frame)
	ret


#**********************************************************************************
#pstrjcpy function 3(52)
#input: rdi - string str1, rsi - string str2, rdx - int index i, rcx - int index j.
#output: copy from str1 to str2 from index i to index j.
#*************************************************************************************
.global	pstrjcpy
	.type	pstrjcpy, @function
pstrjcpy:
	pushq	  %rbp		   #save the old frame pointer
	movq	  %rsp,   %rbp	   #create the new frame pointer
        pushq   %rdi                #if error, we can save str1.
        #validity checks:
        cmpl     %edx,  %ecx                  #check if i and j
        jl      .inValidInput1      # if i>j error.
        cmpl     $0,    %edx            #check if i and j
        jl      .inValidInput1      # if i< 0 error.
        cmpb     %cl,(%rdi)        #check  j and str1.length()
        jle     .inValidInput1      # if j>= str1.length(), error.
        cmpb     %cl,(%rsi)        #check  j and str2.length()
        jle     .inValidInput1      # if j>= str1.length(), error.
        jmp     .ValidInput1
        
.inValidInput1:
        # print error if invalid.
        movq    $str_invalid_input, %rdi         #preapre to call print("invalid input")
        movq    $0,                 %rax                         #zero rax
        call    printf                          #print
        xorq    %rax,    %rax
        popq     %rax                     #return rdi to rax.
        jmp     .EndFunction1
        
.ValidInput1:
	popq    %rdi                      #get out of the stack.
        movq    %rdi, %rax                # save the pointer to str1.
        leaq    1(%rdi,%rdx), %rdi        # update str1 pointer by i size +1 becuase first byte its str1 size
        leaq    1(%rsi,%rdx), %rsi        # update str2 pointer by i size +1 becuase first byte its str2 size
        
.ForLoop2:
        movb    (%rsi), %r9b               # temp = str2[i]
        movb    %r9b,(%rdi)                # str1[i] = temp
        incl    %edx                      # i++
        incq    %rdi                      #p_str1 =p_str1 +1
        incq    %rsi                      #p_str2 =p_str2 +1
        cmpl    %ecx,%edx                 #check i and j.
        jle     .ForLoop2
        
.EndFunction1:
        	movq	%rbp,%rsp	        #restore the old stack pointer - release all used memory.
	popq	%rbp		        #restore old frame pointer (the caller function frame)
	ret

#***************************************************************************************************************
#function 4: swapCase(53)
#input:rdi - string str1.
#output: same string but all capital letters are lower and opposite.
#switch between Captial letters and lawer letter.
#***************************************************************************************************************

.global	swapCase
	.type	swapCase, @function
swapCase:
        pushq	%rbp		   #save the old frame pointer
        movq    %rsp, %rbp	   #create the new frame pointer
        
        movq    %rdi,  %rax         #save the string to the return value.   
        leaq    1(%rdi),  %rdi      
        movq    $1,    %rsi            # i=1.skip the first byte size.
        cmpb    $0,    (%rax)           #check size and 0
        jle     .done3              # if size is size <= 0 finish.
        
.ForLoop3:
        cmpb     $65,  (%rdi)         # if arr[i] <65
        jl      .afterIfs1          # not letter do nothing.
        cmpb     $90,(%rdi)         # if arr[i] >90
        jg       .SecondIf
        addb     $32, (%rdi)        #if(65<=arr[i]<=90-> arr[i]+=32-> make capital letter.       
        jmp      .afterIfs1     
.SecondIf:    
        cmpb     $97,(%rdi)
        jl       .afterIfs1          # if 90<arr[i]<97
        cmpb     $122,(%rdi)        
        jg       .afterIfs1          # If arr[i]>122 do nothing
        subb     $32,(%rdi)          # if 97<=arr[i]<=122 -> make it lower case.
.afterIfs1:
        incl     %esi               # i++
        incq     %rdi               #p = p+1
        cmpl     $0,(%rdi)        # check i?size
        jne     .ForLoop3
.done3:
        	movq	%rbp,%rsp	        #restore the old stack pointer - release all used memory.
	popq	%rbp		        #restore old frame pointer (the caller function frame)
	ret

#****************************************************************************************************************
#function 5:pstrijcmp(54)
#input:rdi - string str1 , rsi - string str2 ,rdx - int index i, rcx - int index j.
#output: 1 if str1 bigger, -1 if str2 bigger 0 if equal, by helixographic order.
#****************************************************************************************************************
.global	pstrijcmp
	.type	pstrijcmp, @function
pstrijcmp:    
	pushq	%rbp		   #save the old frame pointer
	movq	%rsp,	%rbp	   #create the new frame pointer
        #validity checks:
        cmpl     %edx,  %ecx        #check if i and j
        jl      .inValidInput2      # if i>j error.
        cmpl     $0,    %edx            #check if i and j
        jl      .inValidInput2      # if i< 0 error.
        cmpb     %cl,(%rdi)        #check  j and str1.length()
        jle     .inValidInput2      # if j>= str1.length(), error.
        cmpb     %cl,(%rsi)        #check  j and str2.length()
        jle     .inValidInput2      # if j>= str1.length(), error.
        jmp     .ValidInput2
.inValidInput2:
        # print error if not valid.
        movq    $str_invalid_input,%rdi   #preapre to call print("invalid input")
        movq    $0,%rax                   #zero rdx.
        call    printf                    #print
        movq    $0,%rax                   # zero the rax, like should to.
        xorq    %r9,%r9                   #prepare the -2 return value.
        movq    $-2,%r9                   #save -2 in r9.
        movq    %r9,%rax                  # return -2 becuase invalid input.
        jmp     .endloop5
.ValidInput2:
        
        movq    $0, %rax                   # put zero on rax, return value if every thing ok.
        leaq    1(%rdi,%rdx), %rdi        # update str1 pointer by i size +1 becuase first byte its str1 size
        leaq    1(%rsi,%rdx), %rsi        # update str2 pointer by i size +1 becuase first byte its str2 size
.ForLoop4:
        movq    (%rsi),%r9
        cmpb    (%rdi),%r9b             # compare between str1[i], str2[i].
        jg      .secondBigger
        cmpb    (%rdi),%r9b             # compare between str1[i], str2[i].
        jl      .firstBigger
        cmpb    (%rdi),%r9b             # compare between str1[i], str2[i].
        je      .afterIfs2
.firstBigger:
        movq    $1,%rax                   # str1 is bigger, return 1.
        jmp     .endloop5         
 .secondBigger:
        movq    $-1,%rax                   # str1 is bigger, return -1.
        jmp     .endloop5                
.afterIfs2:
        incq    %rdx                      # i++
        incq    %rdi                      #p_str1 =p_str1 +1
        incq    %rsi                      #p_str2 =p_str2 +1
        cmpl    %ecx,%edx                 #check i and j.
        jle     .ForLoop4
.endloop5:
        	movq	%rbp,%rsp	        #restore the old stack pointer - release all used memory.
	popq	%rbp		        #restore old frame pointer (the caller function frame)
	ret

