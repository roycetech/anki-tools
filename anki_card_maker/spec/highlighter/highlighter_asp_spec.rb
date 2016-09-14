require './spec/spec_helper'


describe AspHighlighter do
  describe '#highlight_all' do


    sut = AspHighlighter.new

    input1 = '$ dotnet new -t web'
    context "given '#{input1}'" do      
      expected = '<span class="cmdline">$ <span class="cmd">dotnet</span> new <span class="opt">-t</span> web</span>'

      it "returns #{ expected }" do
        expect(sut.highlight_all(input1.clone)).to eq(expected)
      end
    end # context


    input2 = '<form asp-action="Create">'
    context "given '#{input2}'" do      
      expected = '<span class="symbol">&lt;</span><span class="html">form</span>&nbsp;<span class="attr">asp-action</span><span class="symbol">=</span><span class="quote">"Create"</span><span class="symbol">&gt;</span>'

      it "returns #{expected}" do
        expect(sut.highlight_all(input2.clone)).to eq(expected)
      end
    end # context

        
    input3 = '    @foreach(var item in Model) {'
    context "given '#{ input3 }'" do
      expected = '    @<span class="keyword">foreach</span>(<span class="keyword">var</span> item <span class="keyword">in</span> Model) {'

      it "returns #{ expected }" do
        expect(sut.highlight_all(input3.clone)).to eq(expected)
      end
    end # context


    input4 = '    <li>@item.Name</li>'
    context "given '#{ input4 }'" do
      expected = '&nbsp;&nbsp;&nbsp;&nbsp;<span class="symbol">&lt;</span><span class="html">li</span><span class="symbol">&gt;</span>@item.Name<span class="symbol">&lt;/</span><span class="html">li</span><span class="symbol">&gt;</span>'

      it "returns #{ expected }" do
        expect(sut.highlight_all(input4.clone)).to eq(expected)
      end
    end # context

    # multiline command
    input5 = '    <li>@item.Name</li>'
    context "given '#{ input5 }'" do
      expected = '&nbsp;&nbsp;&nbsp;&nbsp;<span class="symbol">&lt;</span><span class="html">li</span><span class="symbol">&gt;</span>@item.Name<span class="symbol">&lt;/</span><span class="html">li</span><span class="symbol">&gt;</span>'

      it "returns #{ expected }" do
        expect(sut.highlight_all(input5.clone)).to eq(expected)
      end
    end # context

    input6 = '@model List<ForgingAhead.Models.Quest>'
    context "given '#{ input6 }'" do
      expected = '@<span class="html">model</span> List&lt;ForgingAhead.Models.Quest&gt;'

      it "returns #{ expected }" do
        expect(sut.highlight_all(input6.clone)).to eq(expected)
      end
    end # context
    

  end # method
  
end # class




