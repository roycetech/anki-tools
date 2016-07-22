require './spec/spec_helper'

describe HtmlHelper do

  
  describe '#initialize' do

    re_div_only = /<div[\d\D]*/m

    context 'given no tag, front, back cards' do
      
      sut = HtmlHelper.new(BaseHighlighter.none, TagHelper.new([]), ['front'], ['back'])
      expected_front = ['<div class="main">','  front', '</div>']
      expected_back = ['<div class="main">','  back', '</div>']


      it 'stores ' + expected_front.join do        
        expect(sut.front_html[re_div_only].strip).to eq(expected_front.join("\n")) 
      end

      it 'stores ' + expected_back.join do        
        expect(sut.back_html[re_div_only].strip).to eq(expected_back.join("\n")) 
      end

    end

    context 'given EnumU with lines: one, two' do
      
      sut = HtmlHelper.new(BaseHighlighter.none, 
        TagHelper.new(['EnumU']), 
        ['front'], 
        ['one', 'two'])
      
      it 'returns "EnumU:2 and system tag Enum' do
        expected = [
          '<div class="main">',
          '  <span class="tag">EnumU:2</span><br>',
          '  front',
          '</div>'
        ]

        expect(sut.front_html[re_div_only].strip).to eq(expected.join("\n"))
      end

    end

  end


  describe '#line_to_html_raw' do

    # dummy instance
    sut = HtmlHelper.new(BaseHighlighter.none, TagHelper.new([]), ['front'], ['back'])

    context 'given "_hello_"' do
      input_string = '_hello_'
      
      it 'return "<i>hello</i>"' do
        expect(sut.line_to_html_raw(input_string)).to eq('<i>hello</i>')
      end
    end

    context 'given "`code`"' do
      input_string = '`code`'
      
      it 'return "<code class="inline">code</code>"' do
        expect(sut.line_to_html_raw(input_string)).to eq('<code class="inline">code</code>')
      end
    end

    context 'given "__hello__"' do
      input_string = '__hello__'
      
      it 'return "<b>hello</b>"' do
        expect(sut.line_to_html_raw(input_string)).to eq('<b>hello</b>')
      end
    end

    context 'given "íhelloí"' do
      input_string = 'íhelloí'
      
      it 'return "<i>hello</i>"' do
        expect(sut.line_to_html_raw(input_string)).to eq('<i>hello</i>')
      end
    end

  end


end
