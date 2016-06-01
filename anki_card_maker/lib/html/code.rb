require './lib/assert'

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

        html_builder.br if highlighted_string[0].lstrip =~ /\w/ and html_builder.build.strip.end_with? '/span>'
        html_builder.text(highlighted_string).lf
      end

  end


  def highlight_code(string_array)
    block_to_html_raw(string_array)

    # $logger.debug string_array.join "\n"

    inside_well = false
    return_value = string_array.inject('') do |result, element|

      result += "\n" unless result.empty?

      if inside_well
        text = @highlighter.highlight_all(element)
      else
        text = element
      end

      if result.end_with? "</span>\n" and text.start_with? "<span"
        result += HtmlBuilder::BR + text
      elsif text.gsub('&nbsp;', '')[0, 5] == '<span' and
          not result.strip().end_with? '<code>'and not result.strip().end_with? '<br>'
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

      # $logger.debug line
      escape_unknown_tags(line)
      # $logger.debug line

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

  # escape unknown
  def escape_unknown_tags(input_string)
    @htmlcustom_words = get_html_keywords unless @htmlcustom_words
    re = /<(\/?([a-zA-Z]*)(?: [a-zA-Z]*=(['"])[\d\D]*?\3)*)>/

    return_value = input_string.gsub(re) do |token|
      if @htmlcustom_words.include? $2
        token
      else
        '&lt;' + $1 + '&gt;'
      end
    end

    input_string.replace(return_value)
    return_value
  end

  def get_html_keywords
    return File.read('./data/keywords_customhtml.txt').lines.collect do |line|
      line.chomp
    end
  end


end