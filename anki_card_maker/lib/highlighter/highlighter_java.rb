class JavaHighlighter < BaseHighlighter


  include RegexpUtils, Markdown
  

  def initialize(param=HighlightersEnum::JAVA)
    super(param)
  end

  
  def keywords_file() 'keywords_java.txt'; end
  
  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex() RE_QUOTE_DOUBLE; end


  def regexter_singles(parser)
    parser.regexter('char', /'\\?.{0,1}'/, lambda { |token, regexp|
      wrap(:quote, token)
    })

    parser.regexter('annotation', /@[a-z_A-Z]+/, lambda { |token, regexp|
      wrap(:ann, token)
    })

    parser.regexter(:num, NUMBER[:regexp], NUMBER[:lambda])
  end

end
