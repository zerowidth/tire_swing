module Foop
  module VisitorDefinition
    module ClassMethods
      def visit(name, &visit_block)
        visitors[name.to_s.camelize] = visit_block
      end
      def visitors
        @visitors ||= {}
      end
    end

    module InstanceMethods
      def visit(node)
        pp node
        node_type = node.extension_modules.first.to_s.sub(/\d+$/, "").demodulize
        block = self.class.visitors[node_type] or raise "no eval block defined for node #{node_type}"
        block.call(self, node)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end