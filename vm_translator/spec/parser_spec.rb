require './parser'

describe Parser do
  describe ".has_more_commands" do
    before do
      @parser = Parser.new(filename)
    end

    context "when there are arithmetic commands" do
      let(:filename) { './fixtures/add.vm' }

      it "returns true" do
	      @parser.advance
        expect(@parser.has_more_commands).to eq true
      end
    end

    context "when there are no commands" do
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

    context "when there arithmethic commands" do
      let(:filename) { './fixtures/add.vm' }

      it "advances the current line" do
	      expect(@parser.advance).to eq 1
      end
    end

    context "when there no commands" do
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

      it "returns an arithmetic command" do
	      expect(@parser.command_type).to eq 'C_ARITHMETIC'
      end
    end

    context "when the command is return" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns C_RETURN" do
	      expect(@parser.command_type).to eq 'C_RETURN'
      end
    end

    context "when the command is label" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns C_LABEL" do
	      expect(@parser.command_type).to eq 'C_LABEL'
      end
    end

    context "when the command is goto" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns C_GOTO" do
	      expect(@parser.command_type).to eq 'C_GOTO'
      end
    end

    context "when the commands is push" do
      it "returns the current command" do
	      expect(@parser.command_type).to eq 'C_PUSH'
      end
    end
  end

  describe ".arg1" do
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
	      expect(@parser.arg1).to eq 'add'
      end
    end

    context "when the command is return" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns nil" do
	      expect(@parser.arg1).to eq nil
      end
    end

    context "when the command is label" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns LOOP_START" do
	      expect(@parser.arg1).to eq 'LOOP_START'
      end
    end

    context "when the command is goto" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns LOOP_START" do
	      expect(@parser.arg1).to eq 'LOOP_START'
      end
    end

    context "when the commands is push" do
      it "returns the first argument of the command" do
	      expect(@parser.arg1).to eq 'constant'
      end
    end
  end

  describe ".arg2" do
    let(:filename) { './fixtures/add.vm' }

    before do
      @parser = Parser.new(filename)
    end

    context "when the command is arithmetic" do
      before do
        @parser.advance
        @parser.advance
      end

      it "returns nil" do
	      expect(@parser.arg2).to eq nil
      end
    end

    context "when the command is return" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns nil" do
	      expect(@parser.arg2).to eq nil
      end
    end

    context "when the command is label" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns LOOP_START" do
	      expect(@parser.arg2).to eq nil
      end
    end

    context "when the command is goto" do
      before do
        @parser.advance
        @parser.advance
        @parser.advance
        @parser.advance
      end

      it "returns LOOP_START" do
	      expect(@parser.arg2).to eq nil
      end
    end

    context "when the command is push" do
      it "returns the second argument of the command" do
	      expect(@parser.arg2).to eq '1'
      end
    end
  end
end
