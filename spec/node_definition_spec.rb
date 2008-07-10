require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::NodeDefinition do
  module TestNodes
    include Treehouse::NodeDefinition
  end

  it "adds a node method when included" do
    TestNodes.methods.should include("node")
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
      TestNodes::Foo.ancestors.should include(Treehouse::Node)
    end

    it "defines a class with an attribute for each of the provided arguments" do
      TestNodes::Foo.instance_methods.should include("bar")
      TestNodes::Foo.instance_methods.should include("baz")
    end

  end

end
