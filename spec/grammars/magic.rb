# This demonstrates a grammar making full use of TireSwing's magic nodes to build an AST.

Treetop.load_from_string <<-GRAMMAR

module MagicAssignments
  grammar Grammar
    rule assignments
      ( blank_line / assignment )* <node(:assignments)>
    end
    rule assignment
      lhs:variable whitespace* "=" whitespace* rhs:variable [\\n] <node(:assignment)>
    end
    rule variable
      [a-z]+
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
  end

  include TireSwing::VisitorDefinition

  visitor :hash_visitor do
    visits AST::Assignments do |assignments|
      hash = {}
      assignments.assignments.each { |child| visit(child, hash) }
      hash
    end
    visits AST::Assignment do |assignment, hash|
      hash[assignment.lhs] = assignment.rhs
    end
  end

  TireSwing.parses_grammar(Grammar, AST)

end

