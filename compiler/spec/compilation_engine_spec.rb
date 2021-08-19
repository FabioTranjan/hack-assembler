require './tokenizer'
require './compilation_engine'

describe Tokenizer do
  describe "#compile_while" do
    context "when compiling a valid while statement" do
      let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
      let(:compilation_engine) { CompilationEngine.new(tokenizer) }

      before do
        tokenizer.split_data = ['while', '(', 'expression', ')', '{', 'let', 'x', '=', '1', ';', '}']
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
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
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
        tokenizer.split_data = ['if', '(', 'expression', ')', '{', 'let', 'x', '=', '1', ';', '}']
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
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
            "<symbol> } </symbol>\r\n",
            "</ifStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling an if with an else clause' do
      before do
        tokenizer.split_data = ['if', '(', 'expression', ')', '{', 'let', 'x', '=', '1', ';', '}', 'else', '{', 'let', 'x', '=', '1', ';', '}']
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
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
            "<symbol> } </symbol>\r\n",
            "<keyword> else </keyword>\r\n",
            "<symbol> { </symbol>\r\n",
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
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

  describe "#compile_statement" do
    let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
    let(:compilation_engine) { CompilationEngine.new(tokenizer) }

    context 'when compiling a let clause' do
      before do
        tokenizer.split_data = ['let', 'varName', '=', 'expression', ';']
        compilation_engine.compile_statement
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

    context 'when compiling a if clause' do
      before do
        tokenizer.split_data = ['if', '(', 'expression', ')', '{', 'let', 'x', '=', '1', ';', '}']
        compilation_engine.compile_statement
      end

      it "prints a full if statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<ifStatement>\r\n",
            "<keyword> if </keyword>\r\n",
            "<symbol> ( </symbol>\r\n",
            "<symbol> ) </symbol>\r\n",
            "<symbol> { </symbol>\r\n",
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
            "<symbol> } </symbol>\r\n",
            "</ifStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling a while clause' do
      before do
        tokenizer.split_data = ['while', '(', 'expression', ')', '{', 'let', 'x', '=', '1', ';', '}']
        compilation_engine.compile_statement
      end

      it "prints a full while statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<whileStatement>\r\n",
            "<keyword> while </keyword>\r\n",
            "<symbol> ( </symbol>\r\n",
            "<symbol> ) </symbol>\r\n",
            "<symbol> { </symbol>\r\n",
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> x </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
            "<symbol> } </symbol>\r\n",
            "</whileStatement>\r\n"
          ]
        )
      end
    end

    context 'when compiling a do clause' do
      before do
        tokenizer.split_data = ['do', 'subroutine', ';']
        compilation_engine.compile_statement
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

    context 'when compiling a return clause' do
      before do
        tokenizer.split_data = ['return', ';']
        compilation_engine.compile_statement
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

  describe "#compile_statements" do
    let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
    let(:compilation_engine) { CompilationEngine.new(tokenizer) }

    context 'when compiling a single let clause' do
      before do
        tokenizer.split_data = ['let', 'varName', '=', 'expression', ';']
        compilation_engine.compile_statements
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

    context 'when compiling multiple let clauses' do
      before do
        tokenizer.split_data = ['let', 'varName', '=', 'expression', ';', 'let', 'varName', '=', 'expression', ';']
        compilation_engine.compile_statements
      end

      it "prints a full let statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<letStatement>\r\n",
            "<keyword> let </keyword>\r\n",
            "<identifier> varName </identifier>\r\n",
            "<symbol> = </symbol>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</letStatement>\r\n",
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
  end

  describe "#compile_var_dec" do
    context "when compiling a single varDec statement" do
      let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
      let(:compilation_engine) { CompilationEngine.new(tokenizer) }

      before do
        tokenizer.split_data = ['var', 'Array', 'a', ';']
        compilation_engine.compile_var_dec
      end

      it "prints a full varDec statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<varDec>\r\n",
            "<keyword> var </keyword>\r\n",
            "<identifier> Array </identifier>\r\n",
            "<identifier> a </identifier>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</varDec>\r\n"
          ]
        )
      end
    end

    context "when compiling multiple varDec statement" do
      let(:tokenizer) { Tokenizer.new('./fixture/empty_file') }
      let(:compilation_engine) { CompilationEngine.new(tokenizer) }

      before do
        tokenizer.split_data = ['var', 'int', 'i', ',', 'sum', ';']
        compilation_engine.compile_var_dec
      end

      it "prints a full varDec statement" do
        expect(compilation_engine.output_data).to eq(
          [
            "<varDec>\r\n",
            "<keyword> var </keyword>\r\n",
            "<keyword> int </keyword>\r\n",
            "<identifier> i </identifier>\r\n",
            "<symbol> , </symbol>\r\n",
            "<identifier> sum </identifier>\r\n",
            "<symbol> ; </symbol>\r\n",
            "</varDec>\r\n"
          ]
        )
      end
    end
  end
end
