class PythonHighlighter < BaseHighlighter


  def initialize() super(HighlightersEnum::PYTHON) end
  def keywords_file() 'keywords_python.txt' end
  def comment_regex() RegextrationStore::CommentBuilder.new.perl.build end
  def string_regex() RE_QUOTE_BOTH end


  def regexter_blocks(parser)
    parser.regexter('multiline String', /(['"]{3})[\d\D]*\1/, ->(token, regexp) do 
      wrap(:quote, token)
    end)

    parser.regexter('raw string', /r(['"]).*\1/, ->(token, regexp) do 
      wrap(:quote, token)
    end)
  end


  def regexter_singles(parser)
    parser.regexter('Number Anywhere', NUMBER(:regexp), NUMBER(:lambda))

    num_token = /^[+-]?[1-9]\d*(?:\.\d+)?$/
    parser.regexter('Number Token', num_token, NUMBER(:lambda))
  end

end
