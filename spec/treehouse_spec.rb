require File.join(File.dirname(__FILE__), %w[spec_helper])

describe TireSwing do

  it "is versioned" do
    TireSwing.version.should =~ /\d+\.\d+\.\d+/
  end

  it "can generate a libpath" do
    TireSwing.libpath("what").should == File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "what"))
  end

  it "can generate a path" do
    TireSwing.path("what").should == File.expand_path(File.join(File.dirname(__FILE__), "..", "what"))
  end

end
