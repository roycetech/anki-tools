require './lib/highlighter/keyword_highlighter'
require './lib/regextration_store'
# NOTE: Highlighter implementing classes "requires" at the bottom of this file.


# Base class will handle keyword, and comment, provided sub class supply
# keyword list and line comment markers.
class BaseHighlighter 

  include Wrappexter, Markdown, RegexpUtils

  @@html_class = '<span class="%{klass}">%{word}</span>'
  class << @@html_class
    def quote(string) self % { klass: :quote, word: string }; end
    def comment(string) self % { klass: :comment, word: string }; end
    def identifier(string) self % { klass: :ident, word: string }; end
    def user(string) self % { klass: :user, word: string }; end
    def keyword(string) self % { klass: :keyword, word: string }; end
  end


  # Factory methods.

  def self.method_missing(name)
    regex = /^lang_(\w+)/
    method_name = name.to_s
    if method_name =~ regex
      Object::const_get("#{ method_name[regex, 1].titleize }Highlighter").new
    else
      super
    end
  end

  # Define here if it don't follow standard naming.
  def self.jquery() return JQueryHighlighter.new; end
  def self.csharp() return CSharpHighlighter.new; end


  attr_reader :type

  def initialize(type)
    $logger.debug "Highlighter: #{self.class}" 

    @parser = SourceParser.new
    @type = type  # initialized by subclass

    http_re = /^https?:\/\/\w+(?:\.\w+)*(?::\d{1,5})?(?:\/\w+)*\/?$/
    @parser.regexter('http_url', http_re, ->(token, regexp) {
      wrap(:url, token)
    })

    comment_lambda = ->(token, regexp) { @@html_class.comment(token.sub(BR, '')) }
    @parser.regexter('comment', comment_regex, comment_lambda)

    @parser.regexter('bold', BOLD[:regexp], BOLD[:lambda]);
    @parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda]);

    regexter_blocks(@parser)

    string_lambda = ->(token, regex) { @@html_class.quote(token) }
    @parser.regexter('strings', string_regex, string_lambda)

    
    user_lambda = ->(token, regexp) { @@html_class.user(token) }
    @parser.regexter('<user>', /#{ ELT }[\w ]*?#{ EGT }/, user_lambda)

    if keywords_file
      @keyworder = KeywordHighlighter.new(keywords_file)
      keyword_lambda = ->(token, regex) { @@html_class.keyword(token) }
      @parser.regexter('keyword', @keyworder.keyword_regex, keyword_lambda)
    end

    regexter_singles(@parser)
  end
  private :initialize


  # Override to register specific blocks
  def regexter_blocks(parser) end
  def regexter_singles(parser) end


  # @Abstract 
  def keywords_file
    # raise NotImplementedError, 'You must implement the keywords_file method'
  end


  # Subclass should return regex string
  def comment_regex
    raise NotImplementedError, 'You must implement the comment_regex method'
  end


  # Subclass should return regex string for string literals
  def string_regex
    raise NotImplementedError, 'You must implement the string_regex method'
  end

  def highlight_all(input_string)
    input_string.replace(@parser.format(input_string))  
    escape_spaces(input_string)
  end

end


require './lib/highlighter/highlighter_ruby'
require './lib/highlighter/highlighter_js'
require './lib/highlighter/highlighter_cpp'
require './lib/highlighter/highlighter_java'
require './lib/highlighter/highlighter_swift'
require './lib/highlighter/highlighter_plsql'
require './lib/highlighter/highlighter_none'
require './lib/highlighter/highlighter_php'
require './lib/highlighter/highlighter_web'
require './lib/highlighter/highlighter_objc'
require './lib/highlighter/highlighter_jquery'
require './lib/highlighter/highlighter_python'
require './lib/highlighter/highlighter_git'
require './lib/highlighter/highlighter_spring'
require './lib/highlighter/highlighter_sql'
require './lib/highlighter/highlighter_csharp'
require './lib/highlighter/highlighter_asp'

