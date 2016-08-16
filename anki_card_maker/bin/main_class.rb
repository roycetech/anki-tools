#!/usr/bin/env ruby

require 'simplecov'
SimpleCov.start

require './lib/class_extensions'
require './lib/tag_helper'
require './lib/html_helper'
require './lib/reviewer'
require './lib/source_reader'
require './lib/meta_reader'
require './lib/latest_file_finder'
require './lib/source_parser'
require './lib/tag_counter'

require './lib/highlighter/highlighters_enum'


require './bin/upload' unless $unit_test
require './lib/mylogger'
require 'CSV'


class MainClass


  # Initialize source file name.
  def initialize(opts={})

    @@highlighter = BaseHighlighter
    @@untagged_count = 0

    @reviewer = Reviewer.new

    hash = {
      :source_file => '/Users/royce/Dropbox/Documents/Reviewer/@test.txt'
    }.merge(opts);  

    @@filepath = hash[:source_file]

    $logger.info "File Path: #@@filepath"
    @@filepath = Dir.pwd + File::SEPARATOR + @@filepath unless @@filepath.start_with?(File::SEPARATOR)
    generate_output_filename()
  end

  def generate_output_filename
    today = Time.new

    source_filename = @@filepath[@@filepath.rindex('/') + 1 .. @@filepath.rindex('.')-1]
    simple_name = source_filename

    @@outputFilename = '/Users/royce/Desktop/Anki Generated Sources/%s %s%s%s_%s%s.tsv' %
    [simple_name,
      today.year % 1000,
      '%02d' % today.month,
      '%02d' % today.day,
      '%02d' % today.hour,
      '%02d' % today.min]
  end

  def pbcopy(input)
   str = input.to_s
   IO.popen('pbcopy', 'w') { |f| f << str }
   str
  end

  def execute
    $logger.info 'Program Start. Unit Test: %s' % ($unit_test ? 'Y' : 'n')
    return if $unit_test


    File.open(@@filepath, 'r') do |file|
      @tag_count_map = TagCounter.new.count_tags(file)
      CSV.open(@@outputFilename, 'w', {:col_sep => "\t"}) do |csv|

        meta_map = MetaReader.read(file)
        language = meta_map['lang']
        $logger.debug("Language: #{language}")
        if language
          @@highlighter = @@highlighter.send(language.downcase)
        else
          @@highlighter = BaseHighlighter.none
        end

        SourceReader.new(file).each_card do |tags, front, back|
            write_card(csv, front, back, tags)
        end

        @reviewer.print_sellout
        @reviewer.print_duplicate
        @reviewer.print_card_count
        @reviewer.show_multi

        deckname = @@outputFilename[@@outputFilename.rindex('/') + 1..@@outputFilename.index('.') - 1]
        pbcopy deckname
        puts('', deckname , '')
      end
    end
  end

  def write_card(csv, front, back, tags)
    tag_helper = TagHelper.new(tags)

    back.pop if back[-1] == ''
    tag_helper.find_multi(back)

    shown_tags = tag_helper.visible_tags
    @reviewer.count_sentence(tag_helper, front, back)

    html_helper = HtmlHelper.new(@@highlighter, tag_helper, front, back)

    @reviewer.detect_sellouts(front, back) unless tag_helper.is_front_only?

    lst = [html_helper.front_html, html_helper.back_html]

    if tag_helper.untagged?
      lst.push 'untagged'
    else

      tags_numbered = tags.map do |tag|
        count = @tag_count_map[tag]
        if count == 1
          tag
        else
          "#{tag}(#{count})"
        end
      end

      lst.push tags_numbered.join(',')
    end

    if $logger.debug?

      re_styleless = /<div[\d\D]*/m

      # $logger.debug("Front: \n" + lst[0] + "\n\n")
      # $logger.debug("Back: \n" + lst[1] + "\n\n")

      $logger.debug("Front: \n" + lst[0][re_styleless] + "\n\n")
      $logger.debug("Back: \n" + lst[1][re_styleless] + "\n\n")


      # $logger.debug("Tag: \n" + lst[2] + "\n\n")
    end

    @reviewer.addFrontCard(tags, front)

    csv << lst
  end

end


path = '/Users/royce/Dropbox/Documents/Reviewer'


if not $unit_test
  if ARGV.empty? or 'upload' === ARGV[0]
    # - Generate a single file
    main = MainClass.new({:source_file => LatestFileFinder.new(path, '*.md').find})
    main.execute

    RunSelenium.execute if not ARGV.empty? and 'upload' === ARGV[0].downcase

  else
    # - Generate multiple file
    finder = LatestFileFinder.new(path)
    finder.find
    last_updated_folder = finder.latest_folder
    generate_multi(last_updated_folder, ARGV[0])
  end
end


# - Generate for all files in a folder
def generate_multi(folder, file_wild_card)
  Dir[File.join(File.join(folder), file_wild_card)].each do |filename|
    $logger.info filename
    main = MainClass.new({:source_file => filename})
    main.execute
    RunSelenium.execute
  end
end


# - Remove all files inside a folder, DANGER!!!
# output_path = '/Users/royce/Desktop/Anki Generated Sources'
# $logger.info("Deleting all files inside the output folder: #{output_path}")
# Dir[File.join(output_path, '*.tsv')].each do |filename|
#   File.delete(filename)
# end
