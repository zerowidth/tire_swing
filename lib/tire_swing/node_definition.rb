module TireSwing::NodeDefinition

  module ModuleMethods

    # Returns a NodeCreator to act as a stand-in for a node class in the treetop parser.
    # According to the treetop metagrammar, node class definitions can have more than just a class in them.
    #
    # Given the initial grammar,
    #
    #   rule variable
    #     [a-z]+ <Variable>
    #   end
    #
    # you might instead use use the AST node auto-build functionality. Given
    #
    #   node :variable, :value => :text_value
    #
    # You can define the grammar as
    #
    #   rule variable
    #     [a-z]+ <node(:variable)>
    #   end
    #
    # and voila, you'll magically have a Variable node with a #value attribute containing the text value.
    #
    # Also note that you can specify alternate namespaces:
    #
    #   module AST
    #     node :variable
    #   end
    #
    #   <AST.create_node(:variable)>
    #
    # and when you're using the parser extension, tell the parser about the namespace
    #
    #   TireSwing.parses_grammar(Grammar, AST)
    #
    # and then you can use the shortest possible syntax,
    #
    #   <node(...)>
    #
    # which is an instance method wrapper for the create_node class method.
    #
    def create_node(name)
      TireSwing::NodeCreator.new(name, const_get(name.to_s.camelize))
    end

    # Define a node.
    #
    # This creates a new class (a subclass of TireSwing::Node) with the given attribute names.
    #
    # Attribute names can be lists of symbols (simple attributes) and/or a hash of name-value pairs (mapped attributes).
    # The new class will have attributes matching the names and hash keys given. More on the hash values in a minute.
    #
    #   node :foo
    #
    # Creates a Foo class in the local scope.
    #
    #   node :calculation, :left, :right, :operator => lambda { |node| node.elements[1] }
    #
    # Creates a Calculation class with left, right, and operator attributes.
    #
    # There are two ways to instantiate a class generated by this method.
    #
    # The first method is to provide a hash with name/value pairs for the attributes:
    #
    #   c = Calculation.new(:left => "lhs", :right => "rhs", :operator => "=")
    #   c.left # => "lhs"
    #
    # If an attribute isn't initialized in this way, you will get an exception if you try to access it.
    #
    # This simple way of instantiating a node can be used in a grammar to build an AST with these nodes manually.
    #
    # The second method takes a treetop syntax node and auto-builds the node using the syntax node as a basis.
    # The auto-build functionality uses the attribute names and mapped attributes in the following way:
    #
    # * Simple attributes: calls the method by that name on the syntax node, e.g.
    #
    #   node :assignment, :lhs, :rhs
    #
    # * Mapped attributes:
    #   * symbol/string - call that method on *either* the node, if it responds, or on its text value (e.g. #to_i)
    #
    #     node :number, :value => :to_i # calls to_i on the number node's text value
    #
    #   * lambda - yields the parsed node to the lambda
    #
    #   Whatever the value (or array of values) is returned by the mapped call will then be built. Any item returned
    #   that responds to the build method will have it called. If there's any bare syntax nodes left over, they are
    #   converted into their text value, and anything else will be returned as-is (numbers, strings, etc.)
    #
    #   Note that you can use the array_of and extract helpers defined below to define lambdas for doing more advanced
    #   filtering on the node and it's children.
    #
    # Simple example:
    #
    #   rule assignment
    #     variable:lhs "=" variable:rhs <node(:assignment)>
    #   end
    #   rule variable
    #     [a-z]+
    #   end
    #
    #   node :assignment, :lhs, :rhs
    #
    #   Assignment.new(syntax_node) will return an instance with an lhs and rhs set from that node.
    #
    # If a block is given, the block is evaluated in the context of the new class (for method definitions, etc.) e.g.
    #
    #   node :foo do
    #     def name; "hello!"; end
    #   end
    #   Foo.new.name #=> "hello!"
    #
    def node(name, *attribute_names, &blk)
      klass = TireSwing::Node.create *attribute_names
      const_set name.to_s.camelize, klass
      klass.class_eval &blk if block_given?
    end

    # Returns a lambda to select only child nodes of the given kind. This is best used for rules that can return
    # arrays of different kind of nodes, some of which you want to ignore, e.g.:
    #
    #   rule assignments
    #     assignment* <node(:assignments)>
    #   end
    #
    #   node :assignments, :assignments => array_of(:assignment)
    #
    # When parsed, this will give you a recursive set of nodes:
    #
    #   [assignment, [assignment, [assignment]]]
    #
    # If you specify that the array is recursive, it will retrieve all nested child nodes, no matter how deep, which
    # provide the kind of node you want.
    #
    # If you provide a block, the filtered result will be yielded to the block and returned as the final result.
    #
    def array_of(kind, recursive = true, &blk)
      lambda do |node|
        result = NodeFilters.filter(node, kind, recursive)
        blk ? result.map(&blk) : result
      end
    end

    # Returns a lambda which takes a node and calls node_name on each in turn if possible, returning the result.
    # This is useful for nested rules, such as:
    #
    #   rule assignments
    #     (assignment [\n])+
    #   end
    #
    # This is a subtle difference from array_of. The rule given here provides a syntax node with multiple elements,
    # each one corresponding to the grouping, not to an individual child node -- that is, it's a list of
    # [[assignment node, newline node], [assignment, newline], ...] instead of being a flattened list of
    # [assignment, newline, assignment, newline, ...].
    #
    # To extract these:
    #
    #   node :assignments, :assignments => extract(:assignment)
    #
    # Which will extract just the assignments out of those "nested children", and then do what you expect from there.
    #
    def extract(node_name)
      lambda do |node|
        results = []
        results << node.send(node_name) if node.respond_to?(node_name)

        results.push *node.elements.select { |elem| elem.respond_to?(node_name) }.map { |elem| elem.send(node_name) }

        results
      end
    end

  end

  module NodeFilters

    def self.filter(node, kind, recursive)
      nodes = []
      children = node.respond_to?(:elements) ? (node.elements || []) : []
      if recursive
        nodes << node if node.respond_to?(:node_to_build) && node.node_to_build == kind
        children.each { |child| nodes.push *filter(child, kind, true) }
      else
        nodes = ([node] + children).select { |n| n.respond_to?(:node_to_build) && n.node_to_build == kind }
      end
      nodes
    end

  end

  # Include this module to get access to the node and create_node class methods.
  #
  #   module AST
  #     include NodeDefinition
  #     node :foo
  #   end
  #
  def self.included(base)
    base.extend ModuleMethods
  end
end
