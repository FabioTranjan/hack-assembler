# Class that generates asssembly code from the parsed VM commands
class CodeWriter
  def initialize(filename)
    @filename = filename
    @jmp_inc = 0
    initialize_output
  end

  def write_arithmetic(command)
    log(command)
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
    log(command, segment, index)
    case command
    when 'C_PUSH'
      write_push(segment, index)
    when 'C_POP'
      write_pop(segment, index)
    end
  end

  def write_init
    @file.puts "// Init bootstrap"
    @file.puts "@256"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "M=D"
    write_call('C_CALL', 'Sys.init', 0)
  end

  def write_label(command, segment)
    log(command, segment)
    @file.puts "(#{segment})"
  end

  def write_goto(command, segment)
    log(command, segment)
    @file.puts "@#{segment}"
    @file.puts "0;JEQ"
  end

  def write_if(command, segment)
    log(command, segment)
    @file.puts "@SP"
    @file.puts "M=M-1"
    @file.puts "A=M"
    @file.puts "D=M"
    @file.puts "@#{segment}"
    @file.puts "D;JGT"
  end

  def write_function(command, segment, index)
    log(command, segment, index)
    @file.puts "(#{segment})"
    @file.puts "@#{index}"
    @file.puts "D=A"
    @file.puts "@#{segment}_out"
    @file.puts "D;JEQ"
    @file.puts "@5"
    @file.puts "M=D"
    @file.puts "(#{segment}_loop)"
    @file.puts "@0"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@5"
    @file.puts "M=M-1"
    @file.puts "D=M"
    @file.puts "@#{segment}_loop"
    @file.puts "D;JGT"
    @file.puts "(#{segment}_out)"
  end

  def write_call(command, segment, index)
    log(command, segment, index)
    @file.puts "@#{segment}_ret_#{@jmp_inc}"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@LCL"
    @file.puts "A=M"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@ARG"
    @file.puts "A=M"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@THIS"
    @file.puts "A=M"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@THAT"
    @file.puts "A=M"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
    @file.puts "@SP"
    @file.puts "D=M"
    @file.puts "@5"
    @file.puts "D=D-A"
    @file.puts "@#{index}"
    @file.puts "D=D-A"
    @file.puts "@ARG"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "D=M"
    @file.puts "@LCL"
    @file.puts "M=D"
    @file.puts "@#{segment}"
    @file.puts "0;JEQ"
    @file.puts "(#{segment}_ret_#{@jmp_inc})"
    @jmp_inc += 1
  end

  def write_return(command, segment)
    log(command, segment)
    @file.puts "@LCL"
    @file.puts "D=M"
    @file.puts "@5"
    @file.puts "M=D"
    @file.puts "@6"
    @file.puts "M=D"
    @file.puts "@5"
    @file.puts "D=A"
    @file.puts "@6"
    @file.puts "A=M-D"
    @file.puts "D=M"
    @file.puts "@6"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M-1"
    @file.puts "A=M"
    @file.puts "D=M"
    @file.puts "@ARG"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "D=A"
    @file.puts "@SP"
    @file.puts "M=D"
    @file.puts "M=M+1"
    @file.puts "@1"
    @file.puts "D=A"
    @file.puts "@5"
    @file.puts "A=M-D"
    @file.puts "D=M"
    @file.puts "@THAT"
    @file.puts "M=D"
    @file.puts "@2"
    @file.puts "D=A"
    @file.puts "@5"
    @file.puts "A=M-D"
    @file.puts "D=M"
    @file.puts "@THIS"
    @file.puts "M=D"
    @file.puts "@3"
    @file.puts "D=A"
    @file.puts "@5"
    @file.puts "A=M-D"
    @file.puts "D=M"
    @file.puts "@ARG"
    @file.puts "M=D"
    @file.puts "@4"
    @file.puts "D=A"
    @file.puts "@5"
    @file.puts "A=M-D"
    @file.puts "D=M"
    @file.puts "@LCL"
    @file.puts "M=D"
    @file.puts "@6"
    @file.puts "A=M"
    @file.puts "0;JEQ"
  end


  def close
    @file.close
  end

  private

  def log(command, segment = nil, index = nil)
    @file.puts "// #{command} #{segment} #{index}".strip
  end

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
    when 'pointer'
      write_push_pointer(index)
    when 'static'
      write_push_static(index)
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
    when 'pointer'
      write_pop_pointer(index)
    when 'static'
      write_pop_static(index)
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

  def write_push_pointer(index)
    segment = 'THIS' if index == '0'
    segment = 'THAT' if index == '1'

    @file.puts "@#{segment}"
    @file.puts "D=M"
    @file.puts "@SP"
    @file.puts "A=M"
    @file.puts "M=D"
    @file.puts "@SP"
    @file.puts "M=M+1"
  end

  def write_pop_pointer(index)
    segment = 'THIS' if index == '0'
    segment = 'THAT' if index == '1'

    @file.puts "@SP"
    @file.puts "M=M-1"
    @file.puts "A=M"
    @file.puts "D=M"
    @file.puts "@#{segment}"
    @file.puts "M=D"
  end

   def write_pop_static(index)
    @file.puts "@SP"
    @file.puts 'M=M-1'
    @file.puts "@SP"
    @file.puts 'A=M'
    @file.puts 'D=M'
    @file.puts "@Foo.#{index}"
    @file.puts 'M=D'
  end

  def write_push_static(index)
    @file.puts "@Foo.#{index}"
    @file.puts 'D=M'
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
