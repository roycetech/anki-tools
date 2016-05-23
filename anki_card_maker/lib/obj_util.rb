module ObjUtil


  def self.nvl(arg1, when_null)
    # return when_null unless arg1
    return arg1.nil? ? when_null : arg1
  end


  def self.nvl2(arg1, when_null, when_not_null)
    if arg1
      when_not_null
    else
      when_null
    end
  end

end
