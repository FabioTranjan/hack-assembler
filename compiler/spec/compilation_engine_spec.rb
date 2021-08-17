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

  context "when compiling a valid if statement" do
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
end
