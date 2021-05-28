require './helper'
require './constants'

# Class responsible to symbolize parsed lines
class Symbolizer
  def initialize(parsed)
    @parsed = parsed
    @symbols = PREDEFINED_SYMBOLS
    @last_memory = 16
  end

  def symbolize
    first_pass
    second_pass
  end

  def first_pass
    @parsed.each do |line, index|
      include_label(line, index) if line.first == '(' && line.last == ')'
    end
  end

  def second_pass
    @parsed.each do |line|
      try_symbol(line) if line.first == A_SYMBOL && has_alphabetic_char?(line)
    end
  end

  def has_alphabetic_char?(line)
    line.each_char.any? do
      |c| ('a'..'z').cover?(c) || ('A'..'Z').cover?(c)
    end
  end

  def include_label(line, index)
    symbol = line[1..-2]
    @symbols[symbol] = Helper.to_binary_16(index)
  end

  def try_symbol(line)
    symbol = line[1..-1]
    symbol_found = @symbols[symbol]
    return if symbol_found

    @symbols[symbol] = Helper.to_binary_16(@last_memory)
    @last_memory = @last_memory + 1
  end

  def symbols
    @symbols
  end
end