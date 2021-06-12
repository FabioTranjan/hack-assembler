require './helper'
require './constants'

# Class that decodes each line to machine code (binary format)
class Decoder 
  def initialize(parsed, symbols)
    @parsed = parsed
    @symbols = symbols
  end

  def decode
    decoded = []

    @parsed.each do |line|
      if line[0] == A_SYMBOL
        decoded << decode_a_instruction(line)
      else
        decoded << decode_c_instruction(line)
      end
    end

    decoded
  end

  def decode_a_instruction(line)
    value = line[1..-1]
    if Helper.has_alphabetic_char?(value)
      return @symbols[value]
    else
      return Helper.to_binary_16(value)
    end
  end

  def decode_c_instruction(line)
    '111' + COMP_TABLE[line[1]] + DEST_TABLE[line[0]] + JMP_TABLE[line[2]]
  end
end
