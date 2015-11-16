.globl _main
.text
_main:
push %ebp
movl %esp, %ebp
push $2
push $2
pop %eax
pop %edx
imul %edx, %eax
push %eax
push $.LC0    # display the value calling the function printf 
call _printf
push $1
push $.LC0    # display the value calling the function printf 
call _printf
movl $0, %eax
leave
ret
.LC0:
.asciz "%d
"
