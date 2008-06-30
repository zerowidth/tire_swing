require File.dirname(__FILE__) + '/spec_helper'

describe Foop::Parser do

  describe ".parse" do
    before(:all) do
      @result = Foop::Parser.parse("lol=what")
    end
    it "returns something" do
      @result.should_not be_nil
    end
    it "returns a FoopGrammar::Node object" do
      @result.should be_an_instance_of(FoopGrammar::Node)
    end
    describe "#eval" do
      before(:each) do
        @eval = @result.eval({})
      end
      it "returns a hash containing the assignments" do
        @eval.should == {"lol" => "what"}
      end
    end
  end
  
end
