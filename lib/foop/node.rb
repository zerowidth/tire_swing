require Foop.libpath("foop", "node_definition")

module FoopGrammar
  class Node < ::Treetop::Runtime::SyntaxNode

    include ::Foop::NodeDefinition

    node :assignment do |node, env|
      env[node.lhs.text_value] = node.rhs.text_value
    end

  end
end
