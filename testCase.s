.globl _main
.text
_main:
push %ebp
movl %esp, %ebp
push $1
pop %eax
movl %eax, -4(%ebp)    # assign a
push -4(%ebp)    # get a
push $2
pop %eax
pop %edx
addl %edx, %eax
push %eax 
push $100
push $10000
pop %eax
pop %edx
addl %edx, %eax
push %eax 
pop %eax
pop %edx
addl %edx, %eax
push %eax 
push $.LC0    # display the value calling the function printf 
call _printf
movl $0, %eax
leave
ret
.LC0:
.asciz "%d
"
