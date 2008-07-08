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
      TestNodes.class_eval { node :foo }
    end
    after(:each) do
      TestNodes.send(:remove_const, "Foo")
    end

    it "defines a class" do
      TestNodes.constants.should include("Foo")
    end

    it "defines a class that inherits from a Treetop syntax node" do
      TestNodes.const_get("Foo").ancestors.should include(Treetop::Runtime::SyntaxNode)
    end

    it "defines a class with an eval class method" do
      TestNodes.const_get("Foo").methods.should include("eval")
    end

    # it occurs to me that overwriting eval is a bad idea....
    describe "without an eval block" do
      it "defines a public eval method on the node" do
        TestNodes.class_eval { node :no_eval }
        TestNodes.const_get("NoEval").public_instance_methods.should include("eval")
      end
    end

    describe "with an eval block" do
      it "defines a public eval method with the given block" do
        TestNodes.class_eval { node(:with_eval) { eval { |arg| "xx_#{arg}_#{text_value}_xx"} } }
        node = TestNodes.const_get("WithEval").new("what", 0..3)
        node.eval("asdf").should == "xx_asdf_what_xx"
      end
    end

  end

end
