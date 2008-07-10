module Treehouse
  class Node

    # Create a new node class with the given attributes.
    # 
    def self.create(*attribs)
      Class.new(self) do
        attribs.each do |attrib|
          case attrib
          when Symbol, String
            attribute(attrib.to_s) { raise "no value given for #{attrib}" }
          when Hash
            attrib.each do |name, symbol|
              attribute(name.to_s) { raise "no value given for #{name}" }
              attribute_mapping[name.to_s] = symbol
            end
          end
        end
      end
    end

    def self.attribute_mapping
      @attribute_mapping ||= {}
    end

    # Instantiate a new AST node.
    # Values can either be a hash of values (simple case) or a Treetop syntax node instance (automatic building)
    # 
    def initialize(values={})
      if values.kind_of?(Treetop::Runtime::SyntaxNode)
        build_from_parsed_node(values)
      else
        values.each do |name, value|
          send("#{name}=", value)
        end
      end
    end

    protected

    def build_from_parsed_node(parsed_node)
      attributes.each do |attrib|
        # TODO handle lambda mappings for even more customizability
        value = mapping(attrib) ? parsed_node.send(mapping(attrib)) : parsed_node.send(attrib)
        value = value.map { |val| val.respond_to?(:build) ? val.build : val } if value.kind_of?(Array)
        value = value.build if value.respond_to?(:build)
        send("#{attrib}=", value)
      end
    end

    def attributes
      self.class.attributes
    end

    def mapping(name)
      self.class.attribute_mapping[name]
    end

  end

end
