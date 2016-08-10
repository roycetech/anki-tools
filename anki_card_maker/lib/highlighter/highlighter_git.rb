class GitHighlighter < BaseHighlighter


  def initialize() super(HighlightersEnum::GIT); end
  def keywords_file() return 'keywords_git.txt'; end
  def comment_regex() RegextrationStore::CommentBuilder.new.none.build; end
  def string_regex() quote_double_regex; end

  def regexter_singles(parser)
      parser.regexter('option', /-[a-z-]+\b/, lambda { |token, regexp| HtmlUtil.span('opt', token)})
  end

end
