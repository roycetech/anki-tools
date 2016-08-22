require './spec/spec_helper'


describe SqlHighlighter do
  describe '#highlight_all' do

    input1 = 'SYSTIMESTAMP'                    
    context "given '#{input1}'" do      
      expected1 = 'SYSTIMESTAMP'

      it "does not highlight partial data type match" do
        sut = SqlHighlighter.new
        expect(sut.highlight_all(input1.clone)).to eq(expected1)
      end
    end # context
    

    input2 = 'NVARCHAR2'                    
    context "given '#{input2}'" do      
      expected2 = '<span class="keyword">NVARCHAR2</span>'

      it "returns #{expected2}" do
        sut = SqlHighlighter.new
        expect(sut.highlight_all(input2.clone)).to eq(expected2)
      end
    end # context


  end # method
  
end # class




