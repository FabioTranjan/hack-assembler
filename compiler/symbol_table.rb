require './tokenizer'
require './compilation_engine'

class SymbolTable
	attr_reader :symbol_table, :field_index, :static_index, :local_index, :argument_index

	ALLOWED_KINDS = ['field', 'static', 'local', 'argument']

  def initialize
		reset
  end

	def reset
		@symbol_table = {}
		@field_index = 0
		@static_index = 0
		@local_index = 0
		@argument_index = 0
	end

	def define(name, type, kind)
		return unless ALLOWED_KINDS.include?(kind)

	  index = kindIndex(kind) 
		symbol_table[name] = { type: type, kind: kind, index: index }
    increaseIndex(kind)
	end

	def varCount(kind)
		symbol_table.count { |_name, attrs| attrs[:kind] == kind }
	end

	def kindOf(name)
		attrs = symbol_table[name]
		return 'none' unless attrs

		attrs[:kind]
	end

	def typeOf(name)
		attrs = symbol_table[name]
		return unless attrs

		attrs[:type]
	end

	def indexOf(name)
		attrs = symbol_table[name]
		return unless attrs

		attrs[:index]
	end

	private

	def kindIndex(kind)
	  case kind
		when 'field'
			return @field_index
    when 'static'
			return @static_index
		when 'local'
			return @local_index
    when 'argument'
			return @argument_index
		end
	end

	def increaseIndex(kind)
	  case kind
		when 'field'
			@field_index += 1
    when 'static'
			@static_index += 1
		when 'local'
			@local_index += 1
    when 'argument'
			@argument_index += 1
		end
	end
end
