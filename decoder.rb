require './constants'

# Class that decodes each line to machine code (binary format)
class Decoder 
  def initialize(parsed)
    @parsed = parsed
  end

  def decode
    decoded = []

    @parsed.each do |line|
      if line.first == A_SYMBOL
        decoded << decode_a_instruction(line)
      else
        decoded << decode_c_instruction(line)
      end
    end

    decoded
  end

  def decode_a_instruction(line)
    '0' + line.last.to_i.to_s(2).rjust(15, '0')
  end

  def decode_c_instruction(line)
    '111' + COMP_TABLE[line[1]] + DEST_TABLE[line[0]] + JMP_TABLE[line[2]]
  end
end