require File.join(File.dirname(__FILE__), %w[spec_helper])

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
      @nodes.const_get("Printer").ancestors.should include(Treehouse::Visitor)
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
