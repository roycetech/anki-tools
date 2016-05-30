class Inline


  RE_PATTERN = /(`)((?:\\\1|[^\1])*?)(\1)/

  def initialize(highlighter)
    @highlighter = highlighter;
  end

  def execute(string_line)
    return_value = string_line.gsub(RE_PATTERN) do |token|
      inline_code = token[RE_PATTERN,2].gsub('\`', '`')
      '<code class="inline">' + @highlighter.highlight_all(inline_code) + '</code>'
    end
    string_line.replace(return_value
      .gsub(/í(.*?)í/, '<i>\1</i>'))
    return string_line
  end

end