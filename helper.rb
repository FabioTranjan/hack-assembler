class Helper
  def self.to_binary_16(number)
    number.to_i.to_s(2).rjust(15, '0')
  end
end
