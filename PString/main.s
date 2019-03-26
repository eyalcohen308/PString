# 308347244 Eyal Cohen
    .data
    .section    .rodata
oper:               .string "%hhd"
pstr:               .string "%s"
size:               .string "%hhd"
    .text

.global main
    .type   main, @function
    main:
        movq    %rsp, %rbp              # for correct debugging
        pushq   %rbp                    # saving the return address
        movq    %rsp, %rbp              # for correct debugging
    
    # saving callee registers: stack < %rbx < %r12 < %r13 < %r14 < %r15
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14
        pushq   %r15
    
        xorq    %rax, %rax              # initialize %rax
    
    # getting the first string
        leaq    -1(%rsp), %rsp          # allocating one byte for the first size string char.
        movq    %rsp, %rsi              # %rsi is the address of input
        movq    $size, %rdi             # set registers before calling scanf. first the string input.
        call    scanf
        xor     %r12, %r12
        movb    (%rsp), %r12b           # %r12 = str1 size.
    
        decq    %rsp
        movq    %rsp, %r15              # saving the end of the string
        subq    %r12, %rsp              # allocating place in stack to str1 + one byte for \0.
    
        movq    %rsp, %rsi              # prepare calling scanf, now rsi point to the place str1 will be.
        movq    $pstr, %rdi
        xor     %rax, %rax
        call    scanf                   # getting the first string, overriding the size (saved in %r12)
        movb    $0, (%r15)              # put \0 to to end of str1.
        movq    %rsp, %r14              # %r14 = str1 (pointer to first char).
        decq    %r14
    
        decq    %rsp
        movb    %r12b, (%rsp)            # assigning the size of the string after the string
    
    # getting the second string
        xor     %rax, %rax
        leaq    -1(%rsp), %rsp          # allocating 1 byte for the string size
        movq    %rsp, %rsi              # %rsi is the address of input
        movq    $size, %rdi             # setting %rdi to byte input
        call    scanf
        xor     %r13, %r13
        movb    (%rsp), %r13b           # %r13 now has the size of the second string
    
        decq    %rsp
        movq    %rsp, %rbx              # saving the egde of the string
        subq    %r13, %rsp              # allocating place in the stack for the string + 1
    
        movq    %rsp, %rsi              # %setting %rsi as the address of the input
        movq    $pstr, %rdi
        xor     %rax, %rax
        call    scanf
        movb    $0, (%rbx)              # assigning \0 to the end of the string
        movq    %rsp, %r15
        decq    %r15                    # %r15 = str2 (pointer to str2)

        decq    %rsp
        movb    %r13b, (%rsp)            # assigning the size of the string after the string

    
    # getting the function operation number
        xor     %rax, %rax
        leaq    -1(%rsp), %rsp
        movq    %rsp, %rsi
        movq    $oper, %rdi             
        call    scanf                   # getting the number of function
        xor     %rdi, %rdi
        movq    (%rsp), %rsi
        movb    %sil, %dil              # set %rdi as the function num - first argument to run_func
    
        xor     %rax, %rax
        movq    %r14, %rsi              # set %rsi as the first string - second argument to run_func
        movq    %r15, %rdx              # set %rdx as the second string - third argument to run_func
        call    run_func
    
    # restoring callee registers: %r15 > %r14 > %r13 > %r12 > %rbx > stack
        movq    -8(%rbp), %rbx
        movq    -16(%rbp), %r12
        movq    -24(%rbp), %r13
        movq    -32(%rbp), %r14
        movq    -40(%rbp), %r15
    
        movq    %rbp, %rsp              # restoring the return address
        popq    %rbp                    # pop it out of the stack
        ret

