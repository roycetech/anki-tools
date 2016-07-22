require './spec/spec_helper'

describe Code do
  
  describe '#execute' do
    
    context 'Given Ruby String assignment in well, ' do
      
      input_array = [
        '  <div class="well"><code>', 
        '  name = "peter"',
        '  </code></div>'
      ]

      it 'wraps "peter" in <span>' do
        highlighter = BaseHighlighter.ruby
        builder = HtmlBuilder.new
        sut = Code.new(highlighter)
        sut.execute(builder, input_array)
        
        expected = [
          '  <div class="well"><code>', 
          '  name = <span class="quote">"peter"</span>',
          '  </code></div>'
        ].join("\n")

        expect(builder.build.gsub(/&nbsp;/, ' ').strip).to eq(expected.strip) 

      end

    end
  end


  describe '#highlight_code' do

    input_array = ['called __type use__.']
    context "given '#{input_array}'" do
      expected = 'called <b>type use</b>.'
      it "returns '#{expected}'" do
        sut = Code.new nil
        expect(sut.highlight_code(input_array)).to eq(expected)
      end

    end

  end


end