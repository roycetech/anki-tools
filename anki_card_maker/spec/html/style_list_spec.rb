require './lib/html/style_list'


describe StyleList do

  let(:base) { StyleList.new(['keyword', 'quote']) }

  context 'add 1 supported' do
      
    subject do
      base.add('keyword', :color, 'red')
      base
    end

    it 'yields once' do
      expect{ |block| subject.each(&block) }.to yield_control.exactly(1).times
    end

    it 'yields with added style' do
      subject.each do |style| 
        expect(style.to_s).to eq(select('span.keyword', :color, 'red').to_s)
      end
    end


  end



  # it 'adds 2 supported, yields 2' do
  #   expect do |block| 
  #     subject.add('keyword', :color, 'red', &block)
  #     subject.add('quote', :color, 'green', &block)

  #   end.to yield_control.twice
  # end

  # it 'adds a supported style, yields the style' do

  # end

  # it 'adds a not supported style, do not yield' do

  # end



end