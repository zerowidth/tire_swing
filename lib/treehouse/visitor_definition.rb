require Treehouse.libpath(%w(treehouse visitor))

module Treehouse::VisitorDefinition

  module ModuleMethods
    def visitor(name, &blk)
      klass = Class.new(Treehouse::Visitor)
      const_set name.to_s.camelize, klass
      klass.class_eval &blk if block_given?
    end
  end

  def self.included(base)
    base.extend ModuleMethods
  end

end
