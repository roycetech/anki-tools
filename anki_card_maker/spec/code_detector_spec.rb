require './lib/code_detector'


describe CodeDetector do


  subject do
    sut = Object.new
    sut.extend(CodeDetector)
  end


  # Note: 1. Context Are Grouped into input types: no code, with inline, well, 
  # and both.
  context 'no code' do
    let(:input) { ['one'] }

    describe '.has_code?' do  
      it('returns falsey') { expect(subject.has_code?(input)).to be_falsy }
    end

    describe '.has_inline?' do  
      it('returns falsey') { expect(subject.has_inline?(input)).to be_falsy }
    end

    describe '.has_well?' do  
      it('returns falsy') { expect(subject.has_well?(input)).to be_falsy }
    end

    describe '.has_command?' do  
      it('returns falsy') { expect(subject.has_command?(input)).to be_falsy }
    end

  end


  context 'both inline and well, no command' do
    let(:input) { ['one `plus` two', '```lang', 'pass', '```'] }

    describe '.has_code?' do  
      it('returns truthy') { expect(subject.has_code?(input)).to be_truthy }
    end

    describe '.has_inline?' do  
      it('returns truthy') { expect(subject.has_inline?(input)).to be_truthy }
    end

    describe '.has_well?' do  
      it('returns truthy') { expect(subject.has_well?(input)).to be_truthy }
    end

    describe '.has_command?' do  
      it('returns falsy') { expect(subject.has_command?(input)).to be_falsy }
    end


    context 'inline only' do
      let(:input) { ['one `plus` two'] }

      describe '.has_code?' do  
        it('returns truthy') { expect(subject.has_code?(input)).to be_truthy }
      end

      describe '.has_inline?' do  
        it('returns truthy') { expect(subject.has_inline?(input)).to be_truthy }
      end

      describe '.has_well?' do  
        it('returns false') { expect(subject.has_well?(input)).to be_falsy }
      end

      describe '.has_command?' do  
        it('returns falsy') { expect(subject.has_command?(input)).to be_falsy }
      end

    end  # context: inline only


    context 'well only' do
      let(:input) { ['```lang', 'pass', '```'] }

      describe '.has_code?' do  
        it('returns truthy') { expect(subject.has_code?(input)).to be_truthy }
      end

      describe '.has_inline?' do  
        it('returns falsy') { expect(subject.has_inline?(input)).to be_falsy }
      end

      describe '.has_well?' do  
        it('returns falsy') { expect(subject.has_well?(input)).to be_truthy }
      end

      describe '.has_command?' do  
        it('returns falsy') { expect(subject.has_command?(input)).to be_falsy }
      end

    end  # context: well only
  end


  context 'command' do
    let(:input) { ['```lang', '$ git clone "sadf"', '```'].join("\n") }


    describe '.has_command?' do  
      it('returns truthy') { expect(subject.has_command?(input)).to be_truthy }
    end

  end




end  # class
