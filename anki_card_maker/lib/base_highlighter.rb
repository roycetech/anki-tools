require './lib/keyword_highlighter'
# NOTE: There are requires at the bottom of this file.


# Base class will handle keyword, and comment, provided sub class supply
# keyword list and line comment markers.
class BaseHighlighter 


  COLOR_COMMENT = '#417E60'
  COLOR_QUOTE = '#1324BF'
  COLOR_IDENTIFIER = '#693E3F'


  @@html_color = '<span style="color: %{color}">%{word}</span>'
  class << @@html_color
    def quote(string) self % {color: COLOR_QUOTE, word: string}; end
    def comment(string) self % {color: COLOR_COMMENT, word: string}; end
    def identifier(string) self % {color: COLOR_IDENTIFIER, word: string}; end
  end


  # Factory methods.
  def self.ruby() return RubyHighlighter.new; end
  def self.js() return JsHighlighter.new; end
  def self.cpp() return CppHighlighter.new; end
  def self.java() return JavaHighlighter.new; end
  def self.none() return NoHighlighter.new; end


  def initialize
    $logger.debug "Highlighter: #{__FILE__}" 
    @keyword_highlighter = KeywordHighlighter.new(get_keywords, comment_marker)
  end
  private :initialize


  def keywords_file
    raise NotImplementedError, 'You must implement the keywords_file method'
  end


  def get_keywords
    return File.read('./data/' + keywords_file()).lines.collect do |line|
      line.chomp
    end
  end


  def comment_marker
    raise NotImplementedError, 'You must implement the comment_marker method'
  end


  def highlight_string
    raise NotImplementedError, 'You must implement the highlight_string method'
  end


  # Override for any 
  def highlight_lang_specific(input_string) end

  def highlight_keywords(input_string)
    return @keyword_highlighter.highlight(input_string)
  end


  # Highlight single in double, or double in single quotes.
  def highlight_quoted(input_string)
    # pattern = %r{((["'])(\\\1|[^\1]*?)\1)(?![^<]*>|[^<>]*<\/)}
    # pattern = %r{(["'])(\\\1|[^\1]*?)\1}
    # input_string.gsub!(pattern, @@html_color.quote('\1\2\1'))

    pattern = /<[^<>]*>|("[^"\\]*(?:\\.[^"\\]*)*"|'[^'\\]*(?:\\.[^'\\]*)*')/

    tag = false
    input_string.gsub!(pattern) do |token|
      if tag
        if token[0,1] == '<'
          tag = false;
        end 
        token
      elsif token[0,1] == '<'
        tag = true;
        token
      else
        @@html_color.quote($1)
      end
    end

    return input_string
  end

  # Highlight double quotes only.
  def highlight_dblquoted(input_string)    
    # pattern = %r{((")(\\\1|[^\1]*?)\1)(?![^<]*>|[^<>]*<\/)}
    # pattern = %r{(")(\\\1|[^\1]*?)\1}
    # input_string.gsub!(pattern, @@html_color.quote('\1\2\1'))


    pattern = /<[^<>]*>|("[^"\\]*(?:\\.[^"\\]*)*"|'[^'\\]*(?:\\.[^'\\]*)*')/

    tag = false
    input_string.gsub!(pattern) do |token|
      # puts "token: [#{token}]"
      if tag
        if token[0,1] == '<'
          tag = false;
        end 
        token
      elsif token[0,1] == '<'
        tag = true;
        token
      else
        @@html_color.quote($1)
        # "*" + $1 + "*"
      end
    end

    return input_string
  end


  def highlight_comment(input_string)
    pattern = Regexp.new(comment_marker + '.*$')
    # pattern = /# .*$/
    if pattern =~ input_string
      input_string.sub!(pattern, @@html_color.comment(input_string[pattern]) + '<br>')
    end
    return input_string
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


  # This method is not effective on fewer language that use <> and [] in its 
  # syntax like C++, so disable on those.
  def highlight_identifier(string)
    # pattern = %r{&lt;([a-zA-z0-9_ ]*)&gt;}
    pattern = %r{&lt;([\wa-zA-Z0-9_ ]*(?:\|[a-zA-Z0-9_ ]*)*)&gt;}
    string.gsub!(pattern, '&lt;' + @@html_color.identifier('\1') + '&gt;')
    return string
  end


  def highlight_all(input_string)
    highlight_string(input_string)
    highlight_keywords(input_string)
    highlight_lang_specific(input_string)
    highlight_identifier(input_string)
    highlight_comment(input_string)
    space_to_nbsp(input_string)
    return input_string
  end

end


require './lib/highlighter_ruby'
require './lib/highlighter_js'
require './lib/highlighter_cpp'
require './lib/highlighter_java'
require './lib/highlighter_swift'
# require './lib/highlighter_sql'
require './lib/highlighter_plsql'
require './lib/highlighter_none'

