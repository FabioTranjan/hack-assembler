require './symbol_table'

describe SymbolTable do
  let(:symbol_table) { SymbolTable.new }

  describe "#define" do
    context "when defining a valid variable" do
      before do
        symbol_table.define('var', 'int', 'local')
      end

      it "adds the variable to the symbol table" do
        expect(symbol_table.symbol_table.length).to eq(1)
        expect(symbol_table.symbol_table['var']).to eq({ type: 'int', kind: 'local', index: 0})
      end

      it "increases the local index counter" do
        expect(symbol_table.local_index).to eq(1)
      end
    end

    context "when defining an invalid variable" do
      before do
        symbol_table.define('var', 'int', 'invalid')
      end

      it "does not add the variable to the symbol table" do
        expect(symbol_table.symbol_table.length).to eq(0)
      end

      it "does not increase the local index counter" do
        expect(symbol_table.local_index).to eq(0)
      end
    end
  end

  describe "#reset" do
    context "when the symbol table isn't empty" do
      before do
        symbol_table.define('var', 'int', 'local')
        symbol_table.reset
      end

      it "resets the symbol table" do
        expect(symbol_table.symbol_table.length).to eq(0)
      end

      it "resets the indexes" do
        expect(symbol_table.local_index).to eq(0)
      end
    end
  end

  describe "#varCount" do
    context "when the symbol table has multiple variables" do
      before do
        symbol_table.define('var1', 'int', 'local')
        symbol_table.define('var2', 'string', 'local')
        symbol_table.define('var3', 'int', 'argument')
      end

      it "returns the local var count" do
        expect(symbol_table.varCount('local')).to eq(2)
      end

      it "returns the argument var count" do
        expect(symbol_table.varCount('argument')).to eq(1)
      end

      it "returns the static var count" do
        expect(symbol_table.varCount('static')).to eq(0)
      end

      it "returns the field var count" do
        expect(symbol_table.varCount('field')).to eq(0)
      end
    end
  end

  describe "#kindOf" do
    context "when passing a valid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns the kind of the variable" do
        expect(symbol_table.kindOf('var1')).to eq('local')
      end
    end

    context "when passing an invalid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns none" do
        expect(symbol_table.kindOf('var2')).to eq('none')
      end
    end
  end

  describe "#typeOf" do
    context "when passing a valid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns the type of the variable" do
        expect(symbol_table.typeOf('var1')).to eq('int')
      end
    end

    context "when passing an invalid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns nil" do
        expect(symbol_table.typeOf('var2')).to be_nil
      end
    end
  end

  describe "#indexOf" do
    context "when passing a valid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns the index of the variable" do
        expect(symbol_table.indexOf('var1')).to eq(0)
      end
    end

    context "when passing an invalid variable" do
      before do
        symbol_table.define('var1', 'int', 'local')
      end

      it "returns nil" do
        expect(symbol_table.indexOf('var2')).to be_nil
      end
    end
  end
end
