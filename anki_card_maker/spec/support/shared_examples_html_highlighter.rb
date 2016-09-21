shared_examples_for 'html highlighter' do |highlighter|
  it 'escapes spaces to &nbsp;' do
    expect(highlighter.highlight_all(' <span>')).to match(/&nbsp;.*/)
  end

  it 'escapes angles' do
    expect(highlighter.highlight_all(' <span>')).not_to match(/<span>/)
  end

  it 'ignores <br>' do
    input = 'one<br>'
    expect { highlighter.highlight_all(input) }.not_to change { input }
  end

  
end