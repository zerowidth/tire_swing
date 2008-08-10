require File.join(File.dirname(__FILE__), "..", "lib", "tire_swing")

Treetop.load_from_string <<-GRAMMAR
module SimpleAssignment
  grammar Grammar
    rule assignment
      lhs:variable space* "=" space* rhs:variable <create_node(:assignment)>
    end
    rule variable
      [a-z]+ <create_node(:variable)>
    end
    rule space
      [ ]+
    end
  end
end
GRAMMAR

module SimpleAssignment

  # Define nodes for the AST
  module AST
    include TireSwing::NodeDefinition
    node :assignment, :lhs, :rhs
    node :variable, :value => :text_value
  end

  include TireSwing::VisitorDefinition

  # Define a simple visitor to walk the AST and build a hash
  visitor :hash_visitor do
    visits AST::Assignment do |assignment|
      { visit(assignment.lhs) => visit(assignment.rhs) }
    end
    visits AST::Variable do |var|
      var.value
    end
  end

  # Set up the parser helper, pointing to the grammar and the AST
  # This defines GrammarParser.ast on the Treetop-provided GrammarParser.
  TireSwing.parses_grammar(Grammar, AST)

end

require "pp"
ast = SimpleAssignment::GrammarParser.ast("foo=bar")
puts "----- AST -----"
pp ast
puts "\n----- visitor output -----"
pp SimpleAssignment::HashVisitor.visit(ast)
