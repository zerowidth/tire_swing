require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::Visitor do
  before(:each) do
    Object.const_set("Foo", Class.new)
    Object.const_set("Bar", Class.new)
    @visitor = Class.new(Treehouse::Visitor)
  end

  after(:each) do
    Object.send(:remove_const, "Foo")
    Object.send(:remove_const, "Bar")
  end

  describe ".visits" do
    it "takes a node name and a block" do
      @visitor.visits(Foo) { "foo!" }
    end
  end

  describe "#visit" do
    before(:each) do
      @visitor.visits(Foo) { |node| "#{node.class}-foo!" }
    end

    it "takes a node and calls the appropriate block, passing in the node" do
      @visitor.visit(Foo.new).should == "#{Foo}-foo!"
    end

    it "raises an exception if it doesn't know how to handle a node" do
      lambda { @visitor.visit(Bar.new) }.should raise_error(Exception, /Bar/)
    end

    it "calls the visit block with arguments, if arguments are given" do
      @visitor.visits(Bar) { |node, a, b| "#{a}-#{b}" }
      @visitor.visit(Bar.new, "foo", "bar").should == "foo-bar"
    end

  end

end
