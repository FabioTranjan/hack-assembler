class Tokenizer
  KEYWORDS = [
    'class', 'constructor', 'function', 'method', 'field', 'static',
    'var', 'int', 'char', 'boolean', 'void', 'true', 'false', 'null',
    'this', 'let', 'do', 'if', 'else', 'while', 'return'
  ].freeze

  SYMBOLS = [
    '{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '*', '/',
    '&', '|', '<', '>', '=', '~'
  ].freeze

  def initialize(input_file)
    input_data = File.read(input_file)
    @split_data = split_data(input_data)
    @index = 0
  end

  def split_data(input_data)
    input_data.split(/(\()|(\))|(;)|\s/).reject(&:empty?)
  end

  # Return: true/false
  def has_more_tokens
    !@split_data[@index + 1].nil?
  end

  def advance
    return unless has_more_tokens

    @index = @index + 1
    @split_data[@index]
  end

  # Return
  # KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST
  def token_type
    token = @split_data[@index]
    tokenType(token)
  end

  # Return
  # CLASS, METHOD, FUNCTION, CONSTRUCTOR, INT, BOOLEAN, CHAR, VOID,
  # VAR, STATIC, FIELD, LET, DO, IF, ELSE, WHILE, RETURN, TRUE,
  # FALSE, NULL, THIS
  def keyWord
    token = @split_data[@index]
    return unless tokenType(token) == 'KEYWORD'

    token.upcase
  end

  # Return: char
  def symbol
    token = @split_data[@index]
    return unless tokenType(token) == 'SYMBOL'

    token.to_s
  end

  # Return: string
  def identifier
    token = @split_data[@index]
    return unless tokenType(token) == 'IDENTIFIER'

    token.to_s
  end

  # Return: int
  def intVal
    token = @split_data[@index]
    return unless tokenType(token) == 'INT_CONST'

    token.to_i
  end

  # Return: string
  def stringVal
    token = @split_data[@index]
    return unless tokenType(token) == 'STRING_CONST'

    token.to_s
  end

  def tokenType(token)
    if token.is_a? Integer
      return 'INT_CONST'
    elsif token.slice(0) == '"' && token.slice(-1) == '"'
      return 'STRING_CONST'
    elsif KEYWORDS.include? token
      return 'KEYWORD'
    elsif SYMBOLS.include? token
      return 'SYMBOL'
    else
      return 'IDENTIFIER'
    end
  end
end
