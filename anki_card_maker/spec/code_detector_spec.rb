require './lib/code_detector'


describe CodeDetector do


  subject do
    sut = Object.new
    sut.extend(CodeDetector)
  end


  describe '#has_well' do
    let(:well_placeholder) { ['```', 'one', '```'] }
    let(:well_html) { ['<code class="well">', 'one', '</code>'] }
    
    it 'supports code block place holder' do
      expect(subject.has_well?(well_placeholder.join("\n"))).to be true
    end

    it 'supports code block html' do
      expect(subject.has_well?(well_html.join("\n"))).to be true
    end

    it 'supports string array placeholder' do
      expect(subject.has_well?(well_placeholder)).to be true
    end

    it 'supports string array html' do
      expect(subject.has_well?(well_html)).to be true
    end
  end


  # Note: 1. Context Are Grouped into input types: no code, with inline, well, 
  # and both.
  context 'no code' do
    let(:input) { ['one'] }

    describe '.has_code?' do  
      it('returns false') { expect(subject.has_code?(input)).to be false }
    end

    describe '.has_inline?' do  
      it('returns false') { expect(subject.has_inline?(input)).to be false }
    end

    describe '.has_well?' do  
      it('returns false') { expect(subject.has_well?(input)).to be false }
    end

    describe '.has_command?' do  
      it('returns false') { expect(subject.has_command?(input)).to be false }
    end

  end


  context 'both inline and well, no command' do
    let(:input) { ['one `plus` two', '```lang', 'pass', '```'] }

    describe '.has_code?' do  
      it('returns true') { expect(subject.has_code?(input)).to be true }
    end

    describe '.has_inline?' do  
      it('returns true') { expect(subject.has_inline?(input)).to be true }
    end

    describe '.has_well?' do  
      it('returns true') { expect(subject.has_well?(input)).to be true }
    end

    describe '.has_command?' do  
      it('returns false') { expect(subject.has_command?(input)).to be false }
    end


    context 'inline only' do
      let(:input) { ['one `plus` two'] }

      describe '.has_code?' do  
        it('returns true') { expect(subject.has_code?(input)).to be true }
      end

      describe '.has_inline?' do  
        it('returns true') { expect(subject.has_inline?(input)).to be true }
      end

      describe '.has_well?' do  
        it('returns false') { expect(subject.has_well?(input)).to be false }
      end

      describe '.has_command?' do  
        it('returns false') { expect(subject.has_command?(input)).to be false }
      end

    end  # context: inline only


    context 'well only' do
      let(:input) { ['```lang', 'pass', '```'] }

      describe '.has_code?' do  
        it('returns true') { expect(subject.has_code?(input)).to be true }
      end

      describe '.has_inline?' do  
        it('returns false') { expect(subject.has_inline?(input)).to be false }
      end

      describe '.has_well?' do  
        it('returns false') { expect(subject.has_well?(input)).to be true }
      end

      describe '.has_command?' do  
        it('returns false') { expect(subject.has_command?(input)).to be false }
      end

    end  # context: well only
  end


  context 'command' do
    let(:input) { ['```lang', '$ git clone "sadf"', '```'].join("\n") }


    describe '.has_command?' do  
      it('returns true') { expect(subject.has_command?(input)).to be true }
    end

  end




end  # class
