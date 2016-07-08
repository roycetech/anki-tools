

class List


  def initialize(highlighter)
    @highlighter = highlighter;
  end


  def execute(html_builder, array, ordered)
    html_builder.send(ordered ? :ol : :ul).lf

    array.each do |element|
      text = detect_inlinecodes(element)
      HtmlUtil.escape_spaces_between_angle!(text)
      html_builder.li.text(text).li_e.lf
      # end
    end

    html_builder
    .__send__(ordered ? :ol_e : :ul_e).lf
  end


   def detect_inlinecodes(string_line)
    re = /(`)((?:\\\1|[^\1])*?)(\1)/
    return_value = string_line.gsub(re) do |token|
      inline_code = token[re,2].gsub('\`', '`')
      '<code class="inline">' + @highlighter.highlight_all(inline_code) + '</code>'
    end
    string_line.replace(return_value
      .gsub(/í(.*?)í/, '<i>\1</i>'))
    return string_line
  end

end
