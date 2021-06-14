require './parser'
require './codewriter'

# Class that translates VM commands to machine code (ASM)
class Translator
  def initialize(filename)
    @parser = Parser.new(filename)
    @codewriter = CodeWriter.new(filename)
  end

  def translate
    @parsed = []
    while @parser.has_more_commands
      @parsed << [@parser.command_type, @parser.arg1, @parser.arg2]
      @parser.advance
    end

    @parsed.each do |command, segment, index|
      if command == OPERATIONS[:arithmetic]
	@codewriter.write_arithmetic(segment)
      else
	@codewriter.write_push_pop(command, segment, index)
      end
    end

    @codewriter.close
  end
end

translator = Translator.new(ARGV[0])
translator.translate
