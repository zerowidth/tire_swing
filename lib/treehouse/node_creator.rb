module Treehouse
  class NodeCreator

    def initialize(node_class)
      @node_class = node_class
    end

    def new(*args)
      parsed_node = Treetop::Runtime::SyntaxNode.new(*args)

      node_class = @node_class # local scope for the block below
      # TODO don't define this method if it already exists (e.g. inline eval, etc.)
      parsed_node.meta_def :build do
        node_class.new(self)
      end

      parsed_node
    end

  end
end
