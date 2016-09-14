require './spec/spec_helper'

describe BaseHighlighter do
  describe '#initialize' do

    sut = BaseHighlighter.lang_none

    context 'given "hello _robin_!" ' do
      input_string = 'hello _robin_!'
      it 'returns "hello <i>robin<i>!"' do
        expect(sut.highlight_all(input_string)).to eq('hello <i>robin</i>!')
      end

    end 

    context 'given "bye **robin**!" ' do
      input_string = 'bye **robin**!'
      it 'returns "bye <b>robin</b>!"' do
        expect(sut.highlight_all(input_string)).to eq('bye <b>robin</b>!')
      end
    end

  end  
end