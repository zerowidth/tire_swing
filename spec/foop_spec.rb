require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Foop do
  it "loads up the treetop grammar" do
    lambda { FoopGrammar }.should_not raise_error
  end
end
