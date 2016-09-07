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
        ].join("\n").strip

        expect(builder.build.gsub(/&nbsp;/, ' ').strip).to eq(expected) 

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

    python_input = ['  <div class="well"><code>', 
                    '  multiline = """\\',
                    'Line 1',
                    'Line 2"""',
                    '  </code></div>']
    context "given '#{python_input}'" do
      python_expected = [
        '<div class="well"><code>', 
        '  multiline = <span class="quote">"""\\',
        'Line 1',
        'Line 2"""</span>',
        '  </code></div>'
      ].join("\n").strip

      it "returns '#{python_expected}'" do
        highlighter = BaseHighlighter.python
        builder = HtmlBuilder.new
        sut = Code.new(highlighter)
        expect(sut.highlight_code(python_input).gsub('&nbsp;', ' ').strip).to eq(python_expected)
      end
    end


    multi_input = [
      'one',
      '```',
      '$ first',
      '```',
      'two',
      '```',
      '$ second',
      '```'
    ]
    context "given multi-well" do
      
      multi_expected = [
        'one',
        '<div class="well"><code>', 
        '  <span class="cmdline">$ <span class="cmd">first</span>',
        '  </span></code></div>',
        'two',
        '<div class="well"><code>', 
        '  <span class="cmdline">$ <span class="cmd">second</span>',
        '  </span></code></div>'
      ].join("\n").strip

      it "returns '#{multi_expected}'" do
        highlighter = BaseHighlighter.asp
        builder = HtmlBuilder.new
        sut = Code.new(highlighter)
        expect(sut.highlight_code(multi_input).gsub('&nbsp;', ' ').strip).to eq(multi_expected)
      end


    end


  end  # method

end  # class
