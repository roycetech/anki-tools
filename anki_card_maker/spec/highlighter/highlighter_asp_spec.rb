require './spec/spec_helper'


describe AspHighlighter do
  describe '#highlight_all' do

    input1 = '$ dotnet new -t web'
    context "given '#{input1}'" do      
      expected1 = '<span class="cmdline">$ <span class="cmd">dotnet</span> new <span class="opt">-t</span> web</span>'

      it "returns #{expected1}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input1.clone)).to eq(expected1)
      end
    end # context


    input2 = '<form asp-action="Create">'
    context "given '#{input2}'" do      
      expected2 = '<span class="symbol">&lt;</span><span class="html">form</span>&nbsp;<span class="attr">asp-action</span><span class="symbol">=</span><span class="quote">"Create"</span><span class="symbol">&gt;</span>'

      it "returns #{expected2}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input2.clone)).to eq(expected2)
      end
    end # context

        
    input3 = '    @foreach(var item in Model) {'
    context "given '#{input3}'" do
      expected3 = '    @<span class="keyword">foreach</span>(<span class="keyword">var</span> item <span class="keyword">in</span> Model) {'

      it "returns #{expected3}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input3.clone)).to eq(expected3)
      end
    end # context


    input4 = '    <li>@item.Name</li>'
    context "given '#{input4}'" do
      expected4 = '&nbsp;&nbsp;&nbsp;&nbsp;<span class="symbol">&lt;</span><span class="html">li</span><span class="symbol">&gt;</span>@item.Name<span class="symbol">&lt;/</span><span class="html">li</span><span class="symbol">&gt;</span>'

      it "returns #{expected4}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input4.clone)).to eq(expected4)
      end
    end # context

    # multiline command
    input5 = '    <li>@item.Name</li>'
    context "given '#{input5}'" do
      expected5 = '&nbsp;&nbsp;&nbsp;&nbsp;<span class="symbol">&lt;</span><span class="html">li</span><span class="symbol">&gt;</span>@item.Name<span class="symbol">&lt;/</span><span class="html">li</span><span class="symbol">&gt;</span>'

      it "returns #{expected5}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input5.clone)).to eq(expected5)
      end
    end # context

    input6 = '@model List<ForgingAhead.Models.Quest>'
    context "given '#{input6}'" do
      expected6 = '@<span class="html">model</span> List&lt;ForgingAhead.Models.Quest&gt;'

      it "returns #{expected6}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input6.clone)).to eq(expected6)
      end
    end # context
    

  end # method
  
end # class




