class CompilationEngine
  attr_reader :output_data

  STATEMENTS = ['let', 'if', 'while', 'do', 'return']

  def initialize(tokenizer)
    @tokenizer = tokenizer
    @identation = 0
    @output_data = []
    @output_file = File.open('test.xml', 'w')
  end

  def compile_class
    printXML('<class>')
    @identation += 2
    process('class')
    process(@tokenizer.current_token)
    process('{')
    while ['static','field'].include?(@tokenizer.current_token)
      compile_class_var_dec
    end
    while ['constructor','function','method'].include?(@tokenizer.current_token)
      compile_subroutine_dec
    end
    process('}')
    @identation -= 2
    printXML('</class>')
  end

  def compile_class_var_dec
    printXML('<classVarDec>')
    @identation += 2
    process('static') if @tokenizer.current_token == 'static'
    process('field') if @tokenizer.current_token == 'field'
    process(@tokenizer.current_token)
    process(@tokenizer.current_token)
    while @tokenizer.current_token == ','
      process(',')
      process(@tokenizer.current_token)
    end
    process(';')
    @identation -= 2
    printXML('</classVarDec>')
  end

  def compile_subroutine_call
    if @tokenizer.current_token == '.'
      process('.')
      process(@tokenizer.current_token)
      process('(')
      compile_expression_list
      process(')')
    else
      process('(')
      compile_expression_list
      process(')')
    end
  end

  def compile_subroutine_dec
    printXML('<subroutineDec>')
    @identation += 2
    process('constructor') if @tokenizer.current_token == 'constructor'
    process('function') if @tokenizer.current_token == 'function'
    process('method') if @tokenizer.current_token == 'method'
    process(@tokenizer.current_token)
    process(@tokenizer.current_token)
    process('(')
    compile_parameter_list
    process(')')
    compile_subroutine_body
    @identation -= 2
    printXML('</subroutineDec>')
  end

  def compile_parameter_list
    printXML('<parameterList>')
    @identation += 2
    while @tokenizer.current_token != ')'
      process(@tokenizer.current_token)
      process(@tokenizer.current_token)
      process(',') if @tokenizer.current_token == ','
    end
    @identation -= 2
    printXML('</parameterList>')
  end

  def compile_subroutine_body
    printXML('<subroutineBody>')
    @identation += 2
    process('{')
    while @tokenizer.current_token == 'var'
      compile_var_dec
    end
    compile_statements
    process('}')
    @identation -= 2
    printXML('</subroutineBody>')
  end

  def compile_var_dec
    printXML('<varDec>')
    @identation += 2
    process('var')
    process(@tokenizer.current_token)
    process(@tokenizer.current_token)
    while @tokenizer.current_token == ','
      process(',')
      process(@tokenizer.current_token)
    end
    process(';')
    @identation -= 2
    printXML('</varDec>')
  end

  def compile_let
    printXML('<letStatement>')
    @identation += 2
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
    @identation -= 2
    printXML('</letStatement>')
  end

  def compile_if
    printXML('<ifStatement>')
    @identation += 2
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
    @identation -= 2
    printXML('</ifStatement>')
  end

  def compile_while
    printXML('<whileStatement>')
    @identation += 2
    process('while')
    process('(')
    compile_expression
    process(')')
    process('{')
    compile_statements
    process('}')
    @identation -= 2
    printXML('</whileStatement>')
  end

  def compile_do
    printXML('<doStatement>')
    @identation += 2
    process('do')
    process(@tokenizer.current_token)
    compile_subroutine_call
    process(';')
    @identation -= 2
    printXML('</doStatement>')
  end

  def compile_return
    printXML('<returnStatement>')
    @identation += 2
    process('return')
    if @tokenizer.current_token != ';'
      compile_expression
    end
    process(';')
    @identation -= 2
    printXML('</returnStatement>')
  end


  def compile_expression
    printXML('<expression>')
    @identation += 2

    compile_term
    op = ['+', '-', '*', '/', '&', '|', '<', '>', '=']
    while op.include?(@tokenizer.current_token)
      printXMLToken(@tokenizer.symbol)
      @tokenizer.advance
      compile_term
    end

    @identation -= 2
    printXML('</expression>')
  end

  def compile_term
    printXML('<term>')
    @identation += 2

    if @tokenizer.current_token == '('
      process('(')
      compile_expression
      process(')')
      @identation -= 2
      printXML('</term>')
      return
    end

    if ['-','~'].include?(@tokenizer.current_token)
      process(@tokenizer.current_token)
      compile_term
      @identation -= 2
      printXML('</term>')
      return
    end

    if @tokenizer.string_val
      printXMLToken(@tokenizer.string_val)
      @tokenizer.advance
    else
      process(@tokenizer.current_token)
    end

    if @tokenizer.current_token == '['
      process('[')
      compile_expression
      process(']')
      @identation -= 2
      printXML('</term>')
      return
    end

    if @tokenizer.current_token == '.'
      compile_subroutine_call
    end

    @identation -= 2
    printXML('</term>')
  end

  def compile_expression_list
    printXML('<expressionList>')
    @identation += 2

    if @tokenizer.current_token != ')'
      compile_expression
      while @tokenizer.current_token == ','
        process(',')
        compile_expression
      end
    end

    @identation -= 2
    printXML('</expressionList>')
  end

  def compile_statements
    printXML('<statements>')
    @identation += 2

    compile_statement
    do_compile_statements

    @identation -= 2
    printXML('</statements>')
  end

  def do_compile_statements
    return unless STATEMENTS.include?(@tokenizer.current_token)

    compile_statement
    do_compile_statements
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

  def process(token)
    return printXML('syntax error') unless @tokenizer.current_token == token

    printXMLToken(token)
    @tokenizer.advance
  end

  def printXMLToken(token)
    printXML("<#{@tokenizer.token_type}> #{token} </#{@tokenizer.token_type}>")
  end

  def printXML(str)
    printIdentation
    @output_data << "#{str}\r\n"
    @output_file.write("#{str}\r\n")
  end

  def printIdentation
    return if @identation == 0

    (0..@identation).to_a.each do |i|
      @output_data << " "
      @output_file.write(" ")
    end
  end
end
