module TireSwing

  module ParserExtension

    def ast(io)
      parser = new
      result = parser.parse(io)
      if result
        result.build
      else
        raise TireSwing::ParseError.new(parser.failure_reason, parser)
      end
    end

  end

  # Extends the treetop-provided grammar parser with a .ast class method for simple parsing and building of
  # an AST defined by TireSwing. Takes the grammar module as an argument.
  #
  # Additionally, this defines a #node method on the grammar to delegate to the class or the AST to create
  # new nodes, e.g. <node(:variable)> instead of <AST.create_node(:variable)>
  #
  # You can specify an alternate module which contains the AST if desired.
  def self.parses_grammar(grammar, ast=nil)
    parser = (grammar.to_s + "Parser").constantize
    ast ||= grammar
    parser.module_eval do
      extend ParserExtension
      define_method(:node) { |*args| ast.create_node(*args) }
    end
  end

end
