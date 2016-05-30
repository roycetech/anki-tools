class PhpHighlighter < BaseHighlighter


  COLOR_CLASS_VAR = '#426F9C'

  def initialize() super; end
  def keywords_file() return 'keywords_php.txt'; end
  def comment_marker() return '// '; end


  def highlight_all(input_string)
    highlight_keywords(input_string)
    highlight_tags(input_string)
    highlight_vars(input_string)  
    highlight_comment(input_string)
    highlight_quoted(input_string)
    highlight_dblquoted(input_string)
  end

  def highlight_vars(input_string)
    re = /(\$[\w]*)/
    input_string.gsub!(re) do |token|
      "<span class=\"var\">#{token}</span>"
    end
    return input_string
  end

  def highlight_tags(input_string)
    re = /<\?=|<\?php|\?>/

    input_string.gsub!(re) do |token|
      "<span class=\"phptag\">#{token}</span>"
    end
    return input_string
  end



end
