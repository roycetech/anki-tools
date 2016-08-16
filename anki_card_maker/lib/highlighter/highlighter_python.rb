class PythonHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize() super(HighlightersEnum::PYTHON); end
  def keywords_file() return 'keywords_python.txt'; end
  def comment_regex() RegextrationStore::CommentBuilder.new.perl.c.build; end
  def string_regex() quote_both_regex; end

  def regexter_blocks(parser)
      parser.regexter('Multiline String', /"""[\d\D]*"""/, lambda { |token, regexp| 
        HtmlUtil.span('quote', token)
      });

  end

  def regexter_singles(parser)
      parser.regexter('Number Anywhere', Markdown::NUMBER[:regexp], Markdown::NUMBER[:lambda]);

      num_token = /^[+-]?[1-9]\d*(?:\.\d+)?$/
      parser.regexter('Number Token', num_token, Markdown::NUMBER[:lambda]);
  end

end
