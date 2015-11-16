Compiler: Code Generation using the Stack Machine
=======

It's in x86 Assembly/GAS Syntax. The assembly code is directly executable.

1. Type ```make```

2. Type ```./calc <testCase.txt >testCase.s ``` to run the test case.

3. Type ```gcc -m32 testCase.s -o testCase ``` to build the executable file.

4. Type ```./testCase``` to run the executable file.

Type ``` make clean ``` to clean files.

###Note:
========
1. The symbol object get the value of the address when this symbol object is initialized.

2. I use MacOS to write the project. Please let me know if the project doesn't work.
