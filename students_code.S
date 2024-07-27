.global count_above
#############DO NOT FORGET TO CLOSE THE FILE############

count_above: 
#prolog
  pushq %rbp 
  movq %rsp, %rbp
  #local variables
  subq $64, %rsp

  #function`s body
  movb %dil, -1(%rbp)   # sperator
  movq %rsi, -8(%rbp)   #limit

  movq $0, %rax #resitting the value of rax t
  #PRE-CALL
  #there is nothing to do :)
  call get_path
  #POST-CALL
  movq %rax, -16(%rbp) #path file

  #open file for reading
  movq %rax, %rdi
  movq  $2, %rax
  xor %rsi, %rsi //open for reading only
  syscall
  testq %rax, %rax
  js FAIL_HW3
  movq %rax, -24(%rbp) #  file descriptor

  xor %r15, %r15 #  R15 is a counter
  xor %r14, %r14 #  R14 id an index for array
  movb -1(rbp), $ r13b  # sperator
READ:
    #reading from the file
    xor %rax, %rax       # sys_read line`s number
    movq -64(%rbp), rsi  #  address for the array that will incloude the string that we will be reading
    leaq -24(%rbp), %rdi #  file descriptor
    xor %rdx, %rdx
    movq $1, %rdx # we need to read 1 byte
    syscall
    cmp $0, %rax  # if EOF CHECK THAT LAST NUMBER
    je Check_NUMBERLast

    movb (%rsi), %r12b
    cmp %r13b, %r12b
    je Check_NUMBER

    movb %r12b, -64(%rbp, %r14)  #save the character in numer array
    inc %r14
    cmp $19, %r14 # if we reached the maximum length of a number we shoud check if it is greater of the limit we were given
    jbe READ

 Check_NUMBER:    
    #first we need to add a null terminator to the char* number
    movb $0, -64(%rbp, %r14)
    # PRE-CALL
    lea -64(%rbp), %rdi 
    #call
    call atam_atol
    movq %rax , %r11 #save number in R11

    #now we need to check if the number we got is greater than limit
    movq -8(%rbp) , %r10
    cmp %r10,%r11
    jg    ADD_TO_COUNT
    xor %r14, %r14
    jmp READ

ADD_TO_COUNT: 
    inc %r15
    xor %r14, %r14
    jmp READ

Check_NUMBERLast:
      #first we need to add a null terminator to the char* number
    movb $0, -64(%rbp, %r14)
    # PRE-CALL
    lea -64(%rbp), %rdi 
    #call
    call atam_atol
    movq %rax , %r11 #save number in R11

    #now we need to check if the number we got is greater than limit
    movq -8(%rbp) , %r10
    cmp %r10,%r11
    jg    ADD_TO_COUNTLast
    jmp END_HW3
ADD_TO_COUNTLast:
    inc %r15
    jmp END_HW3

FAIL_HW3:
  #close file
  movq -24(%rbp), %rdi
  movq $3, %rax
  syscall
  # Return -1 to indicate failure
  movq $-1, %rax

  # Epilogue
  leave
  ret

END_HW3:
  #close file
  movq -24(%rbp), %rdi
  movq $3, %rax
  syscall
  # Return -1 to indicate failure
  movq $r15, %rax

  # Epilogue
  leave
  ret
  
