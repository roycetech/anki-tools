class CSharpHighlighter < BaseHighlighter


  def initialize(param=HighlightersEnum::CSHARP)
    super
  end

  
  def keywords_file() 'keywords_csharp.txt'; end

  def comment_regex()
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex() quote_double_regex() end

  def regexter_blocks(parser)
    parser.regexter('annotations', /^\[.*\]$/m, lambda { |token, regexp| 
      token
    })    
  end

end
