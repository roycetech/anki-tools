

class JsHighlighter < BaseHighlighter


  def initialize
    super(HighlightersEnum::JS)
  end

  def keywords_file() return 'keywords_js.txt'; end
  def string_regex() quote_both_regex; end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build; 
  end


end
