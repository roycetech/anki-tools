#!/usr/bin/env ruby

require 'simplecov'
SimpleCov.start

require './lib/class_extensions'


# review requires below...

require 'active_support/concern'
require 'active_support/inflector'

require './lib/tag_helper'

require './lib/utils/oper_utils'
require './lib/utils/regexp_utils'
require './lib/utils/html_utils'
require './lib/markdown'
require './lib/html_generator'

require './lib/reviewer'
require './lib/source_reader'
require './lib/meta_reader'
require './lib/latest_file_finder'
require './lib/source_parser'
require './lib/tag_counter'



require './bin/upload' unless $unit_test
require './lib/mylogger'
require 'CSV'

require './lib/system_tag_counter'


class MainClass


  # Configuration
  Home_Path = File.expand_path('~')
  TSV_Output_Folder = "#{Home_Path}/Desktop/Anki Generated Sources"
  Default_Source_Path = "#{Home_Path}/Dropbox/Documents/Reviewer/@test.txt"

  # exposed for testability
  attr_reader :source_absolute_path, :html_generator


  # Initialize source file name.
  def initialize(source_file: Default_Source_Path)
    @reviewer = Reviewer.new
    @source_absolute_path = source_file
    $logger.info "File Path: #@source_absolute_path"
  end
  

  def generate_output_filepath
    today = Time.now
    basename = File.basename(@source_absolute_path, '.*')
    "#{Home_Path}/Desktop/Anki Generated Sources/#{basename} #{ today.strftime('%Y%b%d_%H%M') }.tsv"
  end


  # It opens source file for reading.
  # It opens CSV file.
  # It has to invoke #init_html_generator()
  def execute
    # $logger.info 'Program Start. Unit Test: %s' % ($unit_test ? 'Y' : 'n')
    # return if $unit_test

    File.open(@source_absolute_path, 'r') do |file|

      tag_counter = TagCounter.new
      tag_count_map = tag_counter.count_tags(file) if tag_counter  # for testability
      output_absolute_path = generate_output_filepath

      init_html_generator(file)
      
      CSV.open(output_absolute_path, 'w', {col_sep: "\t"}) do |csv|

        SourceReader.new(file).each_card do |tags, front, back|
          process_card(csv, front, back, tags, count_map: tag_count_map)
        end

        @reviewer.print_sellout
        @reviewer.print_duplicate
        @reviewer.print_card_count
        @reviewer.print_multi

        deckname = File.basename(output_absolute_path)
        puts('', deckname , '')
      end
    end
  end


  def init_html_generator(file)
    meta_map = MetaReader.read(file)
    language = meta_map[:lang]
    $logger.info("Language: #{ language }")
    
    highlighter = BaseHighlighter
    highlighter = if language
       highlighter.send("lang_#{ language.downcase }")
    else
      BaseHighlighter.lang_none
    end
    @html_generator = HtmlGenerator.new(highlighter)
  end


  def process_card(csv, front, back, tags, count_map: {})
    tag_helper = TagHelper.new(tags: tags)
    tag_helper.index_enum(back)

    @reviewer.count_sentence(tag_helper, front, back)
    @reviewer.detect_sellouts(front, back) unless tag_helper.is_front_only?

    tsv_compat_lst = []
    tsv_compat_lst << @html_generator.format_front(tag_helper, front)
    tsv_compat_lst << @html_generator.format_back(tag_helper, back)
    tsv_compat_lst << SystemTagCounter.new.count(tag_helper, map: count_map)

    debug_print_cards(tsv_compat_lst)
    @reviewer.register_front_card(tags, front)
    csv << tsv_compat_lst
    
  end


  # def write_card(csv, front, back, tags, highlighter: nil, count_map: {})
  #   tag_helper = TagHelper.new(tags: tags)
  #   tag_helper.index_enum(back)

  #   @reviewer.count_sentence(tag_helper, front, back)
  #   @reviewer.detect_sellouts(front, back) unless tag_helper.is_front_only?

  #   html_helper = HtmlGenerator.new(highlighter, tag_helper, front, back)
  #   tsv_compat_lst = [html_helper.front_html, html_helper.back_html]

  #   tsv_compat_lst << SystemTagCounter.new.count(tag_helper, map: count_map)

  #   debug_print_cards
  #   # @reviewer.addFrontCard(tags, front)
  #   csv << tsv_compat_lst
  # end

end



# :nocov:
# Used for debugging only
def debug_print_cards(lst)
  if $logger.debug?
    re_styleless = /<div[\d\D]*/m

    $logger.debug("Front: \n#{ lst[0] }\n\n")
    $logger.debug("Back: \n#{ lst[1] }\n\n")

    # $logger.debug("Front: \n#{ lst[0][re_styleless] }\n\n")
    # $logger.debug("Back: \n#{ lst[1][re_styleless] }\n\n")

    # $logger.debug("Tag: \n" + lst[2] + "\n\n")
  end
end
# :nocov:


path = '/Users/royce/Dropbox/Documents/Reviewer'

unless $unit_test
  if ARGV.empty? or 'upload' === ARGV[0]
    # - Generate a single file
    main = MainClass.new({:source_file => LatestFileFinder.new(path, '*.md').find})
    main.execute
    RunSelenium.execute unless ARGV.empty? || 'upload' != ARGV[0].downcase

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
