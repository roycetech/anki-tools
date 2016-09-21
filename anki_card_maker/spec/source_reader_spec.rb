describe SourceReader do

  describe "#each_card" do

    
    context "given file with one card" do
      input_filename = './spec/data/file1_spec.txt'

      it "yields once, with arguments [], [front], [back]" do
        File.open(input_filename, 'r') do |file|
          sut = SourceReader.new(file)

          actual = []
          sut.each_card do |tag, front, back|
            actual << [tag, front, back]
          end
          expect(actual).to eq([[[], ['front'], ['back']]])
        end
      end

    end


    context 'given EnumU with "one", "two"' do
      input_filename = './spec/data/file2_enum_spec.txt'
      it 'yields once with "Enum" tag' do
        File.open(input_filename, 'r') do |file|
          sut = SourceReader.new(file)

          actual = []
          sut.each_card do |tag, front, back|
            actual << tag
          end
          expect(actual).to eq([['EnumU']])
        end

      end
    end


  end
end
