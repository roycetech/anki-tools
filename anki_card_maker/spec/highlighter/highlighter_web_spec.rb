require './spec/spec_helper'

describe WebHighlighter do
  
  describe '#highlight_all' do

    context 'when unmatched code' do

      it 'returns the same as input' do
        input_string = 'hello'
        sut = WebHighlighter.new
        expect(sut.highlight_all(input_string)).to eq(input_string)
      end

    end
  end
end

