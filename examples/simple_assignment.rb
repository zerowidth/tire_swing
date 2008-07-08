require File.join(File.dirname(__FILE__), "..", "lib", "treehouse")

Treetop.load_from_string <<-GRAMMAR
module SimpleAssignment
  grammar Grammar
    rule assignment
      lhs:literal "=" rhs:literal {
        def eval
          AST::Assignment.new(:lhs => lhs.eval, :rhs => rhs.eval)
        end
      }
    end
    rule literal
      [a-zA-Z]+ {
        def eval
          AST::Literal.new(:value => text_value)
        end
      }
    end
  end
end
GRAMMAR

module SimpleAssignment

  # define nodes
  module AST
    include Treehouse::NodeDefinition
    node :assignment, :lhs, :rhs
    node :literal, :value
  end

  include Treehouse::VisitorDefinition

  # define a simple visitor to walk an AST
  visitor :hash_visitor do
    visits AST::Assignment do |assignment|
      { visit(assignment.lhs) => visit(assignment.rhs) }
    end
    visits AST::Literal do |literal|
      literal.value
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).eval
    end
  end

end

require "pp"
ast = SimpleAssignment::Parser.parse("foo=bar")
puts "----- AST -----"
pp ast
puts "\n----- visitor output -----"
pp SimpleAssignment::HashVisitor.visit(ast)
