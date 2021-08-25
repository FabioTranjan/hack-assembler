require './tokenizer'
require './compilation_engine'

class VMWriter
  def initialize
		@output_file = File.open('test.vm', 'w')
  end

	def write_push(segment, index)
	end

	def write_pop(segment, index)
	end

	def write_arithmetic(command)
  end

	def write_label(label)
	end

	def write_goto(label)
	end

	def write_if(label)
	end

	def write_call(name, nArgs)
	end

	def write_function(name, nVars)
	end

	def write_return
	end

	def close
		@output_file.close
	end
end
