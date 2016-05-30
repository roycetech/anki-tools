class CppHighlighter < BaseHighlighter


  def initialize() super; end
  def keywords_file() return 'keywords_cpp.txt'; end
  def comment_marker() return '// '; end
  def highlight_string(input_string) return highlight_dblquoted(input_string); end


end  # end of RubyHighlighter class
