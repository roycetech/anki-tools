require './spec/spec_helper'

describe HtmlHelper do

  
  describe '#initialize' do

    context 'given no tag, front, back cards' do
      
      sut = HtmlHelper.new(BaseHighlighter.none, TagHelper.new([]), ['front'], ['back'])
      expected_front = ['<div class="main">','  front', '</div>']
      expected_back = ['<div class="main">','  back', '</div>']

      re_div_only = /<div[\d\D]*/m

      it 'stores ' + expected_front.join do        
        expect(sut.front_html[re_div_only].strip).to eq(expected_front.join("\n")) 
      end

      it 'stores ' + expected_back.join do        
        expect(sut.back_html[re_div_only].strip).to eq(expected_back.join("\n")) 
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


  end


end
