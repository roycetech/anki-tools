class SwiftHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize() super; end
  def keywords_file() return 'keywords_swift.txt'; end
  def comment_marker() return '// '; end
  def highlight_string(input_string) return highlight_quoted(input_string); end


  def highlight_lang_specific(input_string)    
    return input_string
  end

end
