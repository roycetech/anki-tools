require './spec/spec_helper'


describe SpringHighlighter do
  describe '#highlight_all' do

    input_string1 = 'char c = \'a\''
    context "given '#{input_string1}'" do

      expected1 = '<span class="keyword">char</span> c = <span class="quote">'\
        '\'a\'</span>'
      
      it "returns '#{expected1}'" do
        sut = SpringHighlighter.new
        expect(sut.highlight_all(input_string1.clone)).to eq(expected1)
      end
    end


    input_string2 = '<sec:authentication property="name" />'
    context "given '#{input_string2}'" do

      expected2 = '<span class="html">&lt;sec:authentication</span>&nbsp;'\
        '<span class="attr">property</span>=<span class="quote">"name"</span>'\
        '&nbsp;<span class="html">/&gt;</span>'
      
      it "returns '#{expected2}'" do
        sut = SpringHighlighter.new
        expect(sut.highlight_all(input_string2.clone)).to eq(expected2)
      end
    end

    input_string3 = '@RolesAllowed'
    context "given '#{input_string3}'" do

      expected3 = '<span class="ann">@RolesAllowed</span>'
      it "returns '#{expected3}'" do
        sut = SpringHighlighter.new
        expect(sut.highlight_all(input_string3.clone)).to eq(expected3)
      end
    end

    

  end
  
end




