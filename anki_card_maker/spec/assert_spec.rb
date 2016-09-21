describe Assert do
  
  describe '#assert' do

    subject(:module) { 
      sut = Object.new
      sut.extend(Assert) 
    }

    it 'raises AssertionError if false' do 
      expect { subject.assert(false, message: 'Error') }.to raise_error(Assert::AssertionError)
    end

    it 'is silent if expr is truthy' do 
      expect { subject.assert(true, message: 'Impossible to error') }.not_to raise_error
    end

  end

end

