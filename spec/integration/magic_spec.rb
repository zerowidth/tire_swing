require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require TireSwing.path(%w(spec grammars magic))

describe MagicAssignments::GrammarParser do
  describe ".ast" do
    before(:each) do
      @input = File.read(TireSwing.path(%w(spec fixtures assignments.txt)))
      @result = MagicAssignments::GrammarParser.ast(@input)
    end

    it "returns an AST" do
      @result.should be_an_instance_of(MagicAssignments::AST::Assignments)
    end

    it "has the right number of assignments" do
      @result.should have(3).assignments
    end

    it "has an assignment with correct values" do
      @result.assignments.first.should be_an_instance_of(MagicAssignments::AST::Assignment)
      @result.assignments.first.lhs.should == "foo"
      @result.assignments.first.rhs.should == "bar"
    end

  end
end

describe MagicAssignments::HashVisitor do
  describe ".visit" do
    it "returns a hash representation of the assignments" do
      ast = MagicAssignments::GrammarParser.ast(File.read(TireSwing.path(%w(spec fixtures assignments.txt))))
      MagicAssignments::HashVisitor.visit(ast).should == {
        "foo" => "bar",
        "baz" => "blech",
        "no" => "way"
      }
    end
  end
end
