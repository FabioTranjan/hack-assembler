class String
  def is_integer?
    self.to_i.to_s == self
  end
end

class Tokenizer
  attr_accessor :split_data

  COMMENT_DELIMITERS = ['//', '/*', '*/']

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
    input_data = ''
    File.open(input_file).each_line do |line|
      input_data += line unless COMMENT_DELIMITERS.include?(line[0..1])
    end
    @split_data = split(input_data)
    @index = 0
  end

  def split(input_data)
    join_str = ''
    should_join = false

    input_data.split(/(\".*\")|(\[)|(\])|(\~)|(\-)|(\,)|(\.)|(\()|(\))|(;)|\s/).reject(&:empty?)
  end

  def current_token
    @split_data[@index] 
  end

   def parsed_token
    if token_type == :keyword
      keyword
    elsif token_type == :symbol
      symbol
    elsif token_type == :identifier
      identifier
    elsif token_type == :integerConstant
      int_val
    elsif token_type == :stringConstant
      string_val
    end
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
    tokenType(current_token)
  end

  # Return
  # CLASS, METHOD, FUNCTION, CONSTRUCTOR, INT, BOOLEAN, CHAR, VOID,
  # VAR, STATIC, FIELD, LET, DO, IF, ELSE, WHILE, RETURN, TRUE,
  # FALSE, NULL, THIS
  def keyword
    return unless token_type == :keyword

    current_token
  end

  # Return: char
  def symbol
    return unless token_type == :symbol

    return '&lt;' if current_token == '<'
    return '&gt;' if current_token == '>'
    return '&quot;' if current_token == '"'
    return '&amp;' if current_token == '&'

    current_token.to_s
  end

  # Return: string
  def identifier
    return unless token_type == :identifier

    current_token.to_s
  end

  # Return: int
  def int_val
    return unless token_type == :integerConstant

    current_token.to_i
  end

  # Return: string
  def string_val
    return unless token_type == :stringConstant

    current_token.to_s[1..-2]
  end

  def tokenType(token)
    if token.is_integer?
      return :integerConstant
    elsif token.slice(0) == '"' && token.slice(-1) == '"'
      return :stringConstant
    elsif KEYWORDS.include? token
      return :keyword
    elsif SYMBOLS.include? token
      return :symbol
    else
      return :identifier
    end
  end
end
