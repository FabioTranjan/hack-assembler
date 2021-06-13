require './constants'

# Class that parses each line, breaking each command to be decoded later
class Parser
  def initialize(filename)
    @read_lines = []
    File.open(filename, 'r').each_line do |line|
      @read_lines << parse(line)
    end
    @current_line = 0
  end

  def parse(line)
    line.split(' ')
  end

  def has_more_commands
    @current_line < @read_lines.length
  end

  def advance
    return @current_line unless has_more_commands

    @current_line += 1
  end

  def command_type
    operation
  end

  def arg1
    return if operation == 'C_RETURN'
    return current[0] if operation == 'C_ARITHMETIC'

    operation[1]
  end

  def arg2
    operation[2]
  end

  private

  def operation
    operation = OPERATIONS[current[0].to_sym]
    return OPERATIONS[:arithmetic] unless opeartion

    operation
  end

  def current
    @read_lines[current_line]
  end
end
