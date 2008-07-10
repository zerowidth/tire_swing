require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require Treehouse.path(%w(spec grammars magic))

describe MagicAssignments::Parser do
  describe ".parse" do
    before(:each) do
      @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
      @result = MagicAssignments::Parser.parse(@input)
    end

    it "returns an AST" do
      @result.should be_an_instance_of(MagicAssignments::AST::Assignments)
    end

    it "has the right number of nodes" do
      @result.should have(7).assignments
    end

    it "has an assignment with correct values" do
      @result.assignments.first.should be_an_instance_of(MagicAssignments::AST::Assignment)
      @result.assignments.first.lhs.value.should == "foo"
      @result.assignments.first.rhs.value.should == "bar"
    end

  end
end
