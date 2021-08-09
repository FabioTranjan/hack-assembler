require './tokenizer'

describe Tokenizer do
  describe "#has_more_tokens" do
    context "when an empty input file is provided" do
      before do
        @tokenizer = Tokenizer.new('./fixture/empty_file')
      end

      it "returns false" do
        expect(@tokenizer.has_more_tokens).to be_falsy
      end
    end

    context "when a valid input file is provided" do
      before do
        @tokenizer = Tokenizer.new('./fixture/simple_code')
      end

      it "returns true" do
        expect(@tokenizer.has_more_tokens).to be_truthy
      end
    end
  end

  describe "#advance" do
    before do
      @tokenizer = Tokenizer.new('./fixture/simple_code')
    end

    context "when a valid input file is provided" do
      it "returns the next element" do
        expect(@tokenizer.advance).to eq('(')
      end
    end
  end

  describe "#tokenType" do
    before do
      @tokenizer = Tokenizer.new('./fixture/simple_code')
    end

    context "when parsing an integer constant" do
      it "returns INT_CONST" do
        expect(@tokenizer.tokenType('1')).to eq(:integerConstant)
      end
    end

    context "when parsing a string constant" do
      it "returns STRING_CONST" do
        expect(@tokenizer.tokenType('"string"')).to eq(:stringConstant)
      end
    end

    context "when parsing a keyword constant" do
      it "returns KEYWORD" do
        expect(@tokenizer.tokenType('class')).to eq(:keyword)
      end
    end

    context "when parsing a symbol constant" do
      it "returns SYMBOL" do
        expect(@tokenizer.tokenType('(')).to eq(:symbol)
      end
    end

    context "when parsing an identifier" do
      it "returns IDENTIFIER" do
        expect(@tokenizer.tokenType('variable')).to eq(:identifier)
      end
    end
  end
end
