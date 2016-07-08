# TODO: Annotation Highlighter belongs to Java.
class NoHighlighter < BaseHighlighter


  # Suppress base class initialization, do not remove empty initializer
  def initialize() super; end


  # @Override.  /\A\z/ matches empty string only, not python compatible.
  def comment_regex() /\A\z/ end
  # @Override
  def string_regex() /\A\z/ end


  # Highlight Annotation
  def highlight_annotation(input_string)     
    pattern = /\B@\w+(?:\.\w+)*/
    # pattern = /@[a-z_A-Z]*/
    if pattern =~ input_string
      input_string.sub!(pattern, '<span style="color: %s">' %  JavaHighlighter::COLOR_ANNOTATION +
      input_string[pattern] + '</span>')
    end
    return input_string
  end

  # def highlight_all(input_string)
  #   highlight_annotation(input_string)
  #   return input_string
  # end

end
