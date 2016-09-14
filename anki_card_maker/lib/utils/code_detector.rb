require './html/inline'

module CodeDetector


  def self.has_code?(card_lines)
    return_value = false

    card_lines.each do |card_line|
      return true if card_line =~ Inline::RE_PATTERN
    end

    single_block = card_lines.join "\n"    
    return  string_block =~ Code::RE_WELL
  end

end

puts CodeDetector.has_code?(['`one`'])
puts CodeDetector.has_code?(['one', '```Hello'])
