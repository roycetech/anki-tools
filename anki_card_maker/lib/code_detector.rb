module CodeDetector


  def self.has_code?(card_lines)
    card_lines.each do |card_line|
      return true if card_line =~ Inline::RE_PATTERN
    end
    true if card_lines.join("\n") =~ Code::RE_WELL
    false
  end


end
