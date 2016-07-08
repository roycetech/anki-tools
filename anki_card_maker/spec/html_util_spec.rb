require './spec/spec_helper'

describe HtmlUtil do

  describe ".escape" do

    context 'normal scenario' do
      input_string = '<html ng-app="parking">'
      it "replaces < and > with &lt; and &gt;" do
        expected_string = '&lt;html ng-app="parking"&gt;'
        expect(HtmlUtil.escape(input_string)).to eq(expected_string)
      end
    end

    context 'given "<code class="inline">no</code>"' do
      input_string = '<code class="inline">no</code>'
      it 'remains unchanged' do
        expect(HtmlUtil.escape(input_string.clone)).to eq(input_string)
      end
    end

  end

end
