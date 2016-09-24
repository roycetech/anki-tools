# This file contains extensions to exisitng classes.
require './lib/utils/oop_utils'
require './lib/assert'


# Allow Regexp to be concatenated with +
class Regexp 
  def +(regexp) Regexp.new(self.to_s + '|' + regexp.to_s) end
end

Object.class_eval { include Assert, OopUtils }