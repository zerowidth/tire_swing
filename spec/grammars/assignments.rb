Treetop.load(File.join(File.dirname(__FILE__), "assignments.treetop"))

module AssignmentsLanguage
  module Grammar
    include Treehouse::NodeDefinition

    node :assignments, :assignments do
      traverse do
        env = {}
        assignments.each { |child| child.traverse(env) }
        env
      end
    end

    node :assignment, :lhs, :rhs do
      traverse do |env|
        env[lhs.traverse] = rhs.traverse
      end
    end

    node :blank_line
    node :variable, :value do
      traverse do
        value
      end
    end

  end

  include Treehouse::VisitorDefinition

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
