require './lib/html_helper'
require './lib/tag_helper'


describe HtmlGenerator do
  

  describe '#initialize' do
    describe 'correct argument' do
      subject { HtmlGenerator.new(JavaHighlighter.new) }

      it 'accepts param of type BaseHighlighter' do
        expect(subject.highlighter).not_to be nil
      end
    end

    describe 'incorrect argument' do
      it 'raises an error' do
        expect{ HtmlGenerator.new(nil) }.to raise_error(AssertionError)
      end
    end

  end  # initialize()


  describe '#build_tags' do

    subject { HtmlGenerator.new(NoneHighlighter.new) } 

    context 'given :Concept, :List' do
      let(:tag_helper) { TagHelper.new(tags: [:Concept, :List])}

      it 'returns in html' do
        expect(subject.build_tags(tag_helper, nil)).to eq([
            '<div class="tags">',
            '  <span class="tag">Concept</span>',
            '  <span class="tag">List</span>',
            '</div>'
          ].join("\n").strip)
      end
    end


  end

end  # class
