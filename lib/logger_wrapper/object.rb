require 'logger'

#
# Thanx be to https://stackoverflow.com/users/276450/six364 and his post on
# StackOverflow (https://stackoverflow.com/a/2292631/7317397) for the
# following which is, at the time of writing, an unashamed copy of the means
# of adding new severity levels to the core Ruby logger - the in-line
# comments are, in the main,  my attempt to understand how it works.
# Additionally to https://stackoverflow.com/users/2423164/ndnenkov and his post
# on StackOverflow () WRT unfreezing an object
#
class Object
  require 'fiddle'

  def unfreeze
    Fiddle::Pointer.new(object_id * 2)[1] &= ~(1 << 3)
  end
end

#### END OF FILE
