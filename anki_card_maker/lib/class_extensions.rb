# This file contains extensions to exisitng classes.

# Allow Regexp to be concatenated with +
class Regexp
  def +(regexp)  Regexp.new(self.to_s + '|' + regexp.to_s); end
end
