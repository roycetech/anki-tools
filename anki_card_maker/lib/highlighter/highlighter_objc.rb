

class ObjCHighlighter < BaseHighlighter


  def initialize() super; end
  def keywords_file() return 'keywords_objc.txt'; end
  def comment_marker() return '// '; end
  def highlight_string(input_string) return highlight_quoted(input_string); end


  def highlight_lang_specific(string_input)
    string_input.gsub!(/(\/\*[\d\D]\*\/)/, '<span class="comment">\1</span>')
    return string_input    
  end


end
