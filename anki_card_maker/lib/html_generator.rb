
require './lib/dsl/html_dsl'
require './lib/dsl/style_dsl'
require './lib/utils/html_utils'
require './lib/html/list'
require './lib/html/code'
# Review requires below.

require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/inline'

require './lib/html/style_generator'
require './lib/html/colorizer_template'

require './lib/code_detector'
require './lib/cmd_detector'


class HtmlGenerator
  include HtmlUtils


  attr_reader :front_html, :back_html, :highlighter


  def initialize(highlighter)
    assert highlighter.kind_of?(BaseHighlighter)
    @highlighter = highlighter
  end


  def format_front(tag_helper, front_array)
    card_block = front_array.join("\n")
    
    untagged = tag_helper.untagged? || tag_helper.is_back_only?
    tag_htmls = build_tags(tag_helper)  # VERIFY IF NESTED works
    
    Code.new(@highlighter).mark_codes(card_block)
    output = html :div, :main do      
      merge(tag_htmls) unless untagged
      text card_block
    end

    style = StyleGenerator.new(tag_helper, 
      lang=@highlighter.type).style_front(card_block)

    "#{ style }\n#{output}"
  end


  def format_back(tag_helper, back_array)
    card_block = back_array.join("\n")

    if tag_helper.has_enum?
      List.new(@highlighter).execute(builder_back, back_array, tag_helper.ol?)

    elsif tag_helper.figure?
      html :div, :main do
        pre :fig do
          text back_array.inject('') do |result, element|
            result += "\n" unless result.empty?
            result += element
          end
        end
      end

    else
      Code.new(@highlighter).mark_codes(card_block)
      untagged = tag_helper.untagged? || tag_helper.is_front_only?
      output = html :div, :main do      
        merge(tag_htmls) unless untagged
        text card_block
      end
    end

    style = StyleGenerator.new(tag_helper, 
      lang=@highlighter.type).style_back(card_block)

    "#{ style }\n#{ output }"
  end

  def build_main(answer_part)
    Code.new(@highlighter).mark_codes(card_block)
    untagged = tag_helper.untagged? || tag_helper.is_front_only?
    html :div, :main do      
      merge(tag_htmls) unless untagged
      text card_block
    end
  end


  def build_tags(tag_helper)
    html :div, :tags do
      tag_helper.visible_tags.each do |tag|
        span :tag, tag
      end
    end
  end


end
