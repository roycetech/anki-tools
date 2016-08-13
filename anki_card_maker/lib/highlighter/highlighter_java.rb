class JavaHighlighter < BaseHighlighter


  COLOR_ANNOTATION = '#426F9C'

  def initialize(param=HighlightersEnum::JAVA)
    super(param)
  end
  
  def keywords_file() return 'keywords_java.txt'; end
  def highlight_string(input_string) return highlight_dblquoted(input_string); end


  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex
    quote_double_regex()
  end


  def regexter_singles(parser)
    parser.regexter('char', /'\\?.{0,1}'/, lambda { |token, regexp|
      HtmlUtil.span('quote', token)
    })

    parser.regexter('annotation', /@[a-z_A-Z]+/, lambda { |token, regexp|
      HtmlUtil.span('ann', token)
    })

  end


end
