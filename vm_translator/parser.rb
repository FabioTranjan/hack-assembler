require './constants'

# Class that parses each line, breaking each command to be decoded later
class Parser
  def initialize(filename)
    @filename = filename
    @file = File.open(filename, 'r')
  end

  def has_more_commands
    true
  end

  def advance
  end

  def command_type
    OPERATIONS[0]
  end

  def arg1
  end

  def arg2
  end
end