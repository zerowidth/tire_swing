Treetop.load(File.join(File.dirname(__FILE__), "assignments.treetop"))

module AssignmentsLanguage
  module Grammar
    include Treehouse::NodeDefinition

    node :assignments do
      eval do
        env = {}
        elements.each { |child| child.eval(env) }
        env
      end
    end

    node :assignment do
      eval do |env|
        env[lhs.eval] = rhs.eval
      end
    end

    node :blank_line
    node :variable do
      eval do
        text_value
      end
    end

  end

  include Treehouse::VisitorDefinition

  visitor :string_visitor do
    visits Grammar::Assignments do |assignments|
      assignments.elements.map { |child| visit(child) }.compact.join("")
    end
    visits Grammar::Assignment do |assignment|
      visit(assignment.lhs) + " = " + visit(assignment.rhs) + "\n"
    end
    visits Grammar::BlankLine do
      nil
    end
    visits Grammar::Variable do |variable|
      variable.text_value
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io)
    end
  end

end
