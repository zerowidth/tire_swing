# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'tire_swing'

task :default => 'spec:run'

PROJ.name = 'tire_swing'
PROJ.authors = 'Nathan Witmer'
PROJ.email = 'nwitmer at gmail dot com'
PROJ.url = 'http://github.com/aniero/tire_swing'
PROJ.rubyforge.name = ''
PROJ.version = TireSwing.version

PROJ.spec.opts << '--color --format specdoc'

# EOF

depend_on "treetop"
depend_on "attributes"
depend_on "activesupport", ">= 2.0.2"
