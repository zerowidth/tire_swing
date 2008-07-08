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

    it "defines a class with a traverse class method" do
      TestNodes.const_get("Foo").methods.should include("traverse")
    end

    it "defines a class with an attribute for each of the provided arguments" do
      TestNodes::Foo.instance_methods.should include("bar")
      TestNodes::Foo.instance_methods.should include("baz")
    end

    describe "without a traverse block" do
      it "defines a traverse method on the node" do
        TestNodes.class_eval { node :no_traverse }
        TestNodes.const_get("NoTraverse").public_instance_methods.should include("traverse")
      end
    end

    describe "with a traverse block" do
      it "defines a traverse method with the given block" do
        TestNodes.class_eval { node(:with_traverse, :value) { traverse { |arg| "xx_#{arg}_#{value}_xx"} } }
        node = TestNodes.const_get("WithTraverse").new(:value => "what")
        node.traverse("asdf").should == "xx_asdf_what_xx"
      end
    end

  end

end
