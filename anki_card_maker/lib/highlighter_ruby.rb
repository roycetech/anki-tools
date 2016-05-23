class RubyHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize() super; end
  def keywords_file() return 'keywords_ruby.txt'; end
  def comment_marker() return '# '; end
  def highlight_string(input_string) return highlight_quoted(input_string); end


  def highlight_lang_specific(input_string)
    highlight_block_param(input_string)
    highlight_variable(input_string)
    return input_string
  end


  # Added <br/ > as workaround to quirk of missing new lines.
  def highlight_block_param(input_string)
    pattern = Regexp.new %Q{\\|[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*\\|}
    if pattern =~ input_string
      input_string.sub!(pattern, @@html_color.identifier(input_string[pattern]))
    end
    return input_string
  end



  # highlight instance and class variables
  def highlight_variable(input_string)
    pattern = /@[@a-z_A-Z]*\s/
    if pattern =~ input_string
      input_string.sub!(pattern, '<span style="color: %s">' %  COLOR_CLASS_VAR +
      input_string[pattern] + '</span>')
    end
    return input_string
  end

end  # end of RubyHighlighter class
