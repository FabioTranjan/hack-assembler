require './tokenizer'
require './compilation_engine'

class Analyzer
  def initialize
    @tokenizer = Tokenizer.new(ARGV[0])
    @compilation_engine = CompilationEngine.new(@tokenizer)
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

  def write_tokenized_file
    @output_file.write("<tokens>\n")
    write_token 
    while @tokenizer.has_more_tokens
      @tokenizer.advance
      write_token
    end
    @output_file.write("</tokens>\n")
  end

  def write_token
    @output_file.write("<#{@tokenizer.token_type}>")
    @output_file.write(" #{@tokenizer.parsed_token} ")
    @output_file.write("</#{@tokenizer.token_type}>\n")
  end
end

analyzer = Analyzer.new
analyzer.run
