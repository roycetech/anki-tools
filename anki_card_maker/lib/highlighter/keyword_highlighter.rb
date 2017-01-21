require './lib/utils/html_utils'

#
class KeywordHighlighter
  include HtmlUtils

  # argument must be truthy and has contents.
  def initialize(keywords_filename)
    raise 'Keywords required' unless keywords_filename
    @keywords = get_keywords(keywords_filename)
    raise 'Keywords required' if @keywords.empty?
  end

  def get_keywords(keywords_file)
    File.read("./data/#{keywords_file}").lines.collect(&:chomp)
  end

  def register_to(parser)
    regexp = /(?<!\.|-|(?:[\w]))(?:#{ @keywords.join('|') })\b/
    lambda = ->(token, _regexp) { wrap(:keyword, token) }
    parser.regexter('keyword', regexp, lambda)
  end
end
