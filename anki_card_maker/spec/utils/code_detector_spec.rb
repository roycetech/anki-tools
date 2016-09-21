describe CodeDetector do

  describe '.has_code' do

    context 'token' do
      input1 = ['`one`']
      it 'returns "true"' do 
        expect(CodeDetector::has_code?(input1)).to eq(true) 
      end
    end

    context 'none' do
      input2 = ['one']
      it 'returns "false"' do 
        expect(CodeDetector::has_code?(input2)).to eq(false) 
      end
    end

    context 'within' do
      input3 = ['xx `one` yy']
      it 'returns "true"' do 
        expect(CodeDetector::has_code?(input3)).to eq(true) 
      end
    end

    context 'well' do
      input4 = ['one', '```Hello']
      it 'returns "true"' do 
        expect(CodeDetector::has_code?(input4)).to eq(true) 
      end
    end

  end  # method
end  # class
