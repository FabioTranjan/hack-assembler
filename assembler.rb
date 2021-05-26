require './parser'
require './decoder'

class Assembler
  def initialize(input_file)
    @input_file = input_file
  end

  def assembly(output_file)
    parsed = Parser.new(@input_file).parse
    decoded = Decoder.new(parsed).decode

    file = File.open(output_file, 'w')
    decoded.each do |line|
      file.puts(line)
    end
    file.close
  end
end

assembler = Assembler.new(ARGV[0])
assembler.assembly(ARGV[1])
