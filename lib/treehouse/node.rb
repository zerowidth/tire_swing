module Treehouse
  class Node

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
        if mapping(attrib)
          value = parsed_node.send(mapping(attrib))
          if value.kind_of?(Array)
            value = value.map { |v| v.build }
          else
            value = parsed_node.send(mapping(attrib))
          end
          send("#{attrib}=", value)
        else
          send("#{attrib}=", parsed_node.send(attrib).build)
        end
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
