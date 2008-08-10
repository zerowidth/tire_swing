# More magic: handle recursive rules

Treetop.load_from_string <<-GRAMMAR

module Lists
  grammar Grammar
    rule lists
      (list [\n])+ <AST.create_node(:lists)>
    end
    
    rule list
      "[" whitespace* number ("," whitespace* number)* "]" <AST.create_node(:list)>
    end

    rule number
      [1-9] [0-9]* <AST.create_node(:number)>
    end

    rule whitespace
      [ ]
    end
  end
end

GRAMMAR

module Lists
  module AST
    include TireSwing::NodeDefinition
    node :lists, :elements, :lists => extract(:list)
    node :list, :elements, :numbers => array_of(:number, true) { |number| number.text_value.to_i }
    node :number
  end

  class Lists::GrammarParser
    def self.ast(io)
      parser = new
      result = parser.parse(io)
      if result
        result.build
      else
        raise "oh noes"
      end
    end
  end

end

