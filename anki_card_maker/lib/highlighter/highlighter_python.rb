class PythonHighlighter < BaseHighlighter

  include RegexpUtils, HtmlUtils

  def initialize() super(HighlightersEnum::PYTHON); end
  def keywords_file() 'keywords_python.txt'; end
  def comment_regex() RegextrationStore::CommentBuilder.new.perl.build; end
  def string_regex() RE_QUOTE_BOTH end


  def regexter_blocks(parser)
      parser.regexter('multiline String', /(['"]{3})[\d\D]*\1/, lambda { 
        |token, regexp| 
        wrap(:quote, token)
      });

      parser.regexter('raw string', /r(['"]).*\1/, lambda { |token, regexp| 
        wrap(:quote, token)
      });
  end


  def regexter_singles(parser)
      parser.regexter('Number Anywhere', Markdown::NUMBER[:regexp], 
        Markdown::NUMBER[:lambda]);

      num_token = /^[+-]?[1-9]\d*(?:\.\d+)?$/
      parser.regexter('Number Token', num_token, Markdown::NUMBER[:lambda]);
  end

end
