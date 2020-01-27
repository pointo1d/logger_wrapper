#
# Patch the Object class by extending it to add an unfreeze method - needed to
# ensure that the core Logger class can be 'patched'/updated properly i.e.
# without generating unwanted output on STDERR. This is an implementation of t
# he StackOverflow post - https://stackoverflow.com/a/35633368/7317397, by
# https://stackoverflow.com/users/2423164/ndnenkov - to whom all thanks are due
# without reservation
#
class Object
  require 'fiddle'

  def unfreeze
    Fiddle::Pointer.new(object_id * 2)[1] &= ~(1 << 3)
  end
end

#### END OF FILE
