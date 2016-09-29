require './lib/assert'
require './lib/markdown'

# It detects code wells,
# appends some needed <br>'s ?
# Escapes some spaces with &nbsp; ?
class Code

  include Assert, Markdown


  WELL_START = '<code class="well">'
  RE_WELL = /^(```|#{WELL_START})([a-zA-Z]*\n)([\d\D]*?)(\1|<\/code>)/
  RE_CMD_WELL = /(?:```|#{WELL_START})\w*\n(\$ .*\n)+(?:```|<\/code>)/

  def initialize(highlighter)
    @highlighter = highlighter
  end


  def mark_codes(string)
    parser = SourceParser.new
    
    parser.regexter('wells', RE_WELL, ->(token, regexp) do
      lang = token[regexp,2]
      code_block = token[regexp,3].chomp
      @highlighter.mark_known_codes(code_block)
      code_block.gsub!("\n", "<br>\n")
      %(<code class="well">\n#{code_block}\n</code>)
    end)

    parser.regexter('inlines', /`((?:\\`|[^`\n])+)`/, ->(token, regexp) do
      code = token[regexp,1]
      @highlighter.mark_known_codes(code)
      %(<code class="inline">#{code}</code>)
    end)

    parser.regexter('bold', BOLD[:regexp], BOLD[:lambda]);

    parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda]);

    string.replace(parser.parse(string))
  end


  # def execute!(string_line)
  #   string_line.gsub!(RE_PATTERN) do |token|
  #     inline_code = token[RE_PATTERN,2].gsub('\`', '`')
  #     %Q(<code class="inline">#{ @highlighter.highlight_all(inline_code) }</code>)
  #   end


  #   string_array.replace(parser.lines)


  #   if string_array.length == 1

  #     text = highlight_code(string_array)

  #     # html_builder.br if text.lstrip =~ /\w/ and html_builder.build.strip.end_with? '/span>'

  #     html_builder
  #     .text(text)
  #     .lf

  #   else
  #     highlighted_string = highlight_code(string_array)
  #     # re = /<div class="well"><code>([\d\D]*)<\/code><\/div>/
  #     if highlighted_string =~ RE_WELL_HTML
  #       assert !highlighted_string[re, 1].empty?, message: "Highlight must not be empty!"
  #     end

  #     html_builder.br if highlighted_string.lstrip =~ /\w|<code/ and html_builder.build.strip.end_with? '/span>'
  #     html_builder.text(highlighted_string).lf

  #   end

  # end


  # def highlight_code(string_array)

  #   block_to_html_raw(string_array)

  #   card_block = string_array.join("\n")

  #   well_re = /<div class="well"><code>\n([\d\D]*?)<\/code><\/div>/

  #   parser = SourceParser.new
  #   parser.regexter('well', well_re, lambda { |token, regexp|
  #     code_block = token[regexp, 1].chomp
  #     @highlighter.highlight_all(code_block)
  #     code_block.gsub!(/(<\/span>\n\s*)<span/, "\\1<br><span")
  #     return "<code class=\"well\">\n#{code_block}<\/code>"
  #   })

  #   parser.parse(card_block)
  # end


  # def block_to_html_raw(string_list)
  #   detect_wells(string_list)
  #   inline = Inline.new(@highlighter)
  #   string_list.collect! do |line|
  #     line.chomp!
  #     inline.execute!(line)
  #     escape_spaces(line)
  #   end
  #   string_list
  # end


  # # Replace well tag placeholder, and put new lines.
  # def convert_well_placeholders(string_list)
  #   string_block = string_list.join("\n")

  #   string_block.gsub!(RE_WELL) do |token|
  #     inside = token[RE_WELL, 3]

  #     inside.strip!.gsub!("\n", "<br>\n")
  #     %Q(<code class="well">\n#{ inside }\n  </code>)
  #   end

  #   string_list.replace(string_block.lines.collect { |element| element.rstrip})

  #   return string_list
  # end

end
