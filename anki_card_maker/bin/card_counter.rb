require './lib/source_reader'
require './lib/tag_helper'

path = '/Users/royce/Dropbox/Documents/Reviewer/ruby'

total_cards = 0
total_files = 0

Dir[File.join(path, '*.txt')].each do |filename|
  if filename.end_with? '.txt' or filename.end_with? '.api'
    total_files += 1
    File.open(filename, 'r') do |file|
      card_count = 0
      SourceReader.new(file).each_card do |tags, front, back|
        card_count += 1
      end
      puts "#{filename}: #{card_count}"
      total_cards += card_count
    end
  end
end
puts "Total files: #{total_files}"
puts "Total cards: #{total_cards}"


