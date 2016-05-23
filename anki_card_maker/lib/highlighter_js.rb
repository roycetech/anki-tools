class JsHighlighter < BaseHighlighter

  def initialize() super; end
  def keywords_file() return 'keywords_js.txt'; end
  def comment_marker() return '// '; end
  def highlight_string(input_string) return highlight_quoted(input_string); end

end
