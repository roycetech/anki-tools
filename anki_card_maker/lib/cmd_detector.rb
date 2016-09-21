class CmdDetector

  def self.has_cmd?(array)
    array.each { |item| return true if item =~ /^\$.*/ }
    false
  end

end