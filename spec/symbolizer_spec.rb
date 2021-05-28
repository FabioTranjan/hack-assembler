require './parser'
require './symbolizer'

describe Symbolizer do
  before do
    @parser = Parser.new('./symbols.asm')
    @symbolizer = Symbolizer.new(@parser)
  end

  describe "#include_label" do
    let(:include_label) { @symbolizer.include_label(line, 4) }

    context "when include label is called" do
      let(:line) { '(LOOP)' }
      let(:index) { 4 }

      it "includes the label on the table" do
        include_label
        expect(@symbolizer.symbols['LOOP']).to eq '000000000000100'
      end
    end
  end

  describe "#try_symbol" do
    let(:try_symbol) { @symbolizer.try_symbol(line) }

    context "when symbol is not found" do
      let(:line) { '@i' }

      it "includes the symbol on the table" do
        try_symbol
        expect(@symbolizer.symbols['i']).to eq '000000000010000'
      end
    end
  end
end
