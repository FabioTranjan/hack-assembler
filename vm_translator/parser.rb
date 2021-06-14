require './constants'

# Class that parses each line, breaking each command to be decoded later
class Parser
  def initialize(filename)
    @read_lines = []
    File.open(filename, 'r').each_line do |line|
      next if line == NEW_LINE
      next if line.include?(COMMAND)
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
    return OPERATIONS[:arithmetic] if ARITHMETIC.include?(current[0])

    operation
  end

  def arg1
    return if current[0] == 'return'
    return current[0] if ARITHMETIC.include?(current[0])

    current[1]
  end

  def arg2
    return unless ARG_COMMANDS.include?(current[0])

    current[2]
  end

  private

  def operation
    OPERATIONS[current[0].to_sym]
  end

  def current
    @read_lines[@current_line]
  end
end
