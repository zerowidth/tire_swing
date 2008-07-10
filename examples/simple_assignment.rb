require File.join(File.dirname(__FILE__), "..", "lib", "treehouse")

Treetop.load_from_string <<-GRAMMAR
module SimpleAssignment
  grammar Grammar
    rule assignment
      lhs:variable space* "=" space* rhs:variable <AST.create_node(:assignment)>
    end
    rule variable
      [a-z]+ <AST.create_node(:variable)>
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
    include Treehouse::NodeDefinition
    node :assignment, :lhs, :rhs
    node :variable, :value => :text_value
  end

  include Treehouse::VisitorDefinition

  # Define a simple visitor to walk the AST and build a hash
  visitor :hash_visitor do
    visits AST::Assignment do |assignment|
      { visit(assignment.lhs) => visit(assignment.rhs) }
    end
    visits AST::Variable do |var|
      var.value
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).build
    end
  end

end

require "pp"
ast = SimpleAssignment::Parser.parse("foo=bar")
puts "----- AST -----"
pp ast
puts "\n----- visitor output -----"
pp SimpleAssignment::HashVisitor.visit(ast)
