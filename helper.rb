class Helper
  def self.to_binary_16(number)
    '0' + number.to_i.to_s(2).rjust(15, '0')
  end

  def self.has_alphabetic_char?(line)
    line.each_char.any? do
      |c| ('a'..'z').cover?(c) || ('A'..'Z').cover?(c)
    end
  end
end
