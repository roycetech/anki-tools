module ObjUtil


  def self.nvl(arg1, when_nil)
    return arg1.nil? ? when_nil : arg1
  end

end
