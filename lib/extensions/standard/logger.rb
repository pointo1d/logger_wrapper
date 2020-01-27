# Require and implement the Object monkey patch
require_relative '../core/object'

# Now require the core Logger - the class we're intending to patch
require 'logger'

#
# Now proceed with the extension update to add extra severity levels as follows:
# * Printing...
#   * **CALLRET** - level associated with logging calls (```entry()``` &
#                   ```exit()```) at method entry &/or exit enabling the
#                   switchining on or off of both entry() & exit() logging
#                   calls so, at a stroke
#   * **TRACE** - ad-hoc, very low level logging.
# * Non-printing i.e. control...
# * **OFF** - disables logging, saving the current level.
# * **ON** - re-enable logging at the previously saved level.
#
class Logger
  # Re-implement the Severity module to define the new level defining constants
  module Severity
    # Extend the defined severity levels using those defined in the parent as
    # the basis - as with the core logger, the added severity levels have an
    # associated method - some of which generate log entries, others of which 
    # provide in-line control of the logging control and consequently have no
    # asociated log output
    sevs = [ :TRACE, *(constants.sort_by { |s| const_get(s) }), :OFF, :ON ]

    # Having now generated the list of constants, CALLRET needs to be added in
    # immediately after DEBUG and then the list used as the basis for the
    sevs.insert(sevs.index(:DEBUG) + 1, :CALLRET).each_with_index do |sev, val|
      # First off, remove the constant iff it's already set
      remove_const(sev) if const_defined?(sev)

      # set it
      const_set(sev, val)
    end

    # Finally, create "aliases" for CALLRET associated with the entry() and
    # eit() calls
    %w(ENTRY EXIT).each { |e| const_set(e, CALLRET) }
  end

  # Attempt to update the default message severity labels record - by
  # unfreezing, removing, re-defining & finally re-freezing the constant
  SEV_LABEL.unfreeze
  remove_const(:SEV_LABEL)
  SEV_LABEL = (
    Severity.constants.sort_by { |s|
      Severity.const_get(s) }.map { |s| s.to_s }
  ).freeze

  # Severity level setter - records the last printing/generating level in
  # @old_level i.e. @old_level is (s/b :) agnostic to levels of :OFF or :ON
  def level=(severity)
    # Normalise the given severity level (to const)
    new_level = severity.is_a?(Integer) ?
      severity : Logger::Severity.const_get(severity.upcase)

    # Determine the new and record of the old, setting
    @level = case new_level
      when OFF
        @old_level = @level
        @level = new_level
      when ON
        @level = @old_level
      else
        @old_level = @level || new_level
        @level = new_level
    end

    raise ArgumentError, "Invalid log level: #{severity}" unless @level
    @level
  end

  # Severity level constant list retrieval - sorted iff the arg is true
  def levels(sorted = nil)
    ret = Severity.constants
    ret = ret.sort_by { |s| Severity.const_get(s.upcase) } if sorted
    ret
  end

  # Now define the various level specific methods
  Severity.constants.each do |sev|
    # Establish the method name base
    name_base = sev.to_s.downcase

    # Get current level
    define_method(:"#{name_base}?") do level <= Severity.const_get(sev); end

    # Set current level
    define_method(:"#{name_base}!") do self.level = Severity.const_get(sev); end

    # Log update/control method
    case name_base
      when /o(ff|n)/
        define_method(:"#{name_base}") { |*args| self.level = sev; }
      when 'callret'
        %w(entry exit).each do |m|
          define_method(:"#{m}") do |progname = nil, &block|
            add(Severity.const_get(sev), nil, progname, &block)
          end

          define_method(:"#{m}!") do |progname = nil, &block|
            add(Severity.const_get(sev), nil, progname, &block)
          end

          define_method(:"#{m}?") do |progname = nil, &block|
            add(Severity.const_get(sev), nil, progname, &block)
          end
        end
      else
        define_method(:"#{name_base}") do |progname = nil, &block|
          add(Severity.const_get(sev), nil, progname, &block)
        end
    end
  end
end

#### END OF FILE
