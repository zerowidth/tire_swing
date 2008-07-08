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
      it "returns a class" do
        @node.should be_an_instance_of(Class)
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

  end

end
