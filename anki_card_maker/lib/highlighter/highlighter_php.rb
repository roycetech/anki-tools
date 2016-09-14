class PhpHighlighter < BaseHighlighter


  include RegexpUtils


  def initialize() super(HighlightersEnum::PHP); end

  def keywords_file() return 'keywords_php.txt'; end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.c.build
  end

  def string_regex() RE_QUOTE_BOTH; end

  
  def regexter_singles(parser) 
    tags_lambda = ->(token, regexp) { wrap(:phptag, escape_angles(token)) }
    parser.regexter('php_tags', /<\?=|<\?(?:php)?|\?>/, tags_lambda)

    var_lambda = ->(token, regexp) { wrap(:var, token) }
    parser.regexter('php_vars', /(\$[\w]+)/, var_lambda)
  end

end
