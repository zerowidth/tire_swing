Gem::Specification.new do |s|
  s.name = %q{treehouse}
  s.version = "0.0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Witmer"]
  s.date = %q{2008-07-08}
  s.description = %q{Simple node and visitor definitions for Treetop grammars.}
  s.email = %q{nwitmer at gmail dot com}
  s.extra_rdoc_files = ["History.txt", "README.txt", "spec/fixtures/assignments.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "examples/simple_assignment.rb", "lib/treehouse.rb", "lib/treehouse/node.rb", "lib/treehouse/node_definition.rb", "lib/treehouse/visitor.rb", "lib/treehouse/visitor_definition.rb", "spec/fixtures/assignments.txt", "spec/fixtures/ey00-s00348.xen", "spec/grammars/assignments.rb", "spec/grammars/assignments.treetop", "spec/grammars/dot_xen.rb", "spec/grammars/dot_xen.treetop", "spec/integration/assignments_spec.rb", "spec/integration/dot_xen_spec.rb", "spec/node_definition_spec.rb", "spec/node_spec.rb", "spec/spec_helper.rb", "spec/visitor_definition_spec.rb", "spec/visitor_spec.rb", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake", "treehouse.tmproj"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aniero/treehouse}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Simple node and visitor definitions for Treetop grammars}
end