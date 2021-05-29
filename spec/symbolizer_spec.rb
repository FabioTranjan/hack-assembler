require './parser'
require './symbolizer'

describe Symbolizer do
  let(:parsed) { [] }

  before do
    @symbolizer = Symbolizer.new(parsed)
  end

  describe "#include_label" do
    let(:include_label) { @symbolizer.include_label(line, 4) }

    context "when include label is called" do
      let(:line) { '(LOOP)' }
      let(:index) { 4 }

      it "includes the label on the table" do
        include_label
        expect(@symbolizer.symbols['LOOP']).to eq '0000000000000100'
      end
    end
  end

  describe "#try_symbol" do
    let(:line) { '@i' }
    let(:try_symbol) { @symbolizer.try_symbol(line) }

    before do
      try_symbol
    end

    context "when new symbol is not found" do
      it "includes the symbol on the table" do
        @symbolizer.try_symbol('@x')
        expect(@symbolizer.symbols['x']).to eq '0000000000010001'
      end
    end

    context "when same symbol is found" do
      it "does not include the symbol on the table" do
        try_symbol
        expect(@symbolizer.symbols['i']).to eq '0000000000010000'
      end
    end
  end

  describe "#first_pass" do
    let(:parsed) { ['@i', '(LOOP)', '@LOOP', '@STOP', '(STOP)'] }

    before do
      @symbolizer.first_pass
    end

    context "when doing a first pass" do
      it "includes the label symbols" do
        expect(@symbolizer.symbols['LOOP']).to eq '0000000000000001'
        expect(@symbolizer.symbols['STOP']).to eq '0000000000000011'
      end

      it "includes only two symbols more than predefined" do
        expect(@symbolizer.symbols.length).to eq PREDEFINED_SYMBOLS.length + 2
      end
    end
  end

  describe "#second_pass" do
    let(:parsed) { ['@i', '(LOOP)', '@x', 'i', '(STOP)', 'x'] }

    before do
      @symbolizer.second_pass
    end

    context "when doing a second pass" do
      it "includes the variable symbols" do
        expect(@symbolizer.symbols['i']).to eq '0000000000010000'
        expect(@symbolizer.symbols['x']).to eq '0000000000010001'
      end

      it "includes only two symbols more than predefined" do
        expect(@symbolizer.symbols.length).to eq PREDEFINED_SYMBOLS.length + 2
      end
    end
  end
end
