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


  # param can be code block or string array
  def has_well?(array_or_codeblock)    
    source = array_or_codeblock.kind_of?(Array) ? array_or_codeblock.join("\n") : array_or_codeblock
    !!(source  =~ Code::RE_WELL)
  end


  def has_command?(code_block)
    !!(code_block =~ Code::RE_CMD_WELL)
  end


end
