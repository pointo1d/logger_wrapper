#
# Thanx be to https://stackoverflow.com/users/276450/six364 and his post on
# StackOverflow (https://stackoverflow.com/a/2292631/7317397) for the
# following which is, at the time of writing, an unashamed copy of the means
# of adding new severity levels to the core Ruby logger class - the in-line
# comments are, in the main, records, of a sort, of my attempt to understand how
# it works :-).
# Additionally to https://stackoverflow.com/users/2423164/ndnenkov and his post
# on StackOverflow () WRT unfreezing an object
#
class Logger
  def self.custom_level(tag)
    # Thaw the list of existing levels, add the UC version of the new level
    # label to the end of the list of existing levels and freeze the list again
    SEV_LABEL.unfreeze
    SEV_LABEL << tag 
    SEV_LABEL.freeze

    define_method(tag.downcase.gsub(/\W+/, '_').to_sym) do |progname, &block|
      add(SEV_LABEL.size - 1, nil, progname, &block)
    end 
  end 
  
  # now add levels like this:
  custom_level 'TRACE'
end

#### END OF FILE
