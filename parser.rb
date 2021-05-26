# Class that parses each line, breaking each command to be decoded later
class Parser
  A_SYMBOL = '@'
  C_SYMBOL = '='
  JMP_SYMBOL = ';'

  def initialize(file)
    @file = File.open(file, 'r')
  end

  def parse
    parsed = []

    @file.each_line do |line|
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
    line.strip.split(/=|;/)
  end
end