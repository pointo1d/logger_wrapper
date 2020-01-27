# Get the standard library logger extensions whilst, at the same time,
# indirectly requiring it for this extension class.
require_relative 'extensions/standard/logger'

# Module attempting to provision a generic wrapper for the core Ruby Logger class - the additional capabilities are (currently) as follows...
# * A configurable threshold level
# * The ability to _switch_ logging on & off
# * Configurable self-logging
class LoggerWrapper < Logger
  #require 'logger_wrapper/object'
  #require 'logger_wrapper/logger'
  #require 'logger_wrapper/manager'
  #require 'logger_wrapper/version'

  # First off, ensure the manager exists
  #@@logger_manager = Manager.new

  #attr_reader :internal
  #@internal = Logger.new(STDERR, 'FATAL')

  # As it says on the tin, defines the default logger threshold as "WARN", but this may be overridden by setting +$DEFAULT_LOGGER_THRESHOLD+ in the run-time environment
  #LOGGER_DEFAULT_THRESHOLD = ENV['LOGGER_DEFAULT_THRESHOLD'] || 'WARN'
#
  # Enables logging internal to this module iff set to true via +$LOGGER_INTERNAL+ in the environment
  #LOGGER_INTERNAL = ! ENV['LOGGER_INTERNAL'].nil?
#
#  class LoggerInterceptor < Logger
#    
#    # Reflects the current logging state - as determined by calls to on() &/or off()
#    attr_reader :enabled
#    
#    def initialize(*args)
#      # Instantiate the internal logger instance
#      @logger = Logger.new(*args)
#
#      # Set default enabled state
#      @enabled = true
#
#      @logger.debug("#{self}.new(#{args}) - logger.level(): #{logger.level}") if
#        LOGGER_INTERNAL
#
#      # Finally instantiate and return the global logger
#      super *args
#    end
#
#    def method_missing(nm, *args, &block)
#      @logger.debug("#{self}.method_missing(#{nm}, #{args}, #{block}) - #{@enabled}")
#
#      if nm.match(/^o(n|ff)$/i)
#        @enabled = nm.match(/^off$/i).nil?
#      elsif @enabled
#        @logger.send(nm, *args, &block)
#      end
#
#      @logger.debug("#{self}.method_missing()::")
#    end
#
#    def self.method_missing(nm, *args, &block)
#      @logger.debug("#{self.class}.method_missing(#{nm}, #{args}, #{block})")
#
#      if nm.match(/^o(n|ff)$/i)
#        @enabled = nm.match(/^off$/i).nil?
#      elsif @enabled
#        @logger.send(nm, *args, &block)
#      end
#
#      @logger.debug("#{self.class}.method_missing()")
#    end
#
#    def respond_to_missing?(nm, *args)
#      return @logger.respond_to?(nm)
#      if nm.match(/^o(n|ff)$/i)
#        @enabled = nm.match(/^off$/i).nil?
#      elsif @enabled
#        @logger.send(nm, *args, &block)
#      end
#
#      @logger.debug("#{self.class}.method_missing()")
#    end
#
#    def respond_to_missing?(nm, *args)
#      return @logger.respond_to?(nm)
#
#    end
#
#    # Override Core::warn() - which would otherwise respond to calls
#    # to self.warn()
#    def warn(*args)
#      @logger.send(:warn, *args) if @enabled
#    end
#
#  def self.included(base)
#    @logger.debug "#{self}::included(#{base})"
#    decl_unqual_calls
#    @logger.debug "#{self}::included()::"
#  end
#
#  def self.extended(base)
#    @logger.debug "#{self}::extended(#{base})"
#    decl_unqual_calls
#    @logger.debug "#{self}::extended()::"
#  end
#
#  private
#    # Private class method to allow simple i.e. unqualified by '$Logger.', calls to the base class i.e. Logger
#    def self.decl_unqual_calls
#      @logger.debug "#{self}::decl_unqual_calls()"
#      
#      (Logger.instance_methods - Object.methods).each do |l|
#        @logger.debug "#{self}::decl_unqual_calls() - Trying #{l}..."
#        next if respond_to? l
#
#        @logger.debug "#{self}::decl_unqual_calls() - Defining #{l}"
#        define_method l.to_sym do |args|
#          @logger.send(l, *args) if @enabled
#        end
#      end
#
#      @logger.debug "#{self}::decl_unqual_calls()::"
#    end
#
#    # Instantiate the logger at the earliest opporchancity
#    @logger ||= LoggerInterceptor.new(
#      ENV['LOGGER_FNAME'] || STDERR,
#      level: ENV['LOGGER_THRESHOLD'] || LOGGER_DEFAULT_THRESHOLD || 'FATAL'
#    )
#
#    @logger.debug "#{self}::decl_unqual_calls - $Logger:: #{$Logger}, level:: #{$Logger.level}"
#  end
end

#### END OF FILE
