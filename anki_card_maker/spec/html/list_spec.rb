require './spec/spec_helper'

describe List do
  describe '#execute' do

    highlighter = BaseHighlighter.lang_none
    sut = List.new(highlighter)

    describe '1. given ordered list without code' do

      input_array = ['one', 'two']

      it 'returns with ol and li tags.' do
        builder = HtmlBuilder.new
        sut.execute(builder, input_array, true)        
        expected = SpecUtils.join_array([
          '<ol>', 
          '  <li>one</li>',
          '  <li>two</li>',
          '</ol>'
        ])
        expect(SpecUtils.clean_html(builder.build).strip).to eq(expected) 
      end

    end


    describe '2. given ordered list with code' do

      input_array = [
        '`one`', 
        'two'
      ]

      it 'returns ol li and <code class="inline"> tags' do
        highlighter = BaseHighlighter.lang_none
        builder = HtmlBuilder.new
        sut.execute(builder, input_array, true)
        
        expected = SpecUtils.join_array([
          '<ol>', 
          '  <li><code class="inline">one</code></li>',
          '  <li>two</li>',
          '</ol>'
        ])
        expect(SpecUtils.clean_html(builder.build).strip).to eq(expected) 
      end

    end


  end
end