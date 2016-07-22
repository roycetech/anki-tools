require './spec/spec_helper'

describe PhpHighlighter do
  
  describe '#highlight_all' do


    before(:each) { @sut = PhpHighlighter.new }


    context 'perl comment' do

      it 'wrap string after # in comment span' do
        input_string = 'Test # comment'
        expect(@sut.highlight_all(input_string)).to eq('Test <span class="comment"># comment</span>')
      end

    end


    context 'given "global $globalvar;"' do
      input_string = 'global $globalvar;'

      expected = '<span class="keyword">global</span>&nbsp;<span class="var">$globalvar</span>;'
      it 'should return "%s"' % expected do
        expect(@sut.highlight_all(input_string)).to eq(expected)
      end

    end


    context 'given "function __destruct() {}"' do
      input_string = 'function __destruct() {}'

      expected = '<span class="keyword">function</span> __destruct() {}'
      it 'should return "%s"' % expected do
        expect(@sut.highlight_all(input_string)).to eq(expected)
      end

    end

    context 'given "<?php"' do
      input_string = '<?php'

      expected = '<span class="phptag"><?php</span>'
      it 'should return "%s"' % expected do
        expect(@sut.highlight_all(input_string)).to eq(expected)
      end

    end

    context 'given "<?"' do
      input_string = '<?'

      expected = '<span class="phptag"><?</span>'
      it 'should return "%s"' % expected do
        expect(@sut.highlight_all(input_string)).to eq(expected)
      end

    end



  end
end

