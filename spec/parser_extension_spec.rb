require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::ParserExtension do

  it "defines a parses_grammar method on TireSwing" do
    TireSwing.should respond_to(:parses_grammar)
  end

  describe "when given a grammar" do
    module Foo; end
    class FooParser; end
    module AST; end

    it "extends the parser for that grammar with the ParserExtension module, defining an ast method" do
      TireSwing.parses_grammar(Foo)
      FooParser.should respond_to(:ast)
    end

    it "defines a node method on the parser that delegates to the grammar" do
      TireSwing.parses_grammar(Foo)
      Foo.should_receive(:create_node).with("a", "b", "c")
      FooParser.new.node("a", "b", "c")
    end

    it "defines a create_node method on the parser that delegates to the given AST, if provided" do
      TireSwing.parses_grammar(Foo, AST)
      AST.should_receive(:create_node).with("a", "b", "c")
      FooParser.new.node("a", "b", "c")
    end

  end

  describe "#ast" do
    before(:all) do

      Treetop.load_from_string <<-GRAMMAR
module TestGramma
  grammar Grammar
    rule letters
      letter* <node(:letters)>
    end
    rule letter
      value:[a-z] [\n]? <node(:letter)>
    end
  end
end
      GRAMMAR

      module ::TestGramma
        module AST
          include TireSwing::NodeDefinition
          node :letters, :letters => array_of(:letter)
          node :letter, :value
        end
        TireSwing.parses_grammar(Grammar, AST)
      end

    end

    after(:all) do
      Object.send(:remove_const, "TestGramma")
    end

    it "takes an AST and returns the built AST" do
      asdf = TestGramma::GrammarParser.ast("asdf")
      asdf.should be_an_instance_of ::TestGramma::AST::Letters
      asdf.should have(4).letters
      asdf.letters.map { |l| l.value }.should == %w(a s d f)
    end

    describe "with invalid input" do

      it "raises an exception with" do
        lambda { parse }.should raise_error(TireSwing::ParseError, /as3f.*\^/m)
      end

      def parse
        TestGramma::GrammarParser.ast("as3f")
      end
    end


  end

end
