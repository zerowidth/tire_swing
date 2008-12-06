require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::ParseError do

  describe ".new" do
    it "takes a message and a parser instance" do
      TireSwing::ParseError.new("message", "parser").should be_an_instance_of(TireSwing::ParseError)
    end

    it "does not require a parser instance" do
      TireSwing::ParseError.new("message").message.should == "message"
    end
  end

  it "is a subclass of StandardError" do
    TireSwing::ParseError.new("message", "parser").should be_a_kind_of(StandardError)
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
