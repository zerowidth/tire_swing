require TireSwing.libpath(%w(tire_swing visitor))

module TireSwing::VisitorDefinition

  module ModuleMethods

    # Define a visitor class with the given name.
    #
    #   visitor :string_visitor
    #
    # Creates StringVisitor in the local scope.
    #
    # This method takes a block, which is evaluated in the context of the new visitor class. Since the visitor
    # class is a subclass of TireSwing::Visitor, you have node visitor definition methods available.
    # (See TireSwing::Visitor)
    #
    # Given an AST built with
    #
    #   node :assignment, :lhs, :rhs
    #   node :variable, :value
    #
    # Define a visitor:
    #
    #   visitor :hash_visitor do
    #     visits Assignment do |assignment|
    #       hash = {}
    #       hash[ visit(assignment.lhs) ] = visit(assignment.rhs) # visitors are entirely external to the AST
    #     end
    #     visits Variable do |var|
    #       var.value
    #     end
    #   end
    #
    # And call it:
    #
    #   HashVisitor.visit( assignment_node )
    #
    # Note that this is using class_eval, so you can define methods inside, including overrides to #visit.
    #
    # Note also that this is just a wrapper for:
    #
    #   class MyVisitor < TireSwing::Visitor
    #     visits ...
    #   end
    #
    def visitor(name, &blk)
      klass = Class.new(TireSwing::Visitor)
      const_set name.to_s.camel_case, klass
      klass.class_eval &blk if block_given?
    end
  end

  def self.included(base)
    base.extend ModuleMethods
  end

end
