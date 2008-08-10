require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::NodeDefinition do
  module TestNodes
    include TireSwing::NodeDefinition
  end

  before(:all) do
    TestNodes.class_eval { node :foo_node }
  end

  after(:all) do
    TestNodes.send(:remove_const, "FooNode")
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

    it "takes a node name as an argument" do
      TestNodes.create_node(:foo_node)
    end

    it "returns an instance of NodeCreator" do
      TestNodes.create_node(:foo_node).should be_an_instance_of(TireSwing::NodeCreator)
    end

    it "instantiates the node creator for the given node name" do
      obj = Object.new
      TireSwing::NodeCreator.should_receive(:new).with(:foo_node, TestNodes::FooNode).and_return(obj)
      TestNodes.create_node(:foo_node).should == obj
    end

  end

  describe ".array_of" do

    it "returns a lambda" do
      TestNodes.array_of(:foo_node).should be_an_instance_of(Proc)
    end

    it "returns a lambda that filters a node's elements for nodes that will build the given node type" do
      a, b = mock_syntax_node("a", :node_to_build => :foo_node), mock_syntax_node("b", :node_to_build => :foo_node)
      node = mock_syntax_node("node", :elements => [1, 2, a, 3, b])
      TestNodes.array_of(:foo_node).call(node).should == [a, b]
    end

    it "will return the node itself if it provides the given node type" do
      node = mock_syntax_node("node", :node_to_build => :foo)
      TestNodes.array_of(:foo).call(node).should == [node]
    end

    it "does not filter recursively by default" do
      b = mock_syntax_node("b", :elements => ["stuff", "whatever"], :node_to_build => :foo)
      a = mock_syntax_node("a", :elements => ["jkl", b], :node_to_build => :foo)
      top = mock_syntax_node("top", :elements => ["asdf", a], :node_to_build => :foo)
      TestNodes.array_of(:foo).call(top).should == [top, a]
    end

    describe "with the recursive flag" do
      it "returns a lambda that filters recursively for the right kind of child" do
        b = mock_syntax_node("b", :elements => ["stuff", "whatever"], :node_to_build => :foo)
        a = mock_syntax_node("a", :elements => ["jkl", b], :node_to_build => :foo)
        top = mock_syntax_node("top", :elements => ["asdf", a], :node_to_build => :foo)
        TestNodes.array_of(:foo, true).call(top).should == [top, a, b]
      end
    end

    describe "with a block provided" do
      it "yields the filtered results to the block" do
        a = mock_syntax_node("a", :node_to_build => :foo_node, :x => 1)
        b = mock_syntax_node("b", :node_to_build => :foo_node, :x => 2)
        node = mock_syntax_node("node", :elements => [1, 2, a, 3, b])
        yielded = []
        array_of = TestNodes.array_of(:foo_node) { |node| yielded << node; node.x }
        array_of.call(node).should == [1, 2]
        yielded.should == [a, b]
      end
    end

  end

  describe ".extract" do

    it "returns a lambda" do
      TestNodes.extract(:thing).should be_an_instance_of(Proc)
    end

    it "extracts all nodes by calling the given node name wherever it applies" do
      q = mock_syntax_node("q")
      a = mock_syntax_node("a", :value => q)
      b = mock_syntax_node("b")
      c = mock_syntax_node("c", :value => "c")
      node = mock_syntax_node("node", :elements => [a, b, c])
      TestNodes.extract(:value).call(node).should == [q, "c"]
    end

    it "will extract the given node as well as the nested children " do
      a = mock_syntax_node("a", :value => "a")
      b = mock_syntax_node("b")
      c = mock_syntax_node("c", :value => "c")
      node = mock_syntax_node("node", :value => "foo", :elements => [a, b, c])
      TestNodes.extract(:value).call(node).should == ["foo", "a", "c"]
    end

  end

end
