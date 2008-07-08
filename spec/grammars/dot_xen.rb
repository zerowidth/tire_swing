Treetop.load(File.join(File.dirname(__FILE__), "dot_xen.treetop"))

module DotXen
  module AST
    include Treehouse::NodeDefinition

    node :config_file, :disks, :vars, :comments
    node :assignment, :lhs, :rhs
    node :array_assignment, :lhs, :rhs

    node :array_list, :values

    node :literal_number, :value
    node :literal_string, :value
    node :comment, :text

    node :disk, :volume, :device, :mode do

      # scan the variable list for disk definitions
      def self.build(variables)
        disks = variables.detect { |var| var.lhs.value == "disk" }
        unless disks.nil?
          variables.delete(disks)
          disks.rhs.values.map do |disk|
            volume, device, mode = disk.value.split(/,/)
            new(:volume => volume, :device => device, :mode => mode)
          end
        end
      end
    end

  end

  include Treehouse::VisitorDefinition

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).eval
    end
  end

end
