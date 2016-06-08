require './lib/source_reader'
require './lib/tag_helper'
require 'logger'


# path = '/Users/royce/Dropbox/Documents/Reviewer/java/EJB'
# path = '/Users/royce/Dropbox/Documents/Reviewer/ruby/API'
path = '/Users/royce/Dropbox/Documents/Reviewer/jQuery'



$logger = Logger.new(STDOUT)


$logger.formatter = proc do |severity, datetime, progname, msg|
  # subscript 3 for eclipse/commandline, 4 for sublime 2
  line = caller[3]
  source = line[line.rindex('/', -1)+1 .. -1]
  "#{severity} #{source} - #{msg}\n"
end


total_cards = 0
total_files = 0
total_api = 0

Dir[File.join(path, '*.txt')].each do |filename|
  if filename.end_with? '.txt' or filename.end_with? '.api'
    total_files += 1
    File.open(filename, 'r') do |file|
      card_count = 0
      SourceReader.new(file).each_card do |tags, front, back|
        card_count += 1
      end

      if filename.include?'-API-'
        total_api += card_count
      end

      puts "#{filename}: #{card_count}"
      total_cards += card_count
    end
  end
end
puts "Total files: #{total_files}"
puts "Total cards: #{total_cards}"
puts "Total API cards: #{total_api}"
puts "Total non-API cards: #{total_cards-total_api}"


