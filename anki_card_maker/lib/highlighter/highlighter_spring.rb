class SpringHighlighter < JavaHighlighter

  include RegexpUtils, HtmlUtils


  def initialize() super(HighlightersEnum::SPRING) end
  
  def comment_regex
    RegextrationStore::CommentBuilder.new.c.html.build
  end

  def string_regex() RE_QUOTE_DOUBLE; end

  def regexter_blocks(parser)
    parser.regexter('noattr_xml', /<(\/?[a-z]+:[a-zA-Z-]+\/?)>/, lambda do |token, regexp|      
      wrap(:html, "#{ ELT + token[regexp, 1] + EGT }")
    end)

    parser.regexter('withattr_xml', /<.*?>/, lambda do |token, regexp|
      inner_parser = SourceParser.new

      inner_parser.regexter('<sec:elem', /<([a-z]+:[a-zA-Z-]+)/, 
        lambda { |t, r| wrap(:html, ELT + t[r, 1]) })

      inner_parser.regexter('name="value"', / ([a-z]+) ?= ?(".*?")/, 
        lambda { |t, r| " #{ wrap(:attr, t[r, 1]) }=#{ wrap(:quote, t[r, 2]) }" })

      inner_parser.regexter('closing', /(\/?)>/, 
        lambda { |t, r| wrap(:html, t[r, 1] + EGT) })

      inner_parser.parse(token)
    end)

  end

end
