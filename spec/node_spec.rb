require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing::Node do

  describe ".create" do
    it "returns a class that inherits from TireSwing::Node" do
      klass = TireSwing::Node.create
      klass.should be_an_instance_of(Class)
      klass.ancestors.should include(TireSwing::Node)
    end

    describe "with attribute names" do
      before(:each) do
        @node = TireSwing::Node.create(:foo, :bar)
      end

      it "creates a class with the given attributes" do
        n = @node.new(:foo => 1, :bar => 2)
        n.foo.should == 1
        n.bar.should == 2
      end

      it "creates attributes with a default of raising an exception if not initialized" do
        n = @node.new(:foo => 1) # no :bar
        n.foo.should == 1
        lambda { n.bar }.should raise_error(RuntimeError, "no value given for bar")
      end

    end

    describe "with an attribute hash" do
      before(:each) do
        @node = TireSwing::Node.create(:lhs => :left_value, :rhs => :right_value)
      end

      it "creates a class with attributes matching the hash keys" do
        @node.attributes.sort.should == ["lhs", "rhs"]
      end

      it "creates attributes with a default of raising an exception if not set" do
        n = @node.new
        lambda { n.lhs }.should raise_error(RuntimeError, "no value given for lhs")
      end

      it "returns a class with an attribute mapping" do
        @node.attribute_mapping.should == {"lhs" => :left_value, "rhs" => :right_value}
      end

    end

    describe "with a mix of named attributes and hash attributes" do
      before(:each) do
        @node = TireSwing::Node.create(:one, :two, :three => :value)
      end

      it "creates a class with attributes matching the named attributes and hash keys" do
        @node.attributes.should == %w(one two three)
      end

      it "updates the attribute mapping" do
        @node.attribute_mapping.should == {"three" => :value}
      end

    end

  end

  describe ".new" do
    before(:each) do
      @node = TireSwing::Node.create(:child, :value => :data)
    end

    describe "with empty args" do
      it "initializes a node without touching the attributes" do
        n = @node.new
        lambda { n.child }.should raise_error(RuntimeError)
      end
    end

    describe "with a hash" do
      it "initializes each of the attributes to the given value" do
        n = @node.new(:child => 1, :value => 2)
        n.child.should == 1
        n.value.should == 2
      end
    end

    describe "with an instance of Treetop::Runtime::SyntaxNode" do
      before(:each) do
        @child = mock_syntax_node
        @top = mock_syntax_node
      end

      describe "for a node with a single attribute as a named method" do
        it "retrieves the value for the attribute by calling the named method" do
          @node = TireSwing::Node.create(:foo => :a_method)
          @top.should_receive(:a_method).and_return("asdf")
          @node.new(@top).foo.should == "asdf"
        end
      end

      describe "for a node with an attribute naming a child syntax node" do
        it "retrieves the value by calling build on the child" do
          @top.should_receive(:child).and_return(@child)
          @node = TireSwing::Node.create(:foo => :child)
          @child.should_receive(:build).and_return("child value")
          @node.new(@top).foo.should == "child value"
        end

        it "calls text_value on the child if the child doesn't have a build method" do
          @top.should_receive(:child).and_return(@child)
          @node = TireSwing::Node.create(:foo => :child)
          @child.should_receive(:text_value).and_return("child value")
          @node.new(@top).foo.should == "child value"
        end

        it "retrieves the value of each item in an array if the named attribute returns one" do
          @child.should_receive(:build).and_return("child")
          @top.should_receive(:children).and_return(["foo", 1, @child])
          TireSwing::Node.create(:foo => :children).new(@top).foo.should == ["foo", 1, "child"]
        end

      end

      it "yields the syntax node instance if a named attribute is a lambda" do
        @node = TireSwing::Node.create(:value => lambda { |x| @x = x; "asdf" })
        @node.new(@top).value.should == "asdf"
        @x.should == @top
      end

    end
  end

end
