require './lib/html_ruby_util.rb'
require 'test/unit'


BEGIN { $unit_test = true }


class TestHtmlRubyUtil < Test::Unit::TestCase



  def test_highlight_quoted
    command = %q[puts("Hello" + " " + "World")]

    expected = 'puts(%s + %s + %s)' % %w[Hello \  World].collect do |element|
      '<span style="color: %s">"%s"</span>' % [HtmlRubyUtil::COLOR_QUOTE, element]
    end

    assert_equal(expected, HtmlRubyUtil.highlight_quoted(command))
  end


  def test_highlight_keywords
    command1 = %q[def method_name()]

    expected1 = '<span style="color: %s">def</span> method_name()' % HtmlRubyUtil::COLOR_KEYWORD

    assert_equal(expected1, HtmlRubyUtil.highlight_keywords(command1))

    command2 = 'def meth( <paramname> = <default value> )'
    expected2 = '<span style="color: %s">def</span> meth( <paramname> = <default value> )' % HtmlRubyUtil::COLOR_KEYWORD
    assert_equal(expected2, HtmlRubyUtil.highlight_keywords(command2))

  end


end
