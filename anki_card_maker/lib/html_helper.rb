require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/list'
require './lib/html/code'
require './lib/html/inline'

require './lib/html/style_helper'
require './lib/code_detector'


class HtmlHelper


  HEC_LT = '&lt;'
  HEC_GT = '&gt;'


  attr_reader :front_html, :back_html


  def initialize(highlighter, tag_helper, front_array, back_array)
    @tag_helper = tag_helper
    @highlighter = highlighter

    style_helper = StyleHelper.new(tag_helper)

    builder_front = HtmlBuilder.new
    builder_back = HtmlBuilder.new

    style_helper.apply_common(builder_front)
    style_helper.apply_common(builder_back)
    style_helper.apply_code(builder_back) if CodeDetector.has_code? back_array
    style_helper.apply_code(builder_front) if CodeDetector.has_code? front_array
    style_helper.apply_answer_only(builder_front) if tag_helper.is_back_only?
    style_helper.apply_answer_only(builder_back) if tag_helper.is_front_only?
    style_helper.apply_command(builder_front) if tag_helper.command?
    style_helper.apply_figure(builder_back) if tag_helper.figure?

    builder_front = builder_front.style_e
    builder_back = builder_back.style_e

    #  Step 3: Common HTML
    html_builder_common2 = HtmlBuilder.new
      .div('main').lf

    tags = build_tags(back_array)

    # Process Front Card Html
    builder_front.merge(html_builder_common2)

    has_visible_tag = !tag_helper.visible_tags.empty?
    unless tag_helper.is_back_only? or not has_visible_tag
      builder_front.merge(tags)
    end

    if tag_helper.code_front?
      if front_array.length == 1
        builder_front
          .pre
            .text(highlight_code(front_array))
          .pre_e.lf
      else
        builder_front
          .pre.lf
            .text(highlight_code(front_array)).lf
          .pre_e
      end

    elsif tag_helper.command?
        builder_front
          .div.lf
            .code('command')

        builder_front.text(front_array.inject('') do |result, element|
          result += HtmlBuilder::BR + "\n" unless result.empty?
          result += line_to_html_raw(element)
        end).lf

        builder_front
          .code_e.lf
          .div_e.lf
    else

      builder_front.br if has_visible_tag
      builder_front.text(front_array.inject('') do |result, element|
        result += HtmlBuilder::BR + "\n" unless result.empty?
        result += line_to_html_raw(element)
      end).lf

    end

    # Process Back Card Html
    builder_back.merge(html_builder_common2)

    unless tag_helper.is_front_only? or not has_visible_tag
      builder_back.merge(tags)
    end
    # $logger.debug("#{tag_helper.is_front_only?} #{has_visible_tag}" + builder_back.build)
    # # $logger.debug(">>>>>>>>>>>>" + builder_back.build)

    if tag_helper.has_enum?
      ListBuilder.new(@highlighter).execute(builder_back, back_array, tag_helper.ol?)

      # builder_back.__send__(tag_helper.ul? ? :ul : :ol).lf

      # back_array.each do |element|
      #   if tag_helper.code_back?
      #     builder_back
      #       .li
      #         .code.text(@highlighter.highlight_all(to_html_nbsp(element))).code_e
      #       .li_e.lf
      #   else
      #     builder_back.li.text(to_html_nbsp(element)).li_e.lf
      #   end
      # end

      # builder_back
      #   .__send__(tag_helper.ul? ? :ul_e : :ol_e).lf

    elsif tag_helper.code_back?
      Code.new(@highlighter).execute(builder_back, back_array)

    elsif tag_helper.figure?
      builder_back
        .pre('fig').lf
          .text(back_array.inject('') do |result, element|
            result += "\n" unless result.empty?
            result += line_to_html_raw(element)
          end).lf
        .pre_e.lf

    else

      $logger.debug("Regular BACK! visible tag[#{has_visible_tag}] Front Only[#{tag_helper.is_front_only?}]")

      Code.new(@highlighter).execute(builder_back, back_array)



      # builder_back.br if has_visible_tag and not tag_helper.is_front_only?

      # builder_back.text(back_array.inject('') do |result, element|
      #   result += (HtmlBuilder::BR + "\n") unless result.empty?
      #   result += line_to_html_raw(element)
      # end).lf

    end


    if tag_helper.is_front_only?
      backAnswer = HtmlBuilder.new
        .span('answer_only').text('Answer Only').span_e.lf

      # builder_back.br.br unless tag_helper.has_enum?  # or tag_helper.code_back?
      builder_back.br if builder_back.build.chomp.end_with?('</code>')
      builder_back.br unless builder_back.build.chomp.end_with?('>')

      # $logger.debug builder_back.last_element
      # exit

      builder_back.merge(backAnswer)
    end

    if tag_helper.is_back_only?
      frontAnswer = HtmlBuilder.new
        .span('answer_only').text('Answer Only').span_e.lf

      builder_front.br.br unless tag_helper.has_enum?

      frontAnswer.insert(HtmlBuilder::Tag_BR)  if builder_front.last_tag == HtmlBuilder::Tag_Span_E or builder_front.last_element == 'text'
      builder_front.merge(frontAnswer)
    end


    @front_html = builder_front.div_e.lf.build
    @back_html = builder_back.div_e.lf.build
  end


  private

  def get_html_keywords
    return File.read('./data/keywords_customhtml.txt').lines.collect do |line|
      line.chomp
    end
  end


  # build the tags html. <span>tag1</span>&nbsp;<span>tag2</span>...
  def build_tags(card)
    first = true
    tags_html = HtmlBuilder.new
    @tag_helper.find_multi(card)
    @tag_helper.visible_tags.each do |tag|
      tags_html.space unless first
      tags_html.span('tag').text(tag).span_e
      first = false
    end
    tags_html.lf
  end

  def highlight_code(array)
    block_to_html_raw(array)

    return array.inject('') do |result, element|
      result += "\n" unless result.empty?
      highlighted = @highlighter.highlight_all(element)
      if result.end_with? "</span>\n" and highlighted.start_with? "<span"
        result += HtmlBuilder::BR + highlighted
      elsif highlighted.gsub('&nbsp;', '')[0, 5] == '<span' and
          not result.strip().end_with? '<code>'and not result.strip().end_with? '<br>'
        result.chomp!
        result += "<br>\n" + highlighted
      else
        result += highlighted
      end
    end
  end

  # escape unknown
  def escape_unknown_tags(input_string)
    @htmlcustom_words = get_html_keywords unless @htmlcustom_words
    re = /<\/?([a-zA-Z]+)>/

    return_value = input_string.gsub(re) do |token|
      if @htmlcustom_words.include? $1
        token
      else
        '&lt;' + $1 + '&gt;'
      end
    end

    input_string.replace(return_value)
    return_value
  end

  def block_to_html_raw(string_list)
    detect_wells(string_list)
    string_list.collect! do |line|
      line = detect_inlinecodes(line.chomp)
      line.gsub('  ', HtmlBuilder::ESP * 2)
    end
    return string_list
  end


  def detect_wells(string_list)
    string_block = string_list.join("\n")

    re = /(```)([a-zA-Z]*)([\d\D]*?)(\1)/
    string_block.gsub!(re) do |token|
      inside = token[re,3]

      inside.strip!.gsub!("\n", "<br>\n")

      "<div class=\"well\"><code>\n" + inside + "\n</code></div>"
    end

    # $logger.debug(string_block)

    string_list.replace(string_block.lines)
    return string_list
  end


  def detect_inlinecodes(string_line)
    re = /([`])((?:\\\1|[^\1])*?)(\1)/
    return_value = string_line.gsub(re) do |token|
      inline_code = token[re,2].gsub('\`', '`')
      '<code class="inline">' + @highlighter.highlight_all(inline_code) + '</code>'
    end
    string_line.replace(return_value
      .gsub(/í(.*?)í/, '<i>\1</i>'))
    return string_line
  end

  def line_to_html_raw(param_string)

    detect_inlinecodes(param_string)

    return_value = escape_unknown_tags(param_string)
    param_string
      .gsub(/í([a-zA-Z ]*)í/, '<i>\1</i>')
      .gsub(/(?: <(=?) )/, ' ' + HEC_LT + '\1 ')
      .gsub(/(?: >(=?) )/, ' ' + HEC_GT + '\1 ')
      # .gsub(/>( *)</) { |token| '>' + '&nbsp;' * token[re,1].length + '<'}

    if return_value.index('<code>') and return_value.index('</code>')
      pattern = /(.*<code(?: .*)?>)(.*)(<\/code>.*)/
      colored = @highlighter.highlight_all(return_value[pattern, 2])
      return_value[pattern, 1] + colored + return_value[pattern, 3]
    else
      return_value
    end
  end

  # escape angles, and spaces
  def to_html_nbsp(string)
    return line_to_html_raw(string)
    .gsub('  ', HtmlBuilder::ESP * 2)
    .gsub(HtmlBuilder::ESP + ' ', HtmlBuilder::ESP * 2)
    .gsub("\n", HtmlBuilder::BR)
  end

end
