class JavaHighlighter < BaseHighlighter


  COLOR_ANNOTATION = '#426F9C'

  def initialize() super; end
  def keywords_file() return 'keywords_java.txt'; end
  def comment_marker() return '// '; end
  def highlight_string(input_string) return highlight_dblquoted(input_string); end

  # Highlight Annotation
  def highlight_lang_specific(input_string) 

    pattern = /@[a-z_A-Z]*/
    if pattern =~ input_string
      input_string.sub!(pattern, '<span style="color: %s">' %  COLOR_ANNOTATION +
      input_string[pattern] + '</span>')
    end
    return input_string
  end

end
