require './spec/spec_helper'


describe AspHighlighter do
  describe '#highlight_all' do

    input1 = '$ dotnet new -t web'
    context "given '#{input1}'" do      
      expected1 = '&nbsp;&nbsp;<span class="cmdline">$ <span class="cmd">dotnet</span> new <span class="opt">-t</span> web</span>'

      it "returns #{expected1}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input1.clone)).to eq(expected1)
      end
    end # context


    input2 = '<form asp-action="Create">'
    context "given '#{input2}'" do      
      expected2 = '<span class="html">&lt;form</span>&nbsp;<span class="attr">asp-action</span>=<span class="quote">"Create"</span><span class="html">&gt;</span>'

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
      expected4 = '&nbsp;&nbsp;&nbsp;&nbsp;<span class="html">&lt;li&gt;</span>@item.Name<span class="html">&lt;/li&gt;</span>'

      it "returns #{expected4}" do
        sut = AspHighlighter.new
        expect(sut.highlight_all(input4.clone)).to eq(expected4)
      end

    end # context


  end # method
  
end # class




