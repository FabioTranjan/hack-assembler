require './parser'
require './decoder'

describe Decoder do
  describe "#decode_a_instruction" do
    before do
      parsed = Parser.new('./test.asm').parse
      @decoder = Decoder.new(parsed)
    end

    context "when decoding an A instruction" do
      it "returns the binary format with 16 bits" do
        expect(@decoder.decode_a_instruction(['@', '21'])).to eq '0000000000010101'
      end
    end
  end

  describe "#decode_c_instruction" do
    before do
      parsed = Parser.new('./test.asm').parse
      @decoder = Decoder.new(parsed)
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
    before do
      parsed = Parser.new('./test.asm').parse
      @decoder = Decoder.new(parsed)
    end

    context "when decoding a file" do
      it "returns the decoded binary output" do
        expect(@decoder.decode).to eq(
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
end
