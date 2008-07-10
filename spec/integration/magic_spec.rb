require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require Treehouse.path(%w(spec grammars magic))

describe MagicAssignments::Parser do
  describe ".parse" do
    before(:each) do
      @input = File.read(Treehouse.path(%w(spec fixtures assignments.txt)))
      @result = MagicAssignments::Parser.parse(@input)
    end

    it "actually works" do
      @result.should be_an_instance_of(MagicAssignments::AST::Assignments)
      @result.assignments.first.should be_an_instance_of(MagicAssignments::AST::Assignment)
      @result.assignments.first.lhs.value.should == "foo"
    end
  end
end
