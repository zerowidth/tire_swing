require Foop.libpath("foop", "visitor_definition")

module Foop
  class StringVisitor
    include VisitorDefinition

    visit :assignment do |visitor, node|
      node.lhs.text_value + " = " + node.rhs.text_value
    end

  end
end
