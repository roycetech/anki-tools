# This file contains extensions to exisitng classes.

class Regexp
  def +(regexp)  Regexp.new(self.to_s + '|' + regexp.to_s); end
end
