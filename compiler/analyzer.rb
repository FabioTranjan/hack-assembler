require './tokenizer'

class Analyzer
  def initialize
    @tokenizer = Tokenizer.new(ARGV[0])
    @output_file = File.open('./test.xml', 'w')
  end

  def run
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
    @output_file.write(" #{@tokenizer.current_token} ")
    @output_file.write("</#{@tokenizer.token_type}>\n")
  end
end

analyzer = Analyzer.new
analyzer.run
