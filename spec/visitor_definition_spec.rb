require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::VisitorDefinition, "when included" do
  before(:each) do
    @nodes = Module.new
    @nodes.class_eval do
      include TireSwing::VisitorDefinition
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
      @nodes.const_get("Printer").ancestors.should include(TireSwing::Visitor)
    end

    it "defines a class with a visits class method" do
      @nodes.class_eval { visitor :printer }
      @nodes.const_get("Printer").methods.should include("visits")
    end

    it "evaluates at a class level to allow for attribute definitions and more" do
      @nodes.class_eval do
        visitor(:printer) { attr_accessor :thingy }
      end
      @nodes.const_get("Printer").new.should respond_to(:thingy=)
    end

  end

end
