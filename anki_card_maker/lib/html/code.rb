require './lib/assert'


# It detects code wells,
# appends some needed <br>'s ?
# Escapes some spaces with &nbsp; ?
class Code

  include Assert, Markdown


  RE_WELL = /(```)([a-zA-Z]*)([\d\D]*?)(\1)/


  def initialize(highlighter)
    @highlighter = highlighter
  end


  def execute(html_builder, string_array)
    if string_array.length == 1

      text = highlight_code(string_array)
      html_builder.br if text.lstrip =~ /\w/ and html_builder.build.strip.end_with? '/span>'

      html_builder
      .text(text)
      .lf

    else
      $logger.debug(string_array)
      highlighted_string = highlight_code(string_array)
      re = /<div class="well"><code>([\d\D]*)<\/code><\/div>/
      if highlighted_string =~ re
        assert !highlighted_string[re, 1].empty?, message: "Highlight must not be empty!"
      end

      html_builder.br if highlighted_string.lstrip =~ /\w|<code/ and html_builder.build.strip.end_with? '/span>'
      html_builder.text(highlighted_string).lf

    end

  end


  def highlight_code(string_array)

    block_to_html_raw(string_array)

    card_block = string_array.join("\n")

    well_re = /<div class="well"><code>\n([\d\D]*?)<\/code><\/div>/

    parser = SourceParser.new
    parser.regexter('well', well_re, lambda { |token, regexp|
      code_block = token[regexp, 1].chomp
      @highlighter.highlight_all(code_block)
      code_block.gsub!(/(<\/span>\n\s*)<span/, "\\1<br><span")
      return "<div class=\"well\"><code>\n#{code_block}<\/code><\/div>"
    })

    parser.regexter('bold', BOLD[:regexp], BOLD[:lambda]);
    parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda]);
    parser.parse(card_block)
  end


  def block_to_html_raw(string_list)
    detect_wells(string_list)
    inline = Inline.new(@highlighter)
    string_list.collect! do |line|
      line.chomp!
      inline.execute!(line)
      escape_spaces(line)
    end
    string_list
  end


  # Detect wells and place new lines
  def detect_wells(string_list)
    string_block = string_list.join("\n")

    string_block.gsub!(RE_WELL) do |token|
      inside = token[RE_WELL, 3]

      inside.strip!.gsub!("\n", "<br>\n")
      %Q(<div class="well"><code>\n#{ inside }\n  </code></div>)
    end

    string_list.replace(string_block.lines.collect {|element| element.rstrip})
    return string_list
  end

end
