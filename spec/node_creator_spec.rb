require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::NodeCreator do

  before(:all) do
    SomeNode = Class.new(TireSwing::Node)
  end
  after(:all) do
    Object.send(:remove_const, "SomeNode")
  end

  describe "#initialize" do

    it "takes a node name and a node class as arguments" do
      nc = TireSwing::NodeCreator.new(:some_node, SomeNode)
    end
  end

  describe "#new" do
    before(:each) do
      @nc = TireSwing::NodeCreator.new(:some_node, SomeNode)
    end

    it "takes parameters as if it were a treetop syntax node" do
      @nc.new("what", 0..3)
    end

    it "returns a treetop syntax node" do
      node = @nc.new("what", 0..3)
      node.should be_an_instance_of(Treetop::Runtime::SyntaxNode)
    end

    it "defines a build method on the syntax node" do
      node = @nc.new("what", 0..3)
      node.methods.should include("build")
    end

    it "defines a node_to_build method on the syntax node that returns the kind of ast node it's going to build" do
      node = @nc.new("what", 0..3)
      node.node_to_build.should == :some_node
    end

    it "creates an instance of the defined class when build is called on the resulting syntax node" do
      node = @nc.new("what", 0..3)
      mock_node = mock("node")
      SomeNode.should_receive(:new).with(node).and_return(mock_node)
      node.build.should == mock_node
    end

  end

end
