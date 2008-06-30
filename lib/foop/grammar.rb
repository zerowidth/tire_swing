module Foop
  module Grammar
    Treetop.load(Foop.libpath("foop", "foop"))
    include FoopGrammar
  end
end
