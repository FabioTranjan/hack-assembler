require './parser'
require './decoder'
require './symbolizer'

class Assembler
  def initialize(input_file)
    @input_file = input_file
  end

  def assembly(output_file)
    parsed = Parser.new(@input_file).parse
    symbolizer = Symbolizer.new(parsed)
    parsed = symbolizer.symbolize
    decoded = Decoder.new(parsed, symbolizer.symbols).decode

    file = File.open(output_file, 'w')
    decoded.each do |line|
      file.puts(line)
    end
    file.close
  end
end

assembler = Assembler.new(ARGV[0])
assembler.assembly(ARGV[1])
