require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib tire_swing]))

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # borrowed from rspec_on_rails' mock_model
  def mock_syntax_node(name, stubs={})
    m = mock "mock syntax node (#{name})", stubs
    m.send(:__mock_proxy).instance_eval do
      def @target.is_a?(other)
        Treetop::Runtime::SyntaxNode.ancestors.include?(other)
      end
      def @target.kind_of?(other)
        Treetop::Runtime::SyntaxNode.ancestors.include?(other)
      end
      def @target.instance_of?(other)
        other == Treetop::Runtime::SyntaxNode
      end
      def @target.class
        Treetop::Runtime::SyntaxNode
      end
    end
    yield m if block_given?
    m
  end

end
