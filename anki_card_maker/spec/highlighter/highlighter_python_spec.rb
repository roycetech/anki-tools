require './spec/spec_helper'


describe PythonHighlighter do
  describe '#highlight_all' do


    input1 = [  %Q(multiline = '''\\),
                'Line 1',
               %Q(Line 2''')
                    ].join("\n").chomp

    context "given '#{input1}'" do
      
      expected1 = [        
        %q(multiline = <span class="quote">'''\\),
        'Line 1',
        %q(Line 2'''</span>)        
      ].join("\n").chomp

      it "returns '#{expected1}'" do
        sut = PythonHighlighter.new
        expect(sut.highlight_all(input1.clone)).to eq(expected1)
      end

    end

  end
  
end




