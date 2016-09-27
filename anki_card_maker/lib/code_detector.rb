require './lib/html/inline'
require './lib/html/code'


module CodeDetector


  def has_code?(card_lines)
    return true if has_inline?(card_lines)
    has_well?(card_lines)
  end


  def has_inline?(card_lines)
    card_lines.each do |card_line|
      return true if card_line =~ Inline::RE_PATTERN
    end
    false 
  end


  def has_well?(card_lines)
    card_lines.join("\n") =~ Code::RE_WELL
  end


  def has_command?(code_block)
    code_block =~ /```\w*\n(\$ .*\n)+```/
  end


end
