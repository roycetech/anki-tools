class PhpHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize
    super(HighlightersEnum::PHP)     
  end

  def keywords_file() return 'keywords_php.txt'; end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.c.build
  end

  def string_regex() quote_both_regex; end

  
  def regexter_singles(parser) 
    tags_lambda = lambda do |token, regex| 
      "<span class=\"phptag\">#{token.sub('<', '&lt;').sub('>', '&gt;')}</span>" 
    end
    parser.regexter('php_tags', /<\?=|<\?(?:php)?|\?>/, tags_lambda)

    var_lambda = lambda do |token, regex| 
      "<span class=\"var\">#{token}</span>"
    end
    parser.regexter('php_vars', /(\$[\w]+)/, var_lambda)

  end

end
