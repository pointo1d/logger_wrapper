require 'lumberjack'

class Lumberjack < Logger
  # Module providing easy i.e. without mandating a preceding Lumberjack
  # instance qualifier, access to the logging message generation calls. Note
  # that, as you might expect, the instance prefix is mandatory for all other
  # calls where the simple method name is not unique in the namespace.
  module Easy
    def self.included(base)
    end

    def self.extended(base)
    end
  end
end

#### END OF FILE
