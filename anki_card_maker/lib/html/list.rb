

class ListBuilder


  def initialize(highlighter)
    @highlighter = highlighter;
  end


  def execute(html_builder, array, ordered)
    html_builder.send(ordered ? :ol : :ul).lf

    array.each do |element|
      # if tag_helper.code_back?
        # html_builder
        # .li
        # .code.text(@highlighter.highlight_all(to_html_nbsp(element))).code_e
        # .li_e.lf
      # else

      text = detect_inlinecodes(element)
      re = />( *)</
      text.gsub!(re) { |token| '>' + '&nbsp;' * token[re,1].length + '<'}

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
