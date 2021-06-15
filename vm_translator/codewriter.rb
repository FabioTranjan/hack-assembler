# Class that generates asssembly code from the parsed VM commands
class CodeWriter
  def initialize(filename)
    @filename = filename
    @jmp_inc = 0
    initialize_output
  end

  def write_arithmetic(command)
    @file.puts "// #{command}"
    case command
    when 'add'
      write_op_two('+')
    when 'sub'
      write_op_two('-')
    when 'neg'
      write_op_one('-')
    when 'and'
      write_op_two('&')
    when 'or'
      write_op_two('|')
    when 'not'
      write_op_one('!')
    when 'eq'
      write_cmp('JEQ')
      @jmp_inc += 1
    when 'lt'
      write_cmp('JLT')
      @jmp_inc += 1
    when 'gt'
      write_cmp('JGT')
      @jmp_inc += 1
    end
  end

  def write_push_pop(command, segment, index)
    @file.puts "// #{command} #{segment} #{index}"
    case command
    when 'C_PUSH'
      write_push(segment, index)
    when 'C_POP'
      write_pop(segment, index)
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
    when 'local'
      write_push_segment('LCL', index)
    when 'argument'
      write_push_segment('ARG', index)
    when 'this'
      write_push_segment('THIS', index)
    when 'that'
      write_push_segment('THAT', index)
    when 'temp'
      write_push_segment(5, index)
    end
  end

  def write_pop(segment, index)
    case segment
    when 'local'
      write_pop_segment('LCL', index)
    when 'argument'
      write_pop_segment('ARG', index)
    when 'this'
      write_pop_segment('THIS', index)
    when 'that'
      write_pop_segment('THAT', index)
    when 'temp'
      write_pop_segment(5, index)
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

  def write_push_segment(segment, index)
    @file.puts "@#{index}"
    @file.puts "D=A"
    @file.puts "@#{segment}"
    @file.puts 'D=D+M' unless segment.is_a? Integer
    @file.puts 'D=D+A' if segment.is_a? Integer
    @file.puts "A=D"
    @file.puts "D=M"
    @file.puts "@SP"
    @file.puts 'A=M'
    @file.puts 'M=D'
    @file.puts "@SP"
    @file.puts 'M=M+1'
  end

  def write_pop_segment(segment, index)
    @file.puts "@#{index}"
    @file.puts "D=A"
    @file.puts "@#{segment}"
    @file.puts 'D=D+M' unless segment.is_a? Integer
    @file.puts 'D=D+A' if segment.is_a? Integer
    @file.puts '@5'
    @file.puts 'M=D'
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts 'A=M'
    @file.puts 'D=M'
    @file.puts '@5'
    @file.puts 'A=M'
    @file.puts 'M=D'
  end

  def write_cmp(cmp)
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'D=M'
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts 'A=M'
    @file.puts 'D=M-D'
    @file.puts "@TRUE_#{@jmp_inc}"
    @file.puts "D;#{cmp}"
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts "M=0"
    @file.puts "@OUT_#{@jmp_inc}"
    @file.puts "0;JEQ"
    @file.puts "(TRUE_#{@jmp_inc})"
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts "M=-1"
    @file.puts "(OUT_#{@jmp_inc})"
    @file.puts '@SP'
    @file.puts 'M=M+1'
  end

  def write_op_two(op)
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'D=M'
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts 'A=M'
    @file.puts "D=M#{op}D"
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts 'M=D'
    @file.puts '@SP'
    @file.puts 'M=M+1'
  end

  def write_op_one(op)
    @file.puts '@SP'
    @file.puts 'M=M-1'
    @file.puts '@SP'
    @file.puts 'A=M'
    @file.puts "M=#{op}M"
    @file.puts '@SP'
    @file.puts 'M=M+1'
  end

  def initialize_output
    prefix = @filename.split('.')[0]
    output = prefix + '.asm'
    @file = File.open(output, 'w+')
  end
end
