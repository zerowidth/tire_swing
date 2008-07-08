Treetop.load(File.join(File.dirname(__FILE__), "assignments.treetop"))

module AssignmentsLanguage
  module Grammar
    include Treehouse::NodeDefinition
    include Treehouse::VisitorDefinition

    node :assignments do
      eval do
        env = {}
        elements.each { |child| child.eval(env) }
        env
      end
    end

    node :assignment do
      eval do |env|
        env[lhs.text_value] = rhs.text_value
      end
    end

    node :blank_line
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io)
    end
  end

end
