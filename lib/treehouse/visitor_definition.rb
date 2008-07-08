module Treehouse::VisitorDefinition

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

  module ModuleMethods
    def visitor(name, &blk)
      klass = Class.new(Visitor)
      const_set name.to_s.camelize, klass
      klass.class_eval &blk if block_given?
    end
  end

  def self.included(base)
    base.extend ModuleMethods
  end

end
