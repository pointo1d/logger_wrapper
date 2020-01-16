class LoggerWrapper
  # Module implementing a simple severity level for a Logger wrapper class - which has both value & function where the...
# * Value is the associated severity level
# * Function is a method responsible for appending a given message to a log device subject to an appropriate severity level.
  module Level
    class LevelError            < StandardError; end
    class LevelsAlreadySetError < LevelError; end

      # Unless otherwise overridden when set_levels is called, this is the list of the default severity levels and the order of precedence in order of increasing priority
      DEFAULT_LEVELS = %w(TRACE DEBUG INFO WARN ERROR FATAL ON OFF)

      #attr_accessor :levels, :internal
      #  Method returning the list of severity levels as one of either the default or the currently set levels
      def levels
        @@levels.nil? || @@levels.length == 0 ? DEFAULT_LEVELS : @@levels
      end

    # Set up the internal logger instance once only - at require time
    @@internal ||= LoggerWrapper.internal

    @@levels ||= []

    # Method to define & set the operating severity levels to either the given, or the default, list. The levels are assigned precedence in the order that they appear in the list. Note that this is a WORM operation in as much as once set, they are then fixed for a particular script run; The response should a second call be updated depends on the env var ```LOGW_LEVEL_ERROR``` - if set to non-empty value, then a fatal error ensues, otherwise it's merely a warning.
    def set_levels(*levels)
      @@internal.debug("\#set_levels(#{levels}) - #{@@levels}")

      @@internal.debug("set_levels(): #{ENV['LOGW_LEVEL_ERROR']}")

      if @@levels.nil? || @@levels.length == 0
        levels = DEFAULT_LEVELS if levels.nil? || levels.length == 0
        levels.each_with_index do |l, i|
          n = l.upcase
          @@internal.debug("set_levels(): #{n} (#{l}) = #{i}")
          LoggerWrapper.const_set(n, i)
          @@levels << n
        end
      elsif ENV['LOGW_LEVEL_ERROR']
        raise LevelsAlreadySetError.new
      else
        warn 'WARNING: Levels already set'
      end 

      @@internal.debug("\#set_levels():: #{@@levels}")
    end
  end

  extend Level
end

#### END OF FILE
