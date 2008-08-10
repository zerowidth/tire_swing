require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::ParseError do

  describe ".new" do
    it "takes a message and a parser instance" do
      TireSwing::ParseError.new("message", "parser").should be_an_instance_of(TireSwing::ParseError)
    end
  end

  it "has a message" do
    e = TireSwing::ParseError.new("message", "parser")
    e.message.should == "message"
  end

  it "has a parser" do
    e = TireSwing::ParseError.new("message", "parser")
    e.parser.should == "parser"
  end

end
