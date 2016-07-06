
# Include angular directives ng-*.
class AngularHighlighter < WebHighlighter


  def initialize() super; end


  HTML_TAGS = ['script', 'head']
  ESCAPED_HTML_RE = '&lt;\/?.*?&gt;'


  # @Override.  Capture Angular Expression and Escaped HTML Tags
  def special_regex_block_string
    return "{{.*?}}|" + ESCAPED_HTML_RE
  end


  # @Override
  def highlight_special_block(input_string)
    # do nothing, do not highlight.
  end


  # @Override
  def highlight_special_token(input_string)
    $logger.debug(input_string)

    input_string.gsub!(/ng-\w+/) do |token|
      highlight_angular(token)
      token
    end

    # highlight_attribute(input_string)
    # highlight_escaped_angled_tags(input_string)
    # return input_string
  end


  def highlight_escaped_angled_tags(input_string)
    tag = HTML_TAGS.join('|')
    pattern = %r{(&lt;(?:#{tag}))(?:&gt;)?|(&lt;\/(?:#{tag})(?:&gt;))}

    # if pattern =~ input_string
    if /&lt;\/?([a-z]+).*?&gt;/ =~ input_string
      input_string.gsub!(pattern) do |token|
        "<span class=\"html\">#{$1}</span>"
      end 
    end
    # return input_string
  end


  def highlight_attribute(input_string)

    pattern_html = /&lt;[\d\D]*?&gt;/
    pattern_attr = / (\w*)(?=[ =&])/

    input_string.gsub!(pattern_html) do |html|
      html.gsub(pattern_attr) do |attr|
        " <span class=\"attr\">#{$2}</span>"
      end
    end
    # return input_string
  end


  def highlight_angular(input_string)
    re = /(ng-\w+)/
    input_string.gsub!(re) do |attr|
        " <span class=\"attr\">#{$1}</span>"
    end
    return input_string  
  end

end
