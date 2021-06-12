require './helper'

describe Helper do
  describe "#to_binary_16" do
    context "when converting a decimal number" do
      it "converts to binary with 16 bits" do
        expect(Helper.to_binary_16(9)).to eq '0000000000001001'
      end
    end
  end

  describe "#has_alphabetic_char?" do
    context "when uppercase alphabetic char is present" do
      let(:line) { '@R0' }
      it "returns true" do
        expect(Helper.has_alphabetic_char?(line)).to be_truthy
      end
    end

    context "when lowercase alphabetic char is present" do
      let(:line) { '@loop' }
      it "returns true" do
        expect(Helper.has_alphabetic_char?(line)).to be_truthy
      end
    end

    context "when alphabetic char is not present" do
      let(:line) { '@21' }
      it "returns nil" do
        expect(Helper.has_alphabetic_char?(line)).to be_falsey
      end
    end
  end
end
