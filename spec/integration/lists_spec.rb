require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require TireSwing.path(%w(spec grammars lists))

describe Lists::GrammarParser do
  describe ".ast" do
    before(:each) do
      @input = <<-EOD
[1, 2, 3]
[4, 5]
[6, 7,8,9,10]
      EOD
      @result = Lists::GrammarParser.ast(@input)
    end

    it "returns an AST" do
      @result.should be_an_instance_of(Lists::AST::Lists)
    end

    it "has an array of lists" do
      @result.should have(3).lists
    end

    it "has lists with numbers" do
      @result.lists.first.numbers.should == [1, 2, 3]
      @result.lists.last.numbers.should == [6, 7, 8, 9, 10]
    end

  end
end
