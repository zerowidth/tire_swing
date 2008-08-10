module TireSwing
  class ParseError < StandardError
    attr_reader :parser
    def initialize(message, parser)
      @parser = parser
      super(message)
    end
    # TODO add in pretty error formatting, given the parser and the message
  end
end
