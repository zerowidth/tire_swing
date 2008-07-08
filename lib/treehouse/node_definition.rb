module Treehouse::NodeDefinition

  module NodeClassMethods
    def traverse(&blk)
      define_method(:traverse, &blk) if block_given?
    end
  end

  module ModuleMethods

    def node(name, *attribute_names, &blk)
      klass = Treehouse::Node.create *attribute_names
      const_set name.to_s.camelize, klass
      klass.extend(NodeClassMethods)
      klass.class_eval &blk if block_given?
      ensure_presence_of_traverse(klass)
    end

    private

    def ensure_presence_of_traverse(klass)
      unless klass.instance_methods.include?("traverse")
        klass.class_eval do
          define_method(:traverse) {}
        end
      end
    end
  end

  def self.included(base)
    base.extend ModuleMethods
  end
end
