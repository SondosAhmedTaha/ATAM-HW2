.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  
  #save reg
  pushq %rax
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rsp
  pushq %rbp
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

  #prep the reg for use
  movq $0, %rax
  movq $0, %rbx
  movq $0, %rdi
  movq $0, %rcx
  
  #get the opcode
  movq 120(%rsp), %rax
  movq (%rax), %rax

  #get the byte that is going to be passed to what_to_do
  cmpb $0x0f, %al 
  je two_byte_HW3
  movq $1, %rcx
  movb %al, %bl
  jmp continue_HW3

two_byte_HW3:
  movb %ah, %bl
  movq $2, %rcx

  #call what_to_do, if return value is 0 call old handler
continue_HW3:
  movq %rbx, %rdi
  call what_to_do
  cmpq $0, %rax
  je old_handler_HW3
  movq %rax, %rdi
  cmpq $1, %rcx
  je exit_one_byte_HW3
  jmp exit_two_bytes_HW3


old_handler_HW3:
  #restore reg
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rbp
  popq %rsp
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  jmp * old_ili_handler
  jmp End_HW3

exit_one_byte_HW3:
  #restore reg
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rbp
  popq %rsp
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  #make rip point to the next instruction
  addq $1, (%rsp)
  jmp End_HW3

exit_two_bytes_HW3:
  #restore reg
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rbp
  popq %rsp
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax
  #make rip point to the next instruction
  addq $2, (%rsp)

End_HW3:
  iretq
