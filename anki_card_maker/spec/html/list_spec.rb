require './spec/spec_helper'

describe List do
  describe '#execute' do


    describe '1. given ordered list without code' do

      input_array = [
        'one', 
        'two'
      ]

      it 'returns with ol and li tags.' do
        highlighter = BaseHighlighter.none
        builder = HtmlBuilder.new
        sut = List.new(highlighter)
        sut.execute(builder, input_array, true)
        
        expected = [
          '<ol>', 
          '  <li>one</li>',
          '  <li>two</li>',
          '</ol>'
        ].join("\n")
        expect(builder.build.gsub(/&nbsp;/, ' ').strip).to eq(expected.strip) 
      end

    end


    describe '2. given ordered list with code' do

      input_array = [
        '`one`', 
        'two'
      ]

      it 'returns ol li and <code class="inline"> tags' do
        highlighter = BaseHighlighter.none
        builder = HtmlBuilder.new
        sut = List.new(highlighter)
        sut.execute(builder, input_array, true)
        
        expected = [
          '<ol>', 
          '  <li><code class="inline">one</code></li>',
          '  <li>two</li>',
          '</ol>'
        ].join("\n")
        expect(builder.build.gsub(/&nbsp;/, ' ').strip).to eq(expected.strip) 
      end

    end


  end
end