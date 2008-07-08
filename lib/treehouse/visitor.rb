module Treehouse

  class Visitor

    class << self
      def visits(constant, &blk)
        nodes[constant] = (blk || lambda {})
      end

      def nodes
        @nodes ||= {}
      end

      def visit(node, *args)
        block = visitor_for(node)
        if args.empty?
          block.call(node)
        else
          block.call(node, *args)
        end
      end

      protected

      def visitor_for(node)
        nodes[node.class] or raise "could not find visitor definition for #{node.class}"
      end

    end

  end

end