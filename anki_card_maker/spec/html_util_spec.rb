require './spec/spec_helper'

describe HtmlUtil do
  input_string = '<html ng-app="parking">'

  describe "#escape" do
    it "replaces < and > with &lt; and &gt;" do
      expected_string = '&lt;html ng-app="parking"&gt;'
      expect(HtmlUtil.escape(input_string)).to eq(expected_string)
    end
  end

end
