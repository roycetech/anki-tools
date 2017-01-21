require './lib/html/inline'
require './lib/html/code'

#
module CodeDetector
  def code?(card_lines)
    inline?(card_lines) || well?(card_lines)
  end

  def inline?(card_lines)
    card_lines.each do |card_line|
      return true if card_line =~ Inline::RE_PATTERN
    end
    false
  end

  # param can be code block or string array
  def well?(array_or_codeblock)
    source = if array_or_codeblock.is_a?(Array)
               array_or_codeblock.join("\n")
             else
               array_or_codeblock
             end
    !(source =~ Code::RE_WELL).nil?
  end

  def command?(code_block)
    !(code_block =~ Code::RE_CMD_WELL).nil?
  end
end
