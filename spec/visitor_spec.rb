require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::Visitor do
  before(:each) do
    Object.const_set("Foo", Class.new)
    Object.const_set("Bar", Class.new)
    @visitor = Class.new(TireSwing::Visitor)
  end

  after(:each) do
    Object.send(:remove_const, "Foo")
    Object.send(:remove_const, "Bar")
  end

  describe ".visits" do
    it "takes a node name and a block" do
      @visitor.visits(Foo) { "foo!" }
    end

    it "can create a visitor for multiple classes at once" do
      @visitor.visits(Foo, Bar) { "foo!" }
      @visitor.visit(Foo.new).should == "foo!"
      @visitor.visit(Bar.new).should == "foo!"
    end

  end

  describe "visitors", :shared => true do
    before(:each) do
      @visitor.visits(Foo) { |node| "#{node.class}-foo!" }
    end

    it "takes a node and calls the appropriate block, passing in the node" do
      @visitor_instance.visit(Foo.new).should == "#{Foo}-foo!"
    end

    it "raises an exception if it doesn't know how to handle a node" do
      lambda { @visitor_instance.visit(Bar.new) }.should raise_error(Exception, /Bar/)
    end

    it "calls the visit block with arguments, if arguments are given" do
      @visitor.visits(Bar) { |node, a, b| "#{a}-#{b}" }
      @visitor_instance.visit(Bar.new, "foo", "bar").should == "foo-bar"
    end

  end

  describe ".visit" do
    before(:each) do
      @visitor_instance = @visitor
    end
    it_should_behave_like "visitors"
  end

  describe "#visit" do
    before(:each) do
      @visitor_instance = @visitor.new
    end
    it_should_behave_like "visitors"
  end

end
