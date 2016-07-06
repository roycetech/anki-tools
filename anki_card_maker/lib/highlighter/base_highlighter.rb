require './lib/highlighter/keyword_highlighter'
# NOTE: There are requires at the bottom of this file.


# Base class will handle keyword, and comment, provided sub class supply
# keyword list and line comment markers.
class BaseHighlighter 


  @@html_class = '<span class="%{klass}">%{word}</span>'
  class << @@html_class
    def quote(string) self % {klass: 'quote', word: string}; end
    def comment(string) self % {klass: 'comment', word: string}; end
    def identifier(string) self % {klass: 'ident', word: string}; end
    def user(string) self % {klass: 'user', word: string}; end
    def keyword(string) self % {klass: 'keyword', word: string}; end
  end


  # Factory methods.
  def self.ruby() return RubyHighlighter.new; end
  def self.js() return JsHighlighter.new; end
  def self.cpp() return CppHighlighter.new; end
  def self.java() return JavaHighlighter.new; end
  def self.none() return NoHighlighter.new; end
  def self.php() return PhpHighlighter.new; end
  def self.web() return WebHighlighter.new; end
  def self.objc() return WebHighlighter.new; end
  def self.jquery() return JQueryHighlighter.new; end
  def self.command() return CommandHighlighter.new; end


  def initialize
    $logger.debug "Highlighter: #{self.class}" 
    @keyworder = KeywordHighlighter.new(keywords_file)

    @parser = SourceParser.new

    comment_lambda = lambda{ |token, regex_name| @@html_class.comment(token) }
    @parser.regexter('comment', comment_regex, comment_lambda)
    
    regexter_blocks(@parser)

    string_lambda = lambda{ |token, regex_name| @@html_class.quote(token) }
    @parser.regexter('strings', string_regex, string_lambda)

    
    user_lambda = lambda{ |token, regex_name| @@html_class.user(token) }
    @parser.regexter('<user>', /&lt;[\w ]*?&gt;/, user_lambda)

    keyword_lambda = lambda{ |token, regex_name| @@html_class.keyword(token) }
    @parser.regexter('keyword', @keyworder.keyword_regex, keyword_lambda)

    regexter_singles(@parser)
  end
  private :initialize


  # Override to register specific blocks
  # 
  def regexter_blocks(parser) end
  def regexter_singles(parser) end


  def keywords_file
    raise NotImplementedError, 'You must implement the keywords_file method'
  end


  # Subclass should return regex string
  def comment_regex
    raise NotImplementedError, 'You must implement the comment_regex method'
  end


  # Subclass should return regex string for string literals
  def string_regex
    raise NotImplementedError, 'You must implement the string_regex method'
  end


  def quote_single_regex() /'(?:(?:\\')|[^'])*?'/ end
  def quote_double_regex() /"(?:(?:\\")|[^""])*?"/ end

  def quote_both_regex() 
    /(["'])(?:(?:\\\1)|[^\1])*?\1/
  end


  # Some spaces adjacent to tags need to be converted because it is not honored by
  # <pre> tag.
  def space_to_nbsp(input_string)

    pattern_between_tag = /> +</
    while pattern_between_tag =~ input_string
      lost_spaces = input_string[pattern_between_tag]
      input_string.sub!(pattern_between_tag, '>' + (HtmlBuilder::ESP * (lost_spaces.length - 2)) + '<')
    end

    pattern_before_tag = /^\s+</
    if pattern_before_tag =~ input_string
      lost_spaces = input_string[pattern_before_tag]
      input_string.sub!(pattern_before_tag, (HtmlBuilder::ESP * (lost_spaces.length - 1)) + '<')
    end
    return input_string
  end


  # # This method is not effective on fewer language that use <> and [] in its 
  # # syntax like C++, so disable on those.
  # def highlight_identifier(string)
  #   pattern = %r{&lt;([\wa-zA-Z0-9_ ]*(?:\|[a-zA-Z0-9_ ]*)*)&gt;}
  #   string.gsub!(pattern, '&lt;' + @@html_class.identifier('\1') + '&gt;')
  #   return string
  # end


  def highlight_all(input_string)
    input_string.replace(@parser.parse(input_string))
  
    space_to_nbsp(input_string)
    return input_string
  end

end


require './lib/highlighter/highlighter_ruby'
require './lib/highlighter/highlighter_js'
require './lib/highlighter/highlighter_cpp'
require './lib/highlighter/highlighter_java'
require './lib/highlighter/highlighter_swift'
# require './lib/highlighter_sql'
require './lib/highlighter/highlighter_plsql'
require './lib/highlighter/highlighter_none'
require './lib/highlighter/highlighter_php'
require './lib/highlighter/highlighter_web'
require './lib/highlighter/highlighter_objc'
require './lib/highlighter/highlighter_jquery'

