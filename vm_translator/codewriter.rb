# Class that generates asssembly code from the parsed VM commands
class CodeWriter
  def initialize(filename)
    @filename = filename
    initialize_output
  end

  def write_arithmetic(command)
    @file.puts "// #{command}"
    case command
    when 'add'
      write_add
    end
  end

  def write_push_pop(command, segment, index)
    @file.puts "// #{command}"
    case command
    when 'C_PUSH'
      write_push(segment, index)
    end
  end

  def close
    @file.close
  end

  private

  def write_push(segment, index)
    case segment
    when 'constant'
      write_push_constant(index)
    end
  end

  def write_push_constant(index)
    @file.puts "@#{index}"
    @file.puts 'D=A'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'M=D'
    @file.puts '@SP'
    @file.puts 'M=M+1'
  end

  def write_add
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'D=M'
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts 'A=M'
    @file.puts 'D=D+M'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'M=D'
    @file.puts '@SP'
    @file.puts 'M=M+1'
  end

  def initialize_output
    prefix = @filename.split('.')[0]
    output = prefix + '.asm'
    @file = File.open(output, 'w+')
  end
end
