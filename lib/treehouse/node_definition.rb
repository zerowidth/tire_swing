module Treehouse::NodeDefinition

  module ModuleMethods

    def create_node(name)
      Treehouse::NodeCreator.new(const_get(name.to_s.camelize))
    end

    def node(name, *attribute_names, &blk)
      klass = Treehouse::Node.create *attribute_names
      const_set name.to_s.camelize, klass
      klass.class_eval &blk if block_given?
    end

  end

  def self.included(base)
    base.extend ModuleMethods
  end
end
