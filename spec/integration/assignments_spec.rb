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

describe AssignmentsLanguage::Parser, ".parse" do

  before(:each) do
    @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
  end

  it "parses a file and returns a Treetop AST" do
    AssignmentsLanguage::Parser.parse(@input).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
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

describe AssignmentsLanguage do
  it "has a string visitor defined" do
    AssignmentsLanguage.const_get("StringVisitor").ancestors.should include(Treehouse::Visitor)
  end
end

describe AssignmentsLanguage::StringVisitor do
  before(:each) do
    @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
    @ast = AssignmentsLanguage::Parser.parse(@input)
  end

  describe "#visit" do
    it "traverses the AST and collects the values" do
      AssignmentsLanguage::StringVisitor.visit(@ast).should == "foo = bar\nbaz = blech\nno = way\n"
    end
  end
end
