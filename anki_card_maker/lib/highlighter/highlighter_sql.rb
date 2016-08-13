class SqlHighlighter < BaseHighlighter


  def initialize()
    super(HighlightersEnum::SQL)
  end
  
  def keywords_file() return 'keywords_sql.txt'; end
  def comment_regex
    RegextrationStore::CommentBuilder.new.c.sql.build
  end

  def string_regex
    quote_single_regex()
  end

end
