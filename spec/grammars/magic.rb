Treetop.load(File.join(File.dirname(__FILE__), "magic.treetop"))

module MagicAssignments
  module AST
    include Treehouse::NodeDefinition

    node :assignments, :assignments => :elements
    node :assignment, :lhs, :rhs
    node :blank_line
    node :variable, :value => :text_value

  end

  include Treehouse::VisitorDefinition

  visitor :string_visitor do
    visits AST::Assignments do |assignments|
      assignments.assignments.map { |child| visit(child) }.compact.join("")
    end
    visits AST::Assignment do |assignment|
      visit(assignment.lhs) + " = " + visit(assignment.rhs) + "\n"
    end
    visits AST::BlankLine do
      nil
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
