require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::NodeDefinition, "when included" do
  before(:each) do
    @nodes = Module.new
    @nodes.class_eval do
      include Treehouse::NodeDefinition
    end
  end

  it "adds a node method" do
    @nodes.methods.should include("node")
  end

  describe ".node" do
    it "defines a class" do
      @nodes.class_eval { node :foo }
      @nodes.constants.should include("Foo")
    end

    it "defines a class that inherits from a Treetop syntax node" do
      @nodes.class_eval { node :foo }
      @nodes.const_get("Foo").ancestors.should include(Treetop::Runtime::SyntaxNode)
    end

    it "defines a class with an eval class method" do
      @nodes.class_eval { node :foo }
      @nodes.const_get("Foo").methods.should include("eval")
    end

    # it occurs to me that overwriting eval is a bad idea....
    describe "without an eval block" do
      it "defines a public eval method on the node" do
        @nodes.class_eval { node :foo }
        @nodes.const_get("Foo").public_instance_methods.should include("eval")
      end
    end

    describe "with an eval block" do
      it "defines a public eval method with the given block" do
        @nodes.class_eval { node(:foo) { eval { |arg| "xx_#{arg}_#{text_value}_xx"} } }
        node = @nodes.const_get("Foo").new("what", 0..3)
        node.eval("asdf").should == "xx_asdf_what_xx"
      end
    end

  end

end
