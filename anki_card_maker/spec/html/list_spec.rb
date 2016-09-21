describe List do
  describe '#execute' do

    subject do     
      highlighter = BaseHighlighter.lang_none
      List.new(highlighter)
    end

    describe '1. given ordered list without code' do

      let(:input) { ['one', 'two'] }
      let(:builder) { HtmlBuilder.new }

      it 'returns with ol and li tags.' do
        subject.execute(builder, input, true)        
        expect(SpecUtils.clean_html(builder.build)).to eq(SpecUtils.join_array([
          '<ol>', 
          '  <li>one</li>',
          '  <li>two</li>',
          '</ol>'
        ])) 
      end

    end


    # describe '2. given ordered list with code' do

    #   input_array = [
    #     '`one`', 
    #     'two'
    #   ]

    #   it 'returns ol li and <code class="inline"> tags' do
    #     highlighter = BaseHighlighter.lang_none
    #     builder = HtmlBuilder.new
    #     sut.execute(builder, input_array, true)
        
    #     expected = SpecUtils.join_array([
    #       '<ol>', 
    #       '  <li><code class="inline">one</code></li>',
    #       '  <li>two</li>',
    #       '</ol>'
    #     ])
    #     expect(SpecUtils.clean_html(builder.build)).to eq(expected) 
    #   end

    # end


  end  # #execute
end  # class