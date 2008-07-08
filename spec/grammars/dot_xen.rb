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
    node :single_quoted_string, :value
    node :double_quoted_string, :value

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

  visitor :hash_visitor do
    visits(AST::ConfigFile) do |config_file|
      hash = {:comments => [], :vars => {}, :disks => []}
      config_file.comments.each { |comment| visit(comment, hash) }
      config_file.vars.each { |var| visit(var, hash) }
      config_file.disks.each { |disk| visit(disk, hash) }
      hash
    end

    visits AST::Assignment do |assignment, hash|
      hash[:vars][visit(assignment.lhs)] = visit(assignment.rhs)
    end

    visits AST::ArrayAssignment do |array, hash|
      hash[:vars][visit(array.lhs)] = visit(array.rhs)
    end

    visits AST::ArrayList do |list|
      list.values.map { |value| visit(value) }
    end

    visits AST::Comment do |comment, hash|
      hash[:comments] << comment.text
    end

    visits AST::Disk do |disk, hash|
      hash[:disks] << [disk.volume, disk.device, disk.mode].join(",")
    end

    visits AST::LiteralString, AST::LiteralNumber, AST::SingleQuotedString, AST::DoubleQuotedString do |literal|
      literal.value
    end
  end

  visitor :string_visitor do
    visits(AST::ConfigFile) do |config_file|
      strings = []
      config_file.comments.each { |comment| visit(comment, strings) }
      config_file.vars.each { |var| visit(var, strings) }
      if config_file.disks
        strings << "disk = [\n"
        strings << config_file.disks.map { |disk| "  " + visit(disk) }.join(",\n")
        strings << "\n]\n"
      end
      strings.flatten.join("")
    end

    visits AST::Assignment, AST::ArrayAssignment do |assignment, strings|
      strings << [visit(assignment.lhs), " = ", visit(assignment.rhs), "\n"]
    end

    visits AST::ArrayList do |list|
      ["[ ", list.values.map { |value| visit(value) }.join(",\n"), " ]"]
    end

    visits AST::Comment do |comment, strings|
      strings << "# #{comment.text}\n"
    end

    visits AST::Disk do |disk|
      "\"" + [disk.volume, disk.device, disk.mode].join(",") + "\""
    end

    visits AST::LiteralString, AST::LiteralNumber do |literal|
      literal.value
    end

    visits AST::SingleQuotedString do |literal|
      "'" + literal.value + "'"
    end

    visits AST::DoubleQuotedString do |literal|
      '"' + literal.value + '"'
    end
  end

  class Parser < ::Treetop::Runtime::CompiledParser
    include Grammar
    def self.parse(io)
      new.parse(io).eval
    end
  end

end
