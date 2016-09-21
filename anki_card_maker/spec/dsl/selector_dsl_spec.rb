require './lib/dsl/selector_dsl'


describe SelectorDSL do


  subject(:dsl) do
    select 'div.main' do
      color 'white'
      text_align 'left'
    end
  end


  let(:first) { :color }
  let(:second) { :'text-align' }


  describe 'style names' do
    it 'hash contains added' do
      expect(dsl.styles_hash.keys).to include(first)
    end

    it 'hash converts underscore to dash' do
      expect(dsl.styles_hash.keys).to include(second)
    end

    it 'list contains added' do
      expect(dsl.style_names).to include(first)
    end

    it 'list contains converted property name' do
      expect(dsl.style_names).to include(second)
    end    

  end


  describe 'style values' do

    it 'contains added' do
      expect(dsl.styles_hash[first]).to include('white')
      expect(dsl.styles_hash[second]).to include('left')
    end

  end


end  # class