require './tokenizer'
require './compilation_engine'

class VMWriter
  attr_accessor :class_symbol_table, :subroutine_symbol_table

  def initialize
    @class_symbol_table = SymbolTable.new
    @subroutine_symbol_table = SymbolTable.new
    @output_file = File.open('test.vm', 'w')
  end
 
  # Arguments:
  # segment (CONST, ARG, LOCAL, STATIC, THIS, THAT, POINTER, TEMP)
  # index (int)
  def write_push(segment, index)
		case segment
		when 'const'
			@output_file.write("push constant #{index}\n")
		end
  end
 
  # Arguments:
  # segment (ARG, LOCAL, STATIC, THIS, THAT, POINTER, TEMP)
  # index (int)
  def write_pop(segment, index)
		case segment
		when 'temp'
			@output_file.write("pop temp #{index}\n")
		end
  end
  
  # Arguments:
  # command (ADD, SUB, NEG, EQ, GT, LT, AND, OR, NOT)
  def write_arithmetic(command)
		case command
		when '+'
      @output_file.write("add\n")
		when '*'
			write_call('Math.multiply', 2)
		end
  end
  
  # Arguments:
  # label (String)
  def write_label(label)
  end
   
  # Arguments:
  # label (String)
  def write_goto(label)
  end
  
  # Arguments:
  # label (String)
  def write_if(label)
  end
  
  # Arguments:
  # name (String)
  # nArgs (int)
  def write_call(name, nArgs)
    @output_file.write("call #{name} #{nArgs}\n")
  end
  
  # Arguments:
  # name (String)
  # nLocals (int)
  def write_function(name, nVars)
    @output_file.write("function #{name} #{nVars}\n")
  end
  
  def write_return
		write_pop('temp', 0)
		write_push('const', 0)
    @output_file.write("return\n")
  end

  def write_expression(exp)
    return write_push('const', exp) if is_integer?(exp)

    # ToDo: check if exp is a var

    # ToDo: check if exp is a func

    exp_list = exp.split(' ', 3)

    if exp_list.length == 3
      write_expression(exp_list[0])
      write_expression(exp_list[2])
      write_arithmetic(exp_list[1])
      return
    end

    if exp_list.length == 2
      write_expression(exp_list[1])
      write_arithmetic(exp_list[0])
    end
  end
  
  def close
  	@output_file.close
  end

  private

  def is_integer?(exp)
    exp.to_i.to_s == exp
  end
end
