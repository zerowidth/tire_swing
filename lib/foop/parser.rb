module Foop
  class Parser < ::Treetop::Runtime::CompiledParser
    include FoopGrammar

    def self.parse(io)
      new.parse(io)
    end
  end
end
