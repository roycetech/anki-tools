require './lib/html/code'
require './lib/highlighter/base_highlighter'


describe Code do

  let(:highlighter) { BaseHighlighter.lang_java }
  subject { Code.new(highlighter) }

  describe '#mark_codes' do

    context 'no codes' do
      let(:input) { 'one' }
      it 'does not change the input' do
        expect{ subject.mark_codes(input) }.not_to change{ input }
      end

      describe 'with markdown' do
        let(:input) { 'one *two*' }
        it 'changes the input' do
          expect{ subject.mark_codes(input) }.to change{ input }.from('one *two*').to('one <i>two</i>')
        end
      end
    end

    context 'with inline' do
      let(:input) { 'one `string` two' }
      it 'replaces the backticks with html tags' do
        expect{ subject.mark_codes(input) }.to change{ input }.from('one `string` two').to('one <code class="inline">string</code> two')
      end
      it 'calls highlighter on the code inside' do
        expect(highlighter).to receive(:highlight_all!).with('string')
        subject.mark_codes(input)
      end

      describe 'with markdown' do
        let(:input) { 'one `string` *two*' }
        it 'changes the input' do
          expect{ subject.mark_codes(input) }.to change{ input }.from('one `string` *two*').to('one <code class="inline">string</code> <i>two</i>')
        end
      end
    end

    context 'with well' do
      let(:input) { [ '```', 'string', '```' ].join("\n") }

      it 'replaces the triple backticks with html tags' do
        expect{ subject.mark_codes(input) }.to change{ input }.from([
         '```', 
         'string', 
         '```' 
        ].join("\n")).to([ 
          '<code class="well">', 
          'string', 
          '</code>' 
        ].join("\n"))
      end

      it 'calls highlighter on the code inside' do
        expect(highlighter).to receive(:highlight_all!).with('string')
        subject.mark_codes(input)
      end

    end

    context 'with well, 2 lines of code' do
      let(:input) { [ '```', 'car', 'laptop', '```' ].join("\n") }

      it 'replaces new lines with <br>\n' do
        expect{ subject.mark_codes(input) }.to change{ input }.from([
         '```', 
         'car', 
         'laptop', 
         '```' 
        ].join("\n")).to([ 
          '<code class="well">', 
          'car<br>', 
          'laptop', 
          '</code>' 
        ].join("\n").chomp)
      end
    end


  #   input_array = [
  #     '  <div class="well"><code>', 
  #     '  name = "peter"',
  #     '  </code></div>'
  #   ]

  #   it 'wraps "peter" in <span>' do
  #     highlighter = BaseHighlighter.lang_ruby
  #     sut = Code.new(highlighter)
  #     sut.execute(builder, input_array)
      
  #     expected = [
  #       '  <div class="well"><code>', 
  #       '  name = <span class="quote">"peter"</span>',
  #       '  </code></div>'
  #     ].join("\n").strip

  #     expect(builder.build.gsub(/&nbsp;/, ' ').strip).to eq(expected) 

  #   end
  # end


  # describe '#highlight_code' do

  #   input_array = ['called __type use__.']
  #   context "given '#{input_array}'" do
  #     expected = 'called <b>type use</b>.'
  #     it "returns '#{expected}'" do
  #       sut = Code.new nil
  #       expect(sut.highlight_code(input_array)).to eq(expected)
  #     end
  #   end

  #   python_input = ['  <div class="well"><code>', 
  #                   '  multiline = """\\',
  #                   'Line 1',
  #                   'Line 2"""',
  #                   '  </code></div>']
  #   context "given '#{python_input}'" do
  #     python_expected = [
  #       '<div class="well"><code>', 
  #       '  multiline = <span class="quote">"""\\',
  #       'Line 1',
  #       'Line 2"""</span>',
  #       '  </code></div>'
  #     ].join("\n").strip

  #     it "returns '#{python_expected}'" do
  #       highlighter = BaseHighlighter.lang_python
  #       builder = HtmlBuilder.new
  #       sut = Code.new(highlighter)
  #       expect(sut.highlight_code(python_input).gsub('&nbsp;', ' ').strip).to eq(python_expected)
  #     end
  #   end


  #   multi_input = [
  #     'one',
  #     '```',
  #     '$ first',
  #     '```',
  #     'two',
  #     '```',
  #     '$ second',
  #     '```'
  #   ]
  #   context "given multi-well" do
      
  #     multi_expected = [
  #       'one',
  #       '<div class="well"><code>', 
  #       '<span class="cmdline">$ <span class="cmd">first</span></span>',
  #       '  </code></div>',
  #       'two',
  #       '<div class="well"><code>', 
  #       '<span class="cmdline">$ <span class="cmd">second</span></span>',
  #       '  </code></div>'
  #     ].join("\n").strip

  #     it "returns '#{multi_expected}'" do
  #       highlighter = BaseHighlighter.lang_asp
  #       builder = HtmlBuilder.new
  #       sut = Code.new(highlighter)
  #       expect(sut.highlight_code(multi_input).gsub('&nbsp;', ' ').strip).to eq(multi_expected)
  #     end


  #   end


  end  # method

end  # class
