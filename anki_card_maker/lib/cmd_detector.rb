class CmdDetector

  def self.has_cmd?(array)
    return_value = false
    array.each do |item|
      if item =~ /^\$.*/
        return_value = true
        break
      end 
    end
    return_value
  end

end