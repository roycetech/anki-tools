
require './lib/dsl/html_dsl'
require './lib/dsl/style_dsl'
require './lib/utils/html_utils'
require './lib/html/code'
# Review requires below.

require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/inline'

require './lib/html/style_generator'
require './lib/html/colorizer_template'

require './lib/code_detector'
require './lib/cmd_detector'

#
class HtmlGenerator
  include HtmlUtils

  attr_reader :front_html, :back_html, :highlighter

  def initialize(highlighter)
    assert highlighter.is_a?(BaseHighlighter)
    @highlighter = highlighter
  end

  def format_front(tag_helper, front_array)
    card_block = front_array.join("\n")

    untagged = tag_helper.untagged? || tag_helper.is_back_only?
    tags_html = build_tags(tag_helper) # VERIFY IF NESTED works

    Code.new(@highlighter).mark_codes(card_block)
    output = html :div, :main do
      merge(tags_html) unless untagged
      text card_block
    end

    style = StyleGenerator.new(
      tag_helper,
      @highlighter.type
    ).style_front(card_block)

    "#{style}\n#{output}"
  end

  def format_back(tag_helper, back_array)
    card_block = back_array.join("\n")

    if tag_helper.enum?
      Code.new(@highlighter).mark_codes(card_block)

      output = html :div, :main do
        if tag_helper.ol?
          ol do
            card_block.lines.each do |line|
              li line
            end
          end
        else
          ul do
            card_block.lines.each do |line|
              li line
            end
          end
        end
      end

    elsif tag_helper.figure?
      output = html :div, :main do
        pre :fig do
          text back_array.inject('') do |result, element|
            result + "\n" unless result.empty?
            result + element
          end
        end
      end

    else
      Code.new(@highlighter).mark_codes(card_block)
      untagged = tag_helper.untagged? || tag_helper.is_front_only?
      tags_html = build_tags(tag_helper) # VERIFY IF NESTED works
      output = html :div, :main do
        merge(tags_html) unless untagged
        merge(card_block)
        # text card_block
      end
    end

    style = StyleGenerator.new(
      tag_helper,
      @highlighter.type
    ).style_back(card_block)

    "#{style}\n#{output}"
  end

  def build_main
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
