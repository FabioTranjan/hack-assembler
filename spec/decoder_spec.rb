require './parser'
require './decoder'
require './symbolizer'

describe Decoder do
  describe "#decode_a_instruction" do
    context "when decoding an A instruction without symbols" do
      before do
        @decoder = Decoder.new(nil, nil)
      end

      it "returns the binary format with 16 bits" do
        expect(@decoder.decode_a_instruction('@21')).to eq '0000000000010101'
      end
    end

    context "when decoding an A instruction with symbols" do
      before do
        symbols = { 'i' => '0000000000001000' }
        @decoder = Decoder.new(nil, symbols)
      end

      it "returns the binary format with 16 bits" do
        expect(@decoder.decode_a_instruction('@i')).to eq '0000000000001000'
      end
    end
  end

  describe "#decode_c_instruction" do
    before do
      parsed = Parser.new('./fixtures/test.asm').parse
      @decoder = Decoder.new(parsed, nil)
    end

    context "when decoding comp instructions" do
      it "returns the binary format in 16 bits" do
        expect(@decoder.decode_c_instruction(['MD', 'D+1', ''])).to eq '1110011111011000'
        expect(@decoder.decode_c_instruction(['D', 'A', ''])).to eq '1110110000010000'
      end
    end

    context "when decoding a jmp instruction" do
      it "returns the binary format in 16 bits" do
        expect(@decoder.decode_c_instruction(['', 'D', 'JGT'])).to eq '1110001100000001'
        expect(@decoder.decode_c_instruction(['', '0', 'JMP'])).to eq '1110101010000111'
      end
    end

    context "when decoding a comp and jmp instruction" do
      it "returns the binary format in 16 bits" do
        expect(@decoder.decode_c_instruction(['MD', 'D+1', 'JGT'])).to eq '1110011111011001'
      end
    end
  end

  describe "#decode" do
    context "when decoding a file without symbols" do
      before do
        parsed = Parser.new('./fixtures/test.asm').parse
        @decoder = Decoder.new(parsed, nil)
      end

      it "returns the decoded binary output" do
        expect(@decoder.decode).to match_array(
          [
            '0000000000000010',
            '1110110000010000',
            '0000000000000011',
            '1110000010010000',
            '0000000000000000',
            '1110001100001000'
          ])
      end
    end
  end

  context "when decoding a file with symbols" do
    before do
      parsed = Parser.new('./fixtures/symbols.asm').parse
      symbolizer = Symbolizer.new(parsed)
      parsed = symbolizer.symbolize
      @decoder = Decoder.new(parsed, symbolizer.symbols)
    end

    it "returns the decoded binary output" do
      expect(@decoder.decode).to match_array(
        [
          '0000000000010000',
          '1110111111001000',
          '0000000000010001',
          '1110101010001000',
          '0000000000010000',
          '1111110000010000',
          '0000000000000000',
          '1111010011010000',
          '0000000000010010',
          '1110001100000001',
          '0000000000010000',
          '1111110000010000',
          '0000000000010001',
          '1111000010001000',
          '0000000000010000',
          '1111110111001000',
          '0000000000000100',
          '1110101010000111',
          '0000000000010001',
          '1111110000010000',
          '0000000000000001',
          '1110001100001000',
          '0000000000010110',
          '1110101010000111'
        ])
    end
  end
end
