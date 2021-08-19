class CompilationEngine
  attr_reader :output_data

  STATEMENTS = ['let', 'if', 'while', 'do', 'return']

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
    @tokenizer.advance
  end

  def compile_parameter_list
  end

  def compile_subroutine_body
  end

  def compile_var_dec
    printXML('<varDec>')
    process('var')
    process(@tokenizer.current_token)
    process(@tokenizer.current_token)
    while @tokenizer.current_token == ','
      process(',')
      process(@tokenizer.current_token)
    end
    process(';')
    printXML('</varDec>')
  end

  def compile_statements
    return unless STATEMENTS.include?(@tokenizer.current_token)

    compile_statement
    compile_statements
  end

  def compile_statement
    case @tokenizer.current_token
    when 'let'
      compile_let
    when 'if'
      compile_if
    when 'while'
      compile_while
    when 'do'
      compile_do
    when 'return'
      compile_return
    end
  end

  def compile_let
    printXML('<letStatement>')
    process('let')
    process(@tokenizer.current_token)
    if @tokenizer.current_token == '['
      process('[')
      compile_expression
      process(']')
    end
    process('=')
    compile_expression
    process(';')
    printXML('</letStatement>')
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
    printXML('<doStatement>')
    process('do')
    compile_subroutine
    process(';')
    printXML('</doStatement>')
  end

  def compile_return
    printXML('<returnStatement>')
    process('return')
    if @tokenizer.current_token != ';'
      compile_expression
    end
    process(';')
    printXML('</returnStatement>')
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
