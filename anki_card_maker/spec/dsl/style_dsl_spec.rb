require './lib/dsl/selector_dsl'
require './lib/dsl/style_dsl'


describe SelectorDSL do

  subject(:dsl) do
    style do
      select 'div.main' do
        text_align 'left'
        font_size '16pt'
      end
      select 'input' do
        width '100%'
      end
    end
  end


  it 'has maintains list of selectors' do
    expect(dsl.styles.count).to eq(2)
  end


end  # class