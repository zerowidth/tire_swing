# More magic: handle recursive rules

Treetop.load_from_string <<-GRAMMAR

module Lists
  grammar Grammar
    rule lists
      (list [\n])+ <node(:lists)>
    end
    
    rule list
      "[" whitespace* number ("," whitespace* number)* "]" <node(:list)>
    end

    rule number
      [1-9] [0-9]* <node(:number)>
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
    node :list, :elements, :numbers => array_of(:number) { |num| num.text_value.to_i }
    node :number # placeholder
  end

  TireSwing.parses_grammar(Grammar, AST)
end
