module TireSwing
  class NodeCreator

    # Creates a node creator for the given node class. This is meant to act as a stand-in for the treetop
    # syntax node class.
    #
    def initialize(node_class)
      @node_class = node_class
    end

    # Returns a new treetop syntax node to act as a standin for a normal syntax node. Before returning the node, 
    # this defines a build method on the syntax node that will instantiate the node class using the auto-build
    # functionality. If this build method isn't enough, you'll have to define one yourself inline in the treetop
    # gramamr.
    #
    def new(*args)
      parsed_node = Treetop::Runtime::SyntaxNode.new(*args)

      node_class = @node_class # local scope for the block below
      parsed_node.meta_def :build do
        node_class.new(self)
      end

      parsed_node
    end

  end
end
