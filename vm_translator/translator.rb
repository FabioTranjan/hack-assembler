require './parser'
require './codewriter'

# Class that translates VM commands to machine code (ASM)
class Translator
  def initialize(filename)
    @files = []
    filenames = Dir.entries(ARGV[0]).select{ |file| file.include?('.vm') }
    filenames.each do |filename|
      @files << "#{ARGV[0]}#{filename}"
    end

    output = ARGV[0].split('/').last
    @codewriter = CodeWriter.new(ARGV[0] + output)
  end

  def translate
    @parsed = []

    @files.each do |filename|
      @parser = Parser.new(filename)
      while @parser.has_more_commands
        @parsed << [@parser.command_type, @parser.arg1, @parser.arg2]
        @parser.advance
      end
    end

    @codewriter.write_init

    @parsed.each do |command, segment, index|
      if command == OPERATIONS[:arithmetic]
  	    @codewriter.write_arithmetic(segment)
      elsif command == OPERATIONS[:label]
  	    @codewriter.write_label(command, segment)
      elsif command == OPERATIONS[:goto]
  	    @codewriter.write_goto(command, segment)
      elsif command == OPERATIONS["if-goto".to_sym]
  	    @codewriter.write_if(command, segment)
      elsif command == OPERATIONS[:function]
  	    @codewriter.write_function(command, segment, index)
      elsif command == OPERATIONS[:return]
  	    @codewriter.write_return(command, segment)
      elsif command == OPERATIONS[:call]
  	    @codewriter.write_call(command, segment, index)
      else
  	    @codewriter.write_push_pop(command, segment, index)
      end
    end

    @codewriter.close
  end
end

translator = Translator.new(ARGV[0])
translator.translate
