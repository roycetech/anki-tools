require "./bin/main_class.rb"
require 'test/unit'


BEGIN { $unit_test = true }


# Exclude the Style from Testing.
# &nbsp's are converted back to spaces just for test simplicity.
class TestSingle < Test::Unit::TestCase


  RE_OUTER_DIV = /<div class="main">[\d\D]*<\/div>/  # outer most div, won't validate mispaired divs.


  # TEST 12 - Test to wrap html attributes with span with class
  def test_web_script_attribute
    front = ['front'];
    back = ['```', '<script src="2" checked test="12"></script>', '```']
    tags = [];
    tag_helper = TagHelper.new(tags);
    html = HtmlHelper.new(BaseHighlighter.web, tag_helper, front, back);


    # Assert #1
    assert_equal(%Q'
<div class="main">
  <div class="well"><code>
<span class="html">&lt;script</span> <span class="attr">src</span>=<span class="quote">"2"</span> <span class="attr">checked</span> <span class="attr">test</span>=<span class="quote">"12"</span>&gt;<span class="html">&lt;/script&gt;</span>
  </code></div>
</div>
'.strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '));
  end

end

# &lt;script src=<span class="quote">"<i>filename.js</i>"</span>&gt;&lt;/script&gt;
