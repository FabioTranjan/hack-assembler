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

  def current_token
    token = @split_data[@index]
    parseToken(token)
  end

  # Return: true/false
  def has_more_tokens
    !@split_data[@index + 1].nil?
  end

  def advance
    return unless has_more_tokens

    @index = @index + 1
    current_token
  end

  # Return
  # KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST
  def token_type
    tokenType(current_token).downcase
  end

  # Return
  # CLASS, METHOD, FUNCTION, CONSTRUCTOR, INT, BOOLEAN, CHAR, VOID,
  # VAR, STATIC, FIELD, LET, DO, IF, ELSE, WHILE, RETURN, TRUE,
  # FALSE, NULL, THIS
  def key_word
    return unless tokenType(current_token) == 'KEYWORD'

    current_token
  end

  # Return: char
  def symbol
    return unless tokenType(current_token) == 'SYMBOL'

    current_token.to_s
  end

  # Return: string
  def identifier
    return unless tokenType(current_token) == 'IDENTIFIER'

    current_token.to_s
  end

  # Return: int
  def int_val
    return unless tokenType(current_token) == 'INT_CONST'

    current_token.to_i
  end

  # Return: string
  def string_val
    return unless tokenType(current_token) == 'STRING_CONST'

    current_token.to_s
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

  def parseToken(token)
    return '&lt;' if token == '<'
    return '&gt;' if token == '>'
    return '&quot;' if token == '"'
    return '&amp;' if token == '&'

    token
  end
end
