require './spec/spec_helper'

describe HtmlUtils do

  sut = Object.new
  sut.extend(HtmlUtils)

  describe '1. #escape_spaces' do

    context 'positives' do 

      input1 = 'Hello World'
      context %Q(given "#{ input1 }") do
        expected = input1.clone
        it %Q(returns "#{ expected} ") do
          expect(sut.escape_spaces(input1)).to eq(expected) 
        end
      end

      input2 = '  <span class="quote">'
      context %Q(given "#{ input2 }") do
        expected = '&nbsp;&nbsp;<span class="quote">'
        it %Q(returns "#{ expected} ") do
          expect(sut.escape_spaces(input2)).to eq(expected) 
        end
      end

      input3 = '</span>  <span class="quote">'
      context %Q(given "#{ input3 }") do
        expected = '</span>&nbsp;&nbsp;<span class="quote">'
        it %Q(returns "#{ expected} ") do
          expect(sut.escape_spaces(input3)).to eq(expected) 
        end
      end


    end  # end positives context


    context 'negatives' do 

      
    end  # end negatives

  end  # 1. #escape_spaces


  describe '2. #escape_spaces!' do

    context 'positives' do 

      input1 = 'Hello World'
      context %Q(given "#{ input1 }") do
        expected = input1.clone
        it %Q(returns "#{ expected} ") do
          sut.escape_spaces!(input1)
          expect(input1).to eq(expected) 
        end
      end

      input2 = '  <span class="quote">'
      context %Q(given "#{ input2 }") do
        expected = '&nbsp;&nbsp;<span class="quote">'
        it %Q(returns "#{ expected} ") do
          sut.escape_spaces!(input2)
          expect(input2).to eq(expected) 
        end
      end

      input3 = '</span>  <span class="quote">'
      context %Q(given "#{ input3 }") do
        expected = '</span>&nbsp;&nbsp;<span class="quote">'
        it %Q(returns "#{ expected} ") do
          sut.escape_spaces!(input3)
          expect(input3).to eq(expected) 
        end
      end

    end  # end positives context


    context 'negatives' do 
    end  # end negatives


  end  # 2. #escape_spaces!


  describe '3. #wrap' do

    context 'positives' do 

      input1 = :quote, 'text'
      context %Q(given "#{ input1 }") do
        expected = %Q(<span class="quote">text</span>)
        it %Q(returns "#{ expected }") do          
          expect(sut.wrap(*input1)).to eq(expected) 
        end
      end

      input2 = :div, :attr, 'text'
      context %Q(given "#{ input2 }") do
        expected = %Q(<div class="attr">text</div>)
        it %Q(returns "#{ expected }") do          
          expect(sut.wrap(*input2)).to eq(expected) 
        end
      end


    end  # end positives context


    context 'negatives' do 
    end  # end negatives


  end  # 3. #span





end  # class
