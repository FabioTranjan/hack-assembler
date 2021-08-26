# Hack Computer

## Description
- The Hack Computer is a representation of a real computer, simulating all the components from hardware to software with all necessary abstractions such as basic hardware, machine code, virtual machine, compiler, operational system until a real program written in a high-level language.
- For more info go to: https://www.nand2tetris.org/

## Components

### Computer Architecture
- The computer is based on Von Neumann's architecture, but more simplified. The memories are separated in instruction and data memory, then the CPU doesn't need to switch to access each of them. External devices such as a monitor and a keyboard are also supported.

#### CPU
![image](https://user-images.githubusercontent.com/26252636/128648802-7a09b9e5-ef8a-4234-958f-06616d7faaf1.png)

#### Hack Computer
![image](https://user-images.githubusercontent.com/26252636/128648905-b4130309-8497-4905-9c75-40b0bddd8ee8.png)


### Assembler
- The Hack Assembler serves to get assembly code (ASM) as input and convert it to machine code (binary) for the Hack computer architecture.
- How to use: run the script: `ruby assembler.rb input.asm output.hack`

### Virtual Machine
- The VM Translator serves to get vm code (VM) as input and convert it to assembly code (ASM) for the Hack computer architecture.
- This is a stack-based machine, basically it's an intermediate between the compiler and the assembler.
- How to use: run the script: `ruby translator.rb input.vm output.asm`

### Compiler
- The Compiler serves to convert high-level code to vm code, it's divided in two parts
- The first part parses the high-level code, it converts semantic declarations into tokens (Tokenizer), then it organizer the tokens into languague grammar (CompilationEngine).
- The second part uses the tokenized grammar code into VM code, using VMWriter and SymbolTable to store the variables.
- How to use: run the script: `ruby compiler.rb input.jack output.vm`
