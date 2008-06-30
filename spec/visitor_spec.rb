require File.dirname(__FILE__) + '/spec_helper'

describe Foop::Visitor do

  describe "with a parsed result" do
    before(:all) do
      @result = Foop::Parser.parse("lol=what")
    end
    it "has an AST" do
      @result.should_not be_nil
    end
    describe "#visit with a Visitor" do
      before(:each) do
        @visitor = Foop::Visitor.new
      end
      it "returns a nice representation of the parsed file" do
        @result.accept(@visitor).should == "lol = what"
      end
    end
  end
  
end
