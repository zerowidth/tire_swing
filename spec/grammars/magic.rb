# This demonstrates a grammar making full use of TireSwing's magic nodes to build an AST.

Treetop.load_from_string <<-GRAMMAR

module MagicAssignments
  grammar Grammar
    rule assignments
      ( blank_line / assignment )* <AST.create_node(:assignments)>
    end
    rule assignment
      lhs:variable whitespace* "=" whitespace* rhs:variable [\\n] <AST.create_node(:assignment)>
    end
    rule variable
      [a-z]+ <AST.create_node(:variable)>
    end
    rule whitespace
      [ ]
    end
    rule blank_line
      whitespace* [\\n]
    end
  end
end

GRAMMAR

module MagicAssignments
  module AST
    include TireSwing::NodeDefinition

    node :assignment, :lhs, :rhs
    node :assignments, :assignments => array_of(:assignment)
    node :blank_line # FIXME (nathan) delete
    node :variable, :value => :text_value # FIXME (nathan) delete

  end

  include TireSwing::VisitorDefinition

  visitor :hash_visitor do
    visits AST::Assignments do |assignments|
      hash = {}
      assignments.assignments.each { |child| visit(child, hash) }
      hash
    end
    visits AST::Assignment do |assignment, hash|
      hash[visit(assignment.lhs)] = visit(assignment.rhs)
    end
    visits AST::Variable do |variable|
      variable.value
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).build
    end
  end

end

