require './lib/assert'
require './lib/html/html_util'

# It detects code wells, 
# appends some needed <br>'s ?
# Escapes some spaces with &nbsp; ?
class Code

  include Assert


  RE_WELL = /(```)([a-zA-Z]*)([\d\D]*?)(\1)/


  def initialize(highlighter)
    @highlighter = highlighter;
  end


  def execute(html_builder, string_array)
      
      if string_array.length == 1
      
        text = highlight_code(string_array)
        html_builder.br if text.lstrip =~ /\w/ and html_builder.build.strip.end_with? '/span>'

        html_builder
          .text(text)
        .lf

      else

        highlighted_string = highlight_code(string_array)
        re = /<div class="well"><code>([\d\D]*)<\/code><\/div>/
        if highlighted_string =~ re
          assert !highlighted_string[re, 1].empty?, "Highlight must not be empty!"
        end

        html_builder.br if highlighted_string.lstrip =~ /\w|<code/ and html_builder.build.strip.end_with? '/span>'
        html_builder.text(highlighted_string).lf

      end

  end


  def highlight_code(string_array)
    block_to_html_raw(string_array)


    inside_well = false
    return_value = string_array.inject('') do |result, element|

      result += "\n" unless result.empty?

      if inside_well
        text = @highlighter.highlight_all(element)
      else
        text = element
      end

      if result.end_with? "</span>\n" and text.start_with?('<span')
        result += HtmlBuilder::BR + text
      elsif text.gsub('&nbsp;', '')[0, 5] == '<span' and
          not result.strip().end_with? '<code>'and not result.strip().end_with? '<br>'
        result.chomp!
        result += "<br>\n" + text
      elsif text.gsub('&nbsp;', '')[0, 5] == '<code' and
          not result.strip().end_with? '<code>'and not result.strip().end_with? '<br>' and
          not result.strip().empty?
        result.chomp!
        result += "<br>\n" + text
      else 
        result += text
      end
      re = />( *)</
      result.gsub!(re) { |token| '>' + '&nbsp;' * token[re,1].length + '<'}

      inside_well = true if element.include? '<div class="well"'
      inside_well = false if element.include? '</code></div>'

      result
    end

    return_value
  end


  def block_to_html_raw(string_list)
    detect_wells(string_list)
    inline = Inline.new(@highlighter)
    string_list.collect! do |line|

      HtmlUtil.escape(line)

      line = inline.execute(line.chomp)
      line.gsub('  ', HtmlBuilder::ESP * 2)
    end

    return string_list
  end


  # Detect wells and place new lines
  def detect_wells(string_list)
    string_block = string_list.join("\n")

    string_block.gsub!(RE_WELL) do |token|
      inside = token[RE_WELL,3]

      inside.strip!.gsub!("\n", "<br>\n")
      %Q(<div class="well"><code>\n#{inside}\n  </code></div>)
    end

    string_list.replace(string_block.lines.collect {|element| element.rstrip})
    return string_list
  end

end