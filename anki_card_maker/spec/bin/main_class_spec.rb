require './bin/main_class'

#Note:

describe MainClass do


  let(:source_file) { File.join(File.expand_path('~'), 'dummy.md') }
  let(:test_output) { 'test_output.tsv' }

  subject { MainClass.new(source_file: source_file) }


  describe '#initialize' do
    
    it 'accepts provided source file' do

      expect(subject.source_absolute_path).to eq(source_file)
    end
  end


  describe '#execute' do

    it 'opens the source file for reading' do      
        allow(subject).to receive(:generate_output_filepath) { test_output }

      expect(File).to receive(:open).with(source_file, 'r')
      subject.execute()
    end

    it 'opens a CSV file for writing' do
      expect(File).to receive(:open).with(source_file, 'r') do |&block|
        block.call
      end

      allow(subject).to receive(:init_html_generator)

      allow(subject).to receive(:generate_output_filepath) {
        test_output 
      }

      allow(TagCounter).to receive(:new)
      # allow(SourceReader).to receive(:new)

      expect(CSV).to receive(:open).with(test_output, 'w', { col_sep: "\t"})
      subject.execute
    end

    it 'invokes process_card()' do
      expect(File).to receive(:open).with(source_file, 'r') do |&block|
        
        require 'stringio'

        block.call(StringIO.new([
          'front',
          '',
          'back'
          ].join("\n")))
      end

      allow(TagCounter).to receive(:new)

      allow(subject).to receive(:init_html_generator)

      allow(CSV).to receive(:open) do |&block|
        block.call
      end

      expect(subject).to receive(:process_card).at_least(1)

      subject.execute
    end

  end  # execute()


  describe '#init_html_generator' do
    
    context 'language defined' do

      let(:java_lang) { { lang: 'java' } }
      it 'initializes the html_generator' do

        allow(MetaReader).to receive(:read) { java_lang }

        expect{ subject.init_html_generator(nil) }.to change{ subject.html_generator }.from(nil)
      end

      it 'initializes the html_generator with "lang-specific highlighter "' do
        allow(MetaReader).to receive(:read) { java_lang }

        expect(HtmlGenerator).to receive(:new) do
          |args|
          expect(args.type).to eq('java')
        end
        subject.init_html_generator(nil)
      end

    end  # context: 'language defined'


    context 'language not defined' do
      it 'initializes the html_generator' do
        allow(MetaReader).to receive(:read) { Hash.new }
        expect{ subject.init_html_generator(nil) }.to change{ subject.html_generator }.from(nil)
      end

      it 'initializes the html_generator with "highlighter for none"' do
        allow(MetaReader).to receive(:read) { Hash.new }

        expect(HtmlGenerator).to receive(:new) do
          |args|
          expect(args.type).to eq('none')
        end
        subject.init_html_generator(nil)
      end

    end  # context: 'language defined'



  end  # init_html_generator()



  describe '#generate_output_filepath' do
    it 'generates filename based on source and date' do

    allow(Time).to receive(:now) {  Time.new(2000,2,3,4,5) }

      expect(subject.generate_output_filepath).to match(/.*\/dummy 2000Feb03_0405.tsv/)
    end
  end  # init_output_filename()

  # describe '#write_card' do
  #   let(:tags) { [:Concept] }
  #   let(:front) { ['front1'] }
  #   let(:back) { ['back1'] }
  #   let(:highlighter) { BaseHighlighter.lang_none }


  #   require 'stringio'

  #   let(:csv) { StringIO.new }

  #   it 'writes data to CSV' do

  #     subject.write_card(csv, front, back, tags, highlighter: highlighter)
  #     expect(csv.string).to eq(1)
  #   end

  # end

end  # MainClass

