describe SourceReader do

  context 'utility methods' do
    subject { SourceReader.new(nil) }

      describe '#validate_tag_declaration' do

        it 'ignores non-tag' do
          expect { subject.validate_tag_declaration('Sentence') }.not_to raise_error
        end

        it 'has to be case sensitive' do
          expect { subject.validate_tag_declaration('@tags: Concept') }.to raise_error(RuntimeError)
        end

        it 'needs the colon:' do
          expect { subject.validate_tag_declaration('@Tags Concept') }.to raise_error(RuntimeError)
        end

        it 'needs space after colon:' do
          expect { subject.validate_tag_declaration('@Tags:Concept') }.to raise_error(RuntimeError)
        end

      end  # validate_tag_declaration method


      describe '#blank_or_comment?' do

        it 'returns true if spaces' do
          expect(subject.blank_or_comment?('   ')).to be true 
        end

        it 'returns true if comment' do
          expect(subject.blank_or_comment?('#   ')).to be true 
        end

        it 'returns true if blank' do
          expect(subject.blank_or_comment?('')).to be true 
        end

        it 'returns false if tag' do
          expect(subject.blank_or_comment?('@Tags: Concept')).to be_falsy 
        end

        it 'returns false if card' do
          expect(subject.blank_or_comment?('front')).to be_falsy 
        end

      end  # blank_or_comment? method

  end  # utility methods  


  describe "#each_card" do


    require 'stringio'


    context 'single card' do
      
      let(:front) { 'front' }
      let(:back) { 'back' }

      subject(:reader) do
        file = StringIO.new([
          front,
          '',
          back
          ].join("\n"))
        SourceReader.new(file)
      end

      it 'yields once' do
        expect { |b| subject.each_card(&b) }.to yield_control
      end

      it 'yields the cards' do 
        expect { |b| subject.each_card(&b) }.to yield_with_args([], [front], [back])
      end

    end  # context: single-card


    context 'double card' do
      
      let(:front1) { 'front1' }
      let(:back1) { 'back1' }
      let(:front2) { 'front2' }
      let(:back2) { 'back2' }

      subject(:reader) do
        file = StringIO.new([
          front1,
          '',
          back1,
          '',
          '',
          front2,
          '',
          back2,
          ].join("\n"))
        SourceReader.new(file)
      end

      it 'yields twice' do
        expect { |b| subject.each_card(&b) }.to yield_control.twice
      end

      it 'yields the cards' do 
        expect { |b| subject.each_card(&b) }.to yield_successive_args([
          [], [front1], [back1]], [[], [front2], [back2]
        ])
      end

    end  # context: double-card


    context 'with tag' do

      let(:front1) { 'front1' }
      let(:back1) { 'back1' }
      let(:front2) { 'front2' }
      let(:back2) { 'back2' }
      let(:tags) { [:Concept, :Abbr] }

      subject(:reader) do
        file = StringIO.new([
          '@Tags: Abbr',
          front1,
          '',
          back1,
          '',
          '',
          '@Tags: Concept',
          front2,
          '',
          back2,
          ].join("\n"))
        SourceReader.new(file)
      end


      context 'with "Abbr" tag' do
        it 'appends "Abbreviation to the front card"' do

          expect { |b| subject.each_card(&b) }.to yield_successive_args([
          [:Abbr], [front1 + ' abbreviation'], [back1]], [[:Concept], [front2], [back2]
            ])
        end
      end



    end  # context: with tag


  end  # each_card()
end  # class
