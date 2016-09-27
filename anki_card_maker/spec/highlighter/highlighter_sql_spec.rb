require './lib/highlighter/highlighter_sql'


describe SqlHighlighter do
  describe '#highlight_all' do

    let(:input) { 'SYSTIMESTAMP' }
    it 'does not mark partial match' do
      expect{ subject.highlight_all!(input) }.not_to change{input}
    end

    let(:data_type) { 'NVARCHAR2' }
    it 'marks data type' do
      expect{ subject.highlight_all!(data_type) }.to change{data_type}.
        from('NVARCHAR2').to('<span class="keyword">NVARCHAR2</span>')
    end

  end # method
  
end # class




