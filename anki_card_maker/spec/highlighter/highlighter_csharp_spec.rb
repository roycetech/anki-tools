require './spec/spec_helper'


describe CSharpHighlighter do
  describe '#highlight_all' do
        

    input1 = 'virtual'
    context "given '#{input1}'" do
      expected1 = '<span class="keyword">virtual</span>'

      it "returns #{expected1}" do
        sut = CSharpHighlighter.new
        expect(sut.highlight_all(input1.clone)).to eq(expected1)
      end
    end # context
    

  end # method
  
end # class




