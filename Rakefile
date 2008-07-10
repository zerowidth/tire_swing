# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'treehouse'

task :default => 'spec:run'

PROJ.name = 'treehouse'
PROJ.authors = 'Nathan Witmer'
PROJ.email = 'nwitmer at gmail dot com'
PROJ.url = 'http://github.com/aniero/treehouse'
PROJ.rubyforge.name = ''
PROJ.version = Treehouse.version

PROJ.spec.opts << '--color --format specdoc'

# EOF

depend_on "attributes"
depend_on "activesupport"
