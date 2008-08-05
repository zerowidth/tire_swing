require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require TireSwing.path(%w(spec grammars dot_xen))

describe DotXen::Parser, ".parse" do
  before(:each) do
    data = File.read(TireSwing.path(%w(spec fixtures ey00-s00348.xen)))
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

describe DotXen::HashVisitor do
  before(:all) do
    data = File.read(TireSwing.path(%w(spec fixtures ey00-s00348.xen)))
    @ast = DotXen::Parser.parse(data)
  end

  describe ".visit" do
    it "returns a hash representation of the AST" do
      DotXen::HashVisitor.visit(@ast).should == {
        :comments => ["  -*- mode: python; -*-"],
        :disks => [
          "phy:/dev/ey00-data4/root-s00348,sda1,w",
          "phy:/dev/ey00-data4/swap-s00348,sda2,w",
          "phy:/dev/ey00-data4/gfs-00218,sdb1,w!"
        ],
        :vars => {
          "name" => "ey00-s00348",
          "kernel" => "/boot/vmlinuz-2.6.18-xenU",
          "memory" => 712,
          "cpu_cap" => 100,
          "vcpus" => 1,
          "root" => "/dev/sda1 ro",
          "maxmem" => 4096,
          "vif" => ["bridge=xenbr0"]
        }
      }
    end
  end
end

describe DotXen::StringVisitor do
  before(:all) do
    data = File.read(TireSwing.path(%w(spec fixtures ey00-s00348.xen)))
    @ast = DotXen::Parser.parse(data)
  end
  describe ".visit" do
    it "returns a string representation of the AST" do
          DotXen::StringVisitor.visit(@ast).should == <<-EOS
#   -*- mode: python; -*-
kernel = '/boot/vmlinuz-2.6.18-xenU'
memory = 712
maxmem = 4096
name = 'ey00-s00348'
vif = [ 'bridge=xenbr0' ]
root = "/dev/sda1 ro"
vcpus = 1
cpu_cap = 100
disk = [
  "phy:/dev/ey00-data4/root-s00348,sda1,w",
  "phy:/dev/ey00-data4/swap-s00348,sda2,w",
  "phy:/dev/ey00-data4/gfs-00218,sdb1,w!"
]
      EOS
    end
  end
end
