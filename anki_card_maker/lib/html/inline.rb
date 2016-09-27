class Inline

  # RE_PATTERN = /(`)((?:\\\1|[^\1])*?)(\1)/


  # Supports escaped: `\``, same line only
  RE_PATTERN = /`(?:\\`|[^`\n])+`/

  def initialize(highlighter)
    @highlighter = highlighter
  end


  def execute!(string_line)
    string_line.gsub!(RE_PATTERN) do |token|
      inline_code = token[RE_PATTERN,2].gsub('\`', '`')
      %Q(<code class="inline">#{ @highlighter.highlight_all(inline_code) }</code>)
    end
  end

end