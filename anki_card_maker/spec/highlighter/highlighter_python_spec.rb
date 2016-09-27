

describe PythonHighlighter do
  describe '#highlight_all' do

    describe 'given multi line' do

      let(:input) do 
        [ %Q(multiline = '''\\),
          'Line 1',
          %Q(Line 2''') ].join("\n").chomp 
      end

      let(:expected) do 
        [        
          %q(multiline = <span class="quote">'''\\),
          'Line 1',
          %q(Line 2'''</span>) ].join("\n").chomp
      end

      it 'wraps multiline in span' do
         expect(subject.highlight_all!(input)).to eq(expected)
      end

    end # context


    describe 'raw string' do
      it 'it wraps given single quote' do
        expect(subject.highlight_all!(%q(raw = r'c:\Users'))).to eq(%q(raw = <span class="quote">r'c:\Users'</span>))
      end
      it 'it wraps given double quote' do
        expect(subject.highlight_all!(%q(raw = r"c:\Users"))).to eq(%q(raw = <span class="quote">r"c:\Users"</span>))
      end
    end  # end context raw string    

  end # method
  
end # class




