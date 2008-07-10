require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::NodeCreator do

  before(:all) do
    SomeNode = Class.new(Treehouse::Node)
  end
  after(:all) do
    Object.send(:remove_const, "SomeNode")
  end

  describe "#initialize" do

    it "takes a class as an argument" do
      nc = Treehouse::NodeCreator.new(SomeNode)
    end
  end

  describe "#new" do
    before(:each) do
      @nc = Treehouse::NodeCreator.new(SomeNode)
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

    it "creates an instance of the defined class when build is called on the resulting syntax node" do
      node = @nc.new("what", 0..3)
      mock_node = mock("node")
      SomeNode.should_receive(:new).with(node).and_return(mock_node)
      node.build.should == mock_node
    end

  end

end
