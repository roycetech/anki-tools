require './lib/highlighter/highlighter_csharp'

describe CSharpHighlighter do
  describe '#highlight_all' do

    let(:input) { 'virtual' }
    it "highlights keywords" do
      expect { subject.highlight_all!(input) }.to change { input }.from('virtual').to('<span class="keyword">virtual</span>')
    end

  end # method

end # class




