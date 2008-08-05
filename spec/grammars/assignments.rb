Treetop.load(File.join(File.dirname(__FILE__), "assignments.treetop"))

module AssignmentsLanguage
  module Grammar
    include TireSwing::NodeDefinition

    node :assignments, :assignments
    node :assignment, :lhs, :rhs
    node :blank_line
    node :variable, :value

  end

  include TireSwing::VisitorDefinition

  visitor :string_visitor do
    visits Grammar::Assignments do |assignments|
      assignments.assignments.map { |child| visit(child) }.compact.join("")
    end
    visits Grammar::Assignment do |assignment|
      visit(assignment.lhs) + " = " + visit(assignment.rhs) + "\n"
    end
    visits Grammar::BlankLine do
      nil
    end
    visits Grammar::Variable do |variable|
      variable.value
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).eval
    end
  end

end
