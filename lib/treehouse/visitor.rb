module Treehouse

  # Represents a visitor for an AST. See Treehouse::VisitorDefinition more more information.
  #
  class Visitor

    class << self

      # Describe a visitor block for a given node type. If no block is given, an empty lambda is used.
      # The block always takes at least one argument, an instance of the node you're visiting, as well
      # as any additional arguments if desired.
      #
      def visits(*constants, &blk)
        constants.each do |constant|
          nodes[constant] = (blk || lambda {})
        end
      end

      # Visit the given node using the visitor mapping defined with .visits.
      # This finds the block to call for the given node and calls it with the node and additional arguments, if any.
      #
      # Raises an exception if no visitor is found for the given node.
      #
      def visit(node, *args)
        block = visitor_for(node)
        if args.empty?
          block.call(node)
        else
          block.call(node, *args)
        end
      end

      protected

      # Node class / lambda mapping
      def nodes
        @nodes ||= {}
      end

      # Look up a visitor block for this node
      def visitor_for(node)
        nodes[node.class] or raise "could not find visitor definition for #{node.class}: #{node.inspect}"
      end

    end

  end

end