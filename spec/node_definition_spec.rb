require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::NodeDefinition do
  module TestNodes
    include TireSwing::NodeDefinition
  end

  it "adds a node method when included" do
    TestNodes.methods.should include("node")
  end

  it "adds a create_node method when included" do
    TestNodes.methods.should include("create_node")
  end

  describe ".node" do
    before(:each) do
      TestNodes.class_eval { node :foo, :bar, :baz }
    end
    after(:each) do
      TestNodes.send(:remove_const, "Foo")
    end

    it "defines a class" do
      TestNodes.constants.should include("Foo")
      TestNodes::Foo.ancestors.should include(TireSwing::Node)
    end

    it "defines a class with an attribute for each of the provided arguments" do
      TestNodes::Foo.instance_methods.should include("bar")
      TestNodes::Foo.instance_methods.should include("baz")
    end

  end

  describe ".create_node" do
    before(:all) do
      TestNodes.class_eval { node :foo_node }
    end
    after(:all) do
      TestNodes.send(:remove_const, "FooNode")
    end

    it "takes a node name as an argument" do
      TestNodes.create_node(:foo_node)
    end

    it "returns an instance of NodeCreator" do
      TestNodes.create_node(:foo_node).should be_an_instance_of(TireSwing::NodeCreator)
    end

    it "instantiates the node creator with the class corresponding to the node name" do
      obj = Object.new
      TireSwing::NodeCreator.should_receive(:new).with(TestNodes::FooNode).and_return(obj)
      TestNodes.create_node(:foo_node).should == obj
    end

  end

end
