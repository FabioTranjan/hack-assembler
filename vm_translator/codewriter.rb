# Class that generates asssembly code from the parsed VM commands
class CodeWriter
  def initialize(parsed, filename)
    @parsed = parsed
    @filename = filename
  end

  def writeArithmetic
  end

  def writePushPop
  end

  def close
  end
end
