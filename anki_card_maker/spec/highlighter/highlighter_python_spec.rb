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

    end # context


    input2 = %q(raw = r'c:\Users')
                    
    context "given '#{input2}'" do      
      expected2 = %q(raw = <span class="quote">r'c:\Users'</span>)

      it "returns '#{expected2}'" do
        sut = PythonHighlighter.new
        expect(sut.highlight_all(input2.clone)).to eq(expected2)
      end
    end # context


    input3 = %q(raw = r"c:\Users")
                    
    context "given '#{input3}'" do      
      expected3 = %q(raw = <span class="quote">r"c:\Users"</span>)

      it "returns '#{expected3}'" do
        sut = PythonHighlighter.new
        expect(sut.highlight_all(input3.clone)).to eq(expected3)
      end
    end # context


  end # method
  
end # class




