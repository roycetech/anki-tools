require "./bin/main_class.rb"
require 'test/unit'


BEGIN { $unit_test = true }


# Exclude the Style from Testing.
# &nbsp's are converted back to spaces just for test simplicity.
class TestSingle < Test::Unit::TestCase


  RE_OUTER_DIV = /<div class="main">[\d\D]*<\/div>/  # outer most div, won't validate mispaired divs.


  # TEST 10 - Test no extra space between the code and the answer only.
  def test_backcard_single_code_fb
    front = ['front'];
    back = ['`null`']

    tags = ['Practical'];
    tag_helper = TagHelper.new(tags);
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back);

    # Assert #1
    assert_equal(%Q(
<div class="main">
  <span class="tag">Practical</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV]);

    # Assert #2
    assert_equal(%Q'
<div class="main">
  <code class="inline">null</code><br>
  <span class="answer_only">Answer Only</span>
</div>
'.strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '));
  end

end
