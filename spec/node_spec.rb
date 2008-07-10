require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse::Node do

  describe ".create" do
    it "returns a class that inherits from Treehouse::Node" do
      klass = Treehouse::Node.create
      klass.should be_an_instance_of(Class)
      klass.ancestors.should include(Treehouse::Node)
    end

    describe "with attribute names" do
      before(:each) do
        @node = Treehouse::Node.create(:foo, :bar)
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
        @node = Treehouse::Node.create(:lhs => :left_value, :rhs => :right_value)
      end

      it "creates a class with attributes matching the hash keys" do
        @node.attributes.should == ["lhs", "rhs"]
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
        @node = Treehouse::Node.create(:one, :two, :three => :value)
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
      @node = Treehouse::Node.create(:child, :value => :data)
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
        @child = mock_syntax_node :build => "child value"
        @top = mock_syntax_node :child => @child, :data => "data"
      end

      it "sets the named values by calling build on the named child node" do
        @top.should_receive(:child).and_return(@child)
        @child.should_receive(:build).and_return("child value")
        n = @node.new(@top)
        n.child.should == "child value"
      end

      it "calls the specified method directly for hash values" do
        @top.should_receive(:data).and_return do
          puts "called from #{caller.detect {|c| c !~ /rspec/}}"
          "foo"
        end
        n = @node.new(@top)
        n.value.should == "foo"
      end

      it "calls build on each element of a referenced node value if that value is an array" do
        @top.should_receive(:child).and_return([@child, @child])
        @child.should_receive(:build).exactly(2).times.and_return("one", "two")
        n = @node.new(@top)
        n.child.should == %w(one two)
      end

      it "only calls build on elements of an array if they respond to that method" do
        @top.should_receive(:child).and_return([@child, "blah"])
        @node.new(@top).child.should == ["child value", "blah"]
      end

    end
  end

end
