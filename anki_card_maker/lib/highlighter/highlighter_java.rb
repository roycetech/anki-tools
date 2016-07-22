class JavaHighlighter < BaseHighlighter


  COLOR_ANNOTATION = '#426F9C'

  def initialize
    super(HighlightersEnum::JAVA)
  end
  
  def keywords_file() return 'keywords_java.txt'; end
  def comment_marker() return '// '; end
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
      # '<span class="quote">%s</span' % token
    })

    parser.regexter('annotation', /@[a-z_A-Z]+/, lambda { |token, regexp|
      HtmlUtil.span('ann', token)
      # '<span class="ann">%s</span' % token
    })

  end


end
