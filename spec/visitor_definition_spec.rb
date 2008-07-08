require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::VisitorDefinition::Visitor do
  before(:each) do
    Object.const_set("Foo", Class.new)
    Object.const_set("Bar", Class.new)
    @visitor = Class.new(Treehouse::VisitorDefinition::Visitor)
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

describe Treehouse::VisitorDefinition, "when included" do
  before(:each) do
    @nodes = Module.new
    @nodes.class_eval do
      include Treehouse::VisitorDefinition
    end
    Object.const_set("Foo", Class.new)
  end
  after(:each) do
    Object.send(:remove_const, "Foo")
  end

  it "adds a visitor method" do
    @nodes.methods.should include("visitor")
  end

  describe ".visitor" do
    it "defines a class" do
      @nodes.class_eval { visitor :printer }
      @nodes.constants.should include("Printer")
    end

    it "defines a class that inherits from a Visitor" do
      @nodes.class_eval { visitor :printer }
      @nodes.const_get("Printer").ancestors.should include(Treehouse::VisitorDefinition::Visitor)
    end

    it "defines a class with a visits class method" do
      @nodes.class_eval { visitor :printer }
      @nodes.const_get("Printer").methods.should include("visits")
    end

    it "takes a block with which to define visitors" do
      @nodes.class_eval do
        visitor :printer do
          visits Foo
        end
      end
      @nodes.const_get("Printer").nodes.keys.should include(@nodes.const_get("Foo"))
    end

  end

end
