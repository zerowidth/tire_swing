require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Treehouse do

  it "is versioned" do
    Treehouse.version.should =~ /\d+\.\d+\.\d+/
  end

  it "can generate a libpath" do
    Treehouse.libpath("what").should == File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "what"))
  end

  it "can generate a path" do
    Treehouse.path("what").should == File.expand_path(File.join(File.dirname(__FILE__), "..", "what"))
  end

end
