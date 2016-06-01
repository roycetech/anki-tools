class WebHighlighter < JsHighlighter


  def initialize() super; end


  HTML_TAGS = ['script', 'head']

  def highlight_lang_specific(input_string)
    highlight_attribute(input_string)
    highlight_escaped_angled_tags(input_string)
    return input_string
  end


  def highlight_escaped_angled_tags(input_string)
    tag = HTML_TAGS.join('|')
    pattern = %r{(&lt;(?:#{tag}))(&gt;)?|(&lt;\/(?:#{tag})(?:&gt;))}

    if pattern =~ input_string
      input_string.gsub!(pattern) do |token|
        # $logger.debug("1: #{$1} 2: #{$2} Token: #{token}")

        if $1
          "<span class=\"html\">#{$1}#{$2}</span>"
        elsif $3
          "<span class=\"html\">#{$3}</span>"
        end
      end 
    end
    return input_string
  end


  def highlight_attribute(input_string)

    pattern_html = /&lt;[\d\D]*?&gt;/
    pattern_attr = / (\w*)(?=[ =&])/

    input_string.gsub!(pattern_html) do |html|

        # $logger.debug html

      html.gsub(pattern_attr) do |attr|
        # $logger.debug("#{$1}")
        " <span class=\"attr\">#{$1}</span>"
      end
    end

    return input_string
  end

end
