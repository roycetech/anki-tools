require './lib/highlighter/base_highlighter'

class JavaHighlighter < BaseHighlighter

  def initialize(param=HighlightersEnum::JAVA) super(param) end

  def keywords_file() 'keywords_java.txt' end  
  def comment_regex() RegextrationStore::CommentBuilder.new.c.build end
  def string_regex() RE_QUOTE_DOUBLE end


  def regexter_singles(parser)
    parser.regexter('char', /'\\?.{0,1}'/, ->(token, lambda) do 
      wrap(:quote, token) 
    end)

    parser.regexter('annotation', /@[a-z_A-Z]+/, ->(token, lambda) do 
      wrap(:ann, token)
    end)

    parser.regexter(:num, NUMBER()[:regexp], NUMBER()[:lambda])
  end

end
