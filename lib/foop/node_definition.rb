module Foop
  module NodeDefinition
    module ClassMethods
      def node(name, &eval_block)
        nodes[name.to_s.camelize] = eval_block
      end
      def nodes
        @nodes ||= {}
      end
    end

    module InstanceMethods
      def eval(env={})
        node_type = extension_modules.first.to_s.sub(/\d+$/, "").demodulize
        block = self.class.nodes[node_type] or raise "no eval block defined for node #{node_type}"
        block.call(self, env)
        env
      end
      
      def accept(visitor)
        visitor.visit(self)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
