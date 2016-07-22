require './spec/spec_helper'

describe Markdown do
  
  describe 'ITALIC Constant' do


    context 'given "func_get_args()"' do
      input_string = 'func_get_args()'
      it 'should not be tagged as italic' do
        parser = SourceParser.new
        parser.regexter('italic', Markdown::ITALIC[:regexp], Markdown::ITALIC[:lambda]);
        expect(parser.parse(input_string.clone)).to eq(input_string)
      end
    end




  end

end

