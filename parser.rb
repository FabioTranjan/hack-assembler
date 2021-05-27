require './constants'

# Class that parses each line, breaking each command to be decoded later
class Parser
  def initialize(file)
    @file = File.open(file, 'r')
  end

  def parse
    parsed = []

    @file.each_line do |line|
      next if line.include?(COMMENT_SYMBOL) || line == NEW_LINE

      parsed_a = parse_a_instruction(line)
      parsed << parsed_a if parsed_a

      parsed_c = parse_c_instruction(line)
      parsed << parsed_c if parsed_c
    end

    parsed
  end

  def parse_a_instruction(line)
    return unless line.include?(A_SYMBOL)
    line.strip.split(/(?<=[@])/)
  end

  def parse_c_instruction(line)
    return unless line.include?(C_SYMBOL) || line.include?(JMP_SYMBOL)
    if line.include?(C_SYMBOL)
      return line.strip.split(/=/).push('')
    else
      return line.strip.split(/;/).unshift('')
    end
  end
end