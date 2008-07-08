require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require Treehouse.path(%w(spec grammars dot_xen))

describe DotXen::Parser, ".parse" do
  before(:each) do
    data = File.read(Treehouse.path(%w(spec fixtures ey00-s00348.xen)))
    @ast = DotXen::Parser.parse(data)
  end
  it "returns an AST" do
    @ast.should_not be_nil
  end

  describe "with a parsed AST" do
    it "has a comment" do
      @ast.should have(1).comments
    end

    it "has 3 disks" do
      @ast.should have(3).disks
    end

    it "has vars" do
      @ast.should have_at_least(5).vars
    end

  end

end
