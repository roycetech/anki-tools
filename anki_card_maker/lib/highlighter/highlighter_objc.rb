require './lib/highlighter/base_highlighter'
require './lib/regextration_store'


class ObjCHighlighter < BaseHighlighter


  def initialize() super end
  def keywords_file() 'keywords_objc.txt' end
  def comment_marker() return '// ' end
  def highlight_string(input_string) highlight_quoted(input_string); end



end
