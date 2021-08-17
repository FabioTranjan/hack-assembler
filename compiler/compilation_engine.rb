class CompilationEngine
  attr_reader :output_data

  def initialize(tokenizer)
    @tokenizer = tokenizer
    @output_data = []
    @output_file = File.open('test.xml', 'w')
  end

  def compile_class
  end

  def compile_class_var_dec
  end

  def compile_subroutine
  end

  def compile_parameter_list
  end

  def compile_subroutine_body
  end

  def compile_var_dec
  end

  def compile_statements
    @tokenizer.advance
  end

  def compile_let
  end

  def compile_if
    printXML('<ifStatement>')
    process('if')
    process('(')
    compile_expression
    process(')')
    process('{')
    compile_statements
    process('}')
    if @tokenizer.current_token == 'else'
      process('else')
      process('{')
      compile_statements
      process('}')     
    end
    printXML('</ifStatement>')
  end

  def compile_while
    printXML('<whileStatement>')
    process('while')
    process('(')
    compile_expression
    process(')')
    process('{')
    compile_statements
    process('}')
    printXML('</whileStatement>')
  end

  def compile_do
  end

  def compile_return
  end

  def compile_expression
    @tokenizer.advance
  end

  def compile_term
  end

  def compile_expression_list
  end

  def process(token)
    return printXML('syntax error') unless @tokenizer.current_token == token

    printXMLToken
    @tokenizer.advance
  end

  def printXMLToken
    printXML("<#{@tokenizer.token_type}> #{@tokenizer.current_token} </#{@tokenizer.token_type}>")
  end

  def printXML(str)
    @output_data << "#{str}\r\n"
  end
end
