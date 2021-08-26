require './tokenizer'
require './vm_writer'
require './symbol_table'
require './compilation_engine'

class Compiler
  def initialize
    @tokenizer = Tokenizer.new(ARGV[0])
    @class_symbol_table = SymbolTable.new
    @subroutine_symbol_table = SymbolTable.new
    @vm_writer = VMWriter.new
    @compilation_engine = CompilationEngine.new(@tokenizer, @vm_writer, print_xml: true)
    @output_file = File.open('./test.xml', 'w')
  end

  def run
    while @tokenizer.has_more_tokens
      if @tokenizer.current_token == 'class'
        @compilation_engine.compile_class
      else
        @tokenizer.advance
      end
    end
  end
end

compiler = Compiler.new
compiler.run
