# Hack Computer

## Description
- The Hack Computer is a representation of a real computer, simulating all the components from hardware to software with all necessary abstractions such as machine code, vm translation, compiler, operational system until a real program written in a high-level language.
- For more info go to: https://www.nand2tetris.org/

## Components

### Assembler
- The Hack Assembler serves to get assembly code (ASM) as input and convert it to machine code (binary) for the Hack computer architecture.
- How to use: run the script: `ruby assembler.rb input.asm output.hack`

### Virtual Machine translator
- The VM Translator serves to get vm code (VM) as input and convert it to assembly code (ASM) for the Hack computer architecture.
- This is a stack-based machine, it has the same purpose as other virtual machines such as JVM and Erlang VM.
- How to use: run the script: `ruby translator.rb input.vm output.asm`
