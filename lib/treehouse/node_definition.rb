module Treehouse::NodeDefinition

  module NodeClassMethods
    def eval(&blk)
      define_method(:eval, &blk) if block_given?
      public :eval
    end
  end

  module ModuleMethods

    def node(name, parent = Treetop::Runtime::SyntaxNode, &blk)
      klass = Class.new(parent)
      const_set name.to_s.camelize, klass
      klass.extend(NodeClassMethods)
      klass.class_eval &blk if block_given?
      ensure_presence_of_eval(klass)
    end

    private

    def ensure_presence_of_eval(klass)
      unless klass.public_instance_methods.include?("eval")
        klass.class_eval do
          define_method(:eval) {}
          public :eval
        end
      end
    end
  end

  def self.included(base)
    base.extend ModuleMethods
  end
end
