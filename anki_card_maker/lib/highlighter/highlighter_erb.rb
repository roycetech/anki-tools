require './lib/highlighter/base_highlighter'


class ErbHighlighter < BaseHighlighter

  def initialize(param=HighlightersEnum::RUBY) super(param) end

  def comment_regex() RegextrationStore::CommentBuilder.new.perl.build end


  def regexter_singles(parser)
    
  end

end
