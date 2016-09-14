# TODO: Outdated!!!
class RubyHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize() super(HighlightersEnum::RUBY) end
  def keywords_file() 'keywords_ruby.txt'; end
  def comment_regex() /#.*/ end
  def string_regex() RE_QUOTE_BOTH end


  def highlight_lang_specific(input_string)
    highlight_block_param(input_string)
    highlight_variable(input_string)
    return input_string
  end


  # Added <br/ > as workaround to quirk of missing new lines.
  def highlight_block_param(input_string)
    pattern = Regexp.new %Q{\\|[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*\\|}
    if pattern =~ input_string
      input_string.gsub!(pattern, 
        "<span class=\"ident\">#{input_string[pattern]}</span>")
    end
    return input_string
  end


  # highlight instance and class variables
  def highlight_variable(input_string)
    pattern = /@[@a-z_A-Z]*\s/
    if pattern =~ input_string
      input_string.gsub!(pattern, 
        "<span class=\"var\">#{input_string[pattern]}</span>")
    end
    return input_string
  end

end  # end of RubyHighlighter class
