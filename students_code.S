.global count_above
#############DO NOT FORGET TO CLOSE THE FILE############
.section .text
count_above:
    # Prologue
    pushq %rbp 
    movq %rsp, %rbp
    subq $56, %rsp  # Allocate space for local variables

    # Save arguments on the stack
    movq %rdi, -8(%rbp)   # Save separator
    movq %rsi, -16(%rbp)   # Save limit

    xor %rax, %rax # Reset rax

    # Get file path using get_path
    call get_path

    # Open file for reading
    movq %rax, %rdi
    movq $2, %rax
    xor %rsi, %rsi  # Open for reading only
    xor %rdx, %rdx
    syscall
    testq %rax, %rax
    js FAIL_HW3
    movq %rax, -24(%rbp) # Save file descriptor
    movq %rax, %rdi

    # Initialize counters and indices
    xor %r15, %r15 # R15 is the counter
    xor %r14, %r14 # R14 is the index for the array
    movq -8(%rbp), %r13  # Save separator

READ:
    # Read a character from the file
    xor %rax, %rax       # sys_read system call number
    movq -24(%rbp), %rdi # File descriptor
    leaq -56(%rbp), %rsi # Address for the array to read into
    movq $1, %rdx        # Number of bytes to read (1 byte)
    syscall
    cmpb $1, %al         # Check for EOF
    je continue
    jmp Check_NUMBERLast  # If EOF, check the last number
continue:
    movb (%rsi), %r12b   # Load the character
    cmpb %r13b, %r12b     # Compare with separator
    je Check_NUMBER      # If separator, process the number

    movb %r12b, -48(%rbp, %r14,1)  # Save the character in number`s array
    inc %r14

    jmp READ
Check_NUMBER:    
    # Add null terminator to the char* number
    movb $0, -48(%rbp, %r14,1)
    # Convert string to number
    lea -48(%rbp), %rdi 
    call atam_atol
    movq %rax, %r11      # Save number in R11

    # Check if the number is greater than limit
    movq -16(%rbp), %r10
    cmp %r10, %r11
    jg ADD_TO_COUNT
    xor %r14, %r14
    jmp READ

ADD_TO_COUNT: 
    inc %r15
    xor %r14, %r14
    jmp READ

Check_NUMBERLast:
    # Add null terminator to the char* number
    movb $0, -48(%rbp, %r14)
    # Convert string to number
    lea -48(%rbp), %rdi 
    call atam_atol
    movq %rax, %r11      # Save number in R11

    # Check if the number is greater than limit
    movq -16(%rbp), %r10
    cmp %r10, %r11
    jg ADD_TO_COUNTLast
    jmp END_HW3

ADD_TO_COUNTLast:
    inc %r15
    jmp END_HW3

FAIL_HW3:
    # Close file
    movq -24(%rbp), %rdi
    movq $3, %rax
    syscall
    # Return -1 to indicate failure
    movq $-1, %rax

    # Epilogue
    leave
    ret

END_HW3:
    # Close file
    movq -24(%rbp), %rdi
    movq $3, %rax
    syscall
    # Return the counter value
    movq %r15, %rax

    # Epilogue
    leave
    ret
