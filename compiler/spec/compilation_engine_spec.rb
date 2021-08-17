require './tokenizer'
require './compilation_engine'

describe Tokenizer do
  describe "#compile_while" do
    context "when compiling a valid while statement" do
      let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
      let(:compilation_engine) { CompilationEngine.new(tokenizer) }

      before do
        tokenizer.split_data = ['while', '(', 'expression', ')', '{', 'statements', '}']
        compilation_engine.compile_while
      end

      it "prints a full while statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<whileStatement>\r\n",
            "<keyword> while </keyword>\r\n",
            "<symbol> ( </symbol>\r\n",
            "<symbol> ) </symbol>\r\n",
            "<symbol> { </symbol>\r\n",
            "<symbol> } </symbol>\r\n",
            "</whileStatement>\r\n"
          ]
        )
      end
    end
  end

  describe "#compile_if" do
    let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
    let(:compilation_engine) { CompilationEngine.new(tokenizer) }

    context 'when compiling an if without an else clause' do
      before do
        tokenizer.split_data = ['if', '(', 'expression', ')', '{', 'statements', '}']
        compilation_engine.compile_if
      end

      it "prints a full while statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<ifStatement>\r\n",
            "<keyword> if </keyword>\r\n",
            "<symbol> ( </symbol>\r\n",
            "<symbol> ) </symbol>\r\n",
            "<symbol> { </symbol>\r\n",
            "<symbol> } </symbol>\r\n",
            "</ifStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling an if with an else clause' do
      before do
        tokenizer.split_data = ['if', '(', 'expression', ')', '{', 'statements', '}', 'else', '{', 'statements', '}']
        compilation_engine.compile_if
      end

      it "prints a full while statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<ifStatement>\r\n",
            "<keyword> if </keyword>\r\n",
            "<symbol> ( </symbol>\r\n",
            "<symbol> ) </symbol>\r\n",
            "<symbol> { </symbol>\r\n",
            "<symbol> } </symbol>\r\n",
            "<keyword> else </keyword>\r\n",
            "<symbol> { </symbol>\r\n",
            "<symbol> } </symbol>\r\n",
            "</ifStatement>\r\n"
          ]
        )
      end
    end
  end

  describe "#compile_let" do
    let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
    let(:compilation_engine) { CompilationEngine.new(tokenizer) }

    context 'when compiling a let clause without []' do
      before do
        tokenizer.split_data = ['let', 'varName', '=', 'expression', ';']
        compilation_engine.compile_let
      end

      it "prints a full let statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> varName </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling a let clause with []' do
      before do
        tokenizer.split_data = ['let', 'varName', '[', 'expression', ']', '=', 'expression', ';']
        compilation_engine.compile_let
      end

      it "prints a full let statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> varName </identifier>\r\n",
            "<symbol> [ </symbol>\r\n",
            "<symbol> ] </symbol>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n"
          ]
        )
      end
    end
  end

  describe "#compile_return" do
    let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
    let(:compilation_engine) { CompilationEngine.new(tokenizer) }

    context 'when compiling a pure return clause' do
      before do
        tokenizer.split_data = ['return', ';']
        compilation_engine.compile_return
      end

      it "prints a full return statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<returnStatement>\r\n",
            "<keyword> return </keyword>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</returnStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling a return clause with an expression' do
      before do
        tokenizer.split_data = ['return', 'expression', ';']
        compilation_engine.compile_return
      end

      it "prints a full return statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<returnStatement>\r\n",
            "<keyword> return </keyword>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</returnStatement>\r\n"
          ]
        )
      end
    end
  end

  describe "#compile_do" do
    context "when compiling a valid do statement" do
      let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
      let(:compilation_engine) { CompilationEngine.new(tokenizer) }

      before do
        tokenizer.split_data = ['do', 'subroutine', ';']
        compilation_engine.compile_do
      end

      it "prints a full do statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<doStatement>\r\n",
            "<keyword> do </keyword>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</doStatement>\r\n"
          ]
        )
      end
    end
  end
end
