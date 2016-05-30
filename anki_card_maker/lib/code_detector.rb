module CodeDetector


  def self.has_code?(string_array)
    return_value = false
    string_array.each do |element|
      if element =~ Inline::RE_PATTERN
        return_value = true
        break
      end
    end

    if not return_value
      string_block = string_array.join "\n"
      return_value = string_block =~ Code::RE_WELL
    end

    ObjUtil.nvl(return_value, false)
  end

end

CodeDetector.has_code?(['`one`'])
