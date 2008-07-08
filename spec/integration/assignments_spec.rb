require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require Treehouse.path(%w(spec grammars assignments))

describe AssignmentsLanguage::Grammar do

  it "has nodes defined" do
    consts = AssignmentsLanguage::Grammar.constants
    consts.should include("Assignments")
    consts.should include("Assignment")
    consts.should include("BlankLine")
  end

end

describe AssignmentsLanguage::Grammar::Assignments do
  before(:each) do
    @a = AssignmentsLanguage::Grammar::Assignments
  end
  it "has an eval instance method" do
    @a.instance_methods.should include("eval")
  end
end

describe AssignmentsLanguage::Parser do

  before(:each) do
    @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
  end

  describe ".parse" do
    it "parses a file and returns a Treetop AST" do
      AssignmentsLanguage::Parser.parse(@input).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
    end
  end

end

describe AssignmentsLanguage::Grammar::Assignments do
  before(:each) do
    @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
    @ast = AssignmentsLanguage::Parser.parse(@input)
  end

  describe "#eval on a parsed AST" do
    it "returns a hash containing the parsed assignments" do
      @ast.eval.should == {"foo"=>"bar", "baz"=>"blech", "no"=>"way"}
    end
  end

end
