
require './lib/dsl/html_dsl'
# Review requires below.

require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/list'
require './lib/html/code'
require './lib/html/inline'

require './lib/html/style_helper'
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


  # def initialize(highlighter, tag_helper, front_array, back_array)

    # @tag_helper = tag_helper

  def format(tag_helper, front_array, back_array)
    style_helper = StyleHelper.new(tag_helper, @highlighter.type, CmdDetector.has_cmd?(back_array))

    builder_front = HtmlBuilder.new
    builder_back = HtmlBuilder.new

    style_helper.apply_common(builder_front)
    style_helper.apply_common(builder_back)
    style_helper.apply_code(builder_back) if CodeDetector.has_code? back_array
    style_helper.apply_code(builder_front) if CodeDetector.has_code? front_array
    style_helper.apply_answer_only(builder_front) if tag_helper.is_back_only?
    style_helper.apply_answer_only(builder_back) if tag_helper.is_front_only?
    style_helper.apply_figure(builder_back) if tag_helper.figure?

    builder_front = builder_front.style_e
    builder_back = builder_back.style_e

    html_builder_common = HtmlBuilder.new
      .div(:main).lf

    tags_html = build_tags(back_array) unless tag_

    builder_front.merge(html_builder_common)
    has_visible_tag = !tag_helper.visible_tags.empty?
    builder_front.merge(tags) unless tag_helper.is_back_only? or !has_visible_tag


    Code.new(@highlighter).execute(builder_front, front_array)


    # Process Back Card Html
    builder_back.merge(html_builder_common)

    unless tag_helper.is_front_only? or not has_visible_tag
      builder_back.merge(tags)
    end

    if tag_helper.has_enum?
      List.new(@highlighter).execute(builder_back, back_array, tag_helper.ol?)
    elsif tag_helper.figure?
      builder_back
        .pre(:fig).lf
          .text(back_array.inject('') do |result, element|
            result += "\n" unless result.empty?
            # result += line_to_html_raw(element)
            result += element
          end).lf
        .pre_e.lf
    else
      Code.new(@highlighter).execute(builder_back, back_array)
    end


    if tag_helper.one_sided?
      answerHtml = HtmlBuilder.new \
        .span(:answer_only).text('Answer Only').span_e.lf if tag_helper.one_sided?
    end

    if tag_helper.is_front_only?

      builder_back.br.br if builder_back.last_element == 'text' and not builder_back.build.chomp.end_with?('</code></div>')
      builder_back.merge(answerHtml)
    end

    if tag_helper.is_back_only?
      builder_front.br.br if builder_front.last_element == 'text' && !builder_front.build.chomp.end_with?('</code></div>')
      builder_front.merge(answerHtml)
    end


    @front_html = builder_front.div_e.lf.build
    @back_html = builder_back.div_e.lf.build
  end


  # protected

  # build the tags html. <span>tag1</span>&nbsp;<span>tag2</span>...
  # def build_tags(tag_helper, back_card)
  #   first = true
  #   tags_html = HtmlBuilder.new
  #   tag_helper.index_enum(back_card) 
  #   tag_helper.visible_tags.each do |tag|
  #     tags_html.space unless first
  #     tags_html.span(:tag).text(tag).span_e
  #     first = false
  #   end
  #   tags_html.lf
  # end

  def build_tags(tag_helper, back_card)
    html :div, :tags do
      tag_helper.visible_tags.each do |tag|
        span :tag, tag
      end
    end
  end


end
