require './parser'

describe Parser do
  describe ".has_more_commands" do
    before do
      @parser = Parser.new(filename)
    end

    context "when there are more commands" do
      let(:filename) { './fixtures/add.vm' }

      it "returns true" do
	@parser.advance
        expect(@parser.has_more_commands).to eq true
      end
    end

    context "when there aren't more commands" do
      let(:filename) { './fixtures/empty.vm' }

      it "returns false" do
        expect(@parser.has_more_commands).to eq false
      end
    end
  end

  describe ".advance" do
    before do
      @parser = Parser.new(filename)
    end

    context "when there are more commands" do
      let(:filename) { './fixtures/add.vm' }

      it "advances the current line" do
	expect(@parser.advance).to eq 1
      end
    end

    context "when there aren't more commands" do
      let(:filename) { './fixtures/empty.vm' }

      it "does not advance the current line" do
	expect(@parser.advance).to eq 0
      end
    end
  end

  describe ".command_type" do
    let(:filename) { './fixtures/add.vm' }

    before do
      @parser = Parser.new(filename)
    end

    context "when the command is arithmetic" do
      before do
        @parser.advance
        @parser.advance
      end

      it "returns the command itself" do
	      expect(@parser.command_type).to eq 'C_ARITHMETIC'
      end
    end

    context "when the command is return" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns nil" do
	      expect(@parser.command_type).to eq nil
      end
    end

    context "when the commands isn't arithmetic nor return" do
      it "returns the first argument of the command" do
	      expect(@parser.command_type).to eq 'C_PUSH'
      end
    end
  end
end
