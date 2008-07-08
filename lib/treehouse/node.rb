module Treehouse
  class Node

    def self.create(*attribs)
      Class.new(self) do
        attribs.each do |attrib|
          attribute(attrib.to_s) { raise "no value given for #{attrib}" }
        end
      end
    end

    def initialize(values={})
      values.each do |name, value|
        send("#{name}=", value)
      end
    end

  end
end
