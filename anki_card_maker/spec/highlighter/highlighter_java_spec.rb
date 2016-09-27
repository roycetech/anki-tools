# require './lib/highlighter/highlighter_java'
require './lib/highlighter/base_highlighter'


describe JavaHighlighter do
  describe '#highlight_all' do

    input_string1 = 'called __type use__.'
    context "given '#{input_string1}'" do

      expected = 'called <b>type use</b>.'
      it "returns '#{ expected }'" do
        expect(subject.highlight_all!(input_string1.clone)).to eq(expected)
      end
    end


    input_string2 = 'public @interface Ann'
    context "given '#{ input_string2 }'" do

      expected = '<span class="keyword">public</span>&nbsp;<span '\
        'class="keyword">@interface</span> Ann'
      
      it "returns '#{ expected }'" do
        expect(subject.highlight_all!(input_string2.clone)).to eq(expected)
      end
    end

    input_string3 = 'int i = 0;'
    context "given '#{ input_string3 }'" do

      expected = '<span class="keyword">int</span> i = <span class="num">0'\
        '</span>;'
      
      it "returns '#{ expected }'" do
        expect(subject.highlight_all!(input_string3.clone)).to eq(expected)
      end
    end

  end
  
end




