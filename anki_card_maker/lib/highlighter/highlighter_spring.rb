class SpringHighlighter < JavaHighlighter


  COLOR_ANNOTATION = '#426F9C'

  def initialize()
    super(HighlightersEnum::SPRING)
  end
  
  def comment_regex
    RegextrationStore::CommentBuilder.new.c.html.build
  end

  def string_regex
    quote_double_regex()
  end

  def regexter_blocks(parser)
    parser.regexter('noattr_xml', /<(\/?[a-z]+:[a-zA-Z-]+\/?)>/, lambda { |token, regexp|      
      HtmlUtil.span('html', "&lt;#{token[regexp, 1]}&gt;")
    })

    parser.regexter('withattr_xml', /<.*?>/, lambda { |token, regexp|
      $logger.debug(token)

      inner_parser = SourceParser.new

      inner_parser.regexter('<sec:elem', /<([a-z]+:[a-zA-Z-]+)/, 
        lambda { |t, r| HtmlUtil.span('html', '&lt;' + t[r, 1]) })

      inner_parser.regexter('name="value"', / ([a-z]+) ?= ?(".*?")/, 
        lambda { |t, r| " #{HtmlUtil.span('attr', t[r, 1])}=#{HtmlUtil.span('quote', t[r, 2])}"})

      inner_parser.regexter('closing', /(\/?)>/, 
        lambda { |t, r| HtmlUtil.span('html', t[r, 1]) })

      "#{inner_parser.parse(token)}&gt;"
    })

  end


  def regexter_singles(parser)
    parser.regexter('annotation', /@[a-z_A-Z]+/, lambda { |token, regexp|
      HtmlUtil.span('ann', token)
    })

    parser.regexter('char', /'\\?.{0,1}'/, lambda { |token, regexp|
      HtmlUtil.span('quote', token)
    })

  end

  # <\/?([a-z]+:[a-z-]+)(?: ([a-z]+) ?= ?(".*?"))*\/?>


end
