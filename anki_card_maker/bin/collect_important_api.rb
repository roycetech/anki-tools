require './lib/source_reader'
require './lib/tag_helper'
require './lib/latest_file_finder'
require './lib/mylogger'
require './lib/meta_reader'


class CollectImportantApi 

  def run

    file_mask = '*.md'
    find_path(file_mask)
    read_list()

    output_builder = ""
    total = 0
    Dir[File.join(@path, file_mask)].each do |filename|
      if !filename.include?('README.md')


        # $logger.info("Opening file: #{filename}")

        File.open(filename, 'r') do |file|

          meta_map = MetaReader.read(file)
          common_tag = meta_map['commontag']
          
          SourceReader.new(file).each_card do |tags, front, back|
            
            if common_tag
              tags.push(common_tag.capitalize)
            end

            unticked = front[0].gsub('`', '') unless front[0].nil?
            if front_included(unticked) || !tags.empty? && !(@list & tags).empty?
              output = ""
              output += "@Tags: #{tags.join(', ')}\n" unless tags.empty?
              output += (front[0].chomp + "\n\n")
              output += back[0]
              output += "\n\n\n"

              puts(output)
              output_builder += output
              total += 1
            end
          end
        end
      end
    end

    # $logger.info(output_builder)
    $logger.info("Total: #{total}")

  end

  def front_included(front_card)
    found = false
    @list.each do |element|
      if front_card[Regexp.new("\\b#{element}\\b")]
        found = true
        break
      end
    end
    found
  end


  # Find the path where the last file was modified.
  def find_path(file_mask)
    finder = LatestFileFinder.new('/Users/royce/Dropbox/Documents/Reviewer', file_mask)
    finder.find
    @path = finder.latest_folder
    $logger.debug("Path: #{@path}")
  end


  def read_list
    @list = []
    File.open( "#{@path}/Zimportant.lst", 'r' ) do |file|
      while line = file.gets
        if line[0] != '#' && !line.chomp.empty?
          @list.push(line.strip)
        end
      end
    end
  end

end

CollectImportantApi.new.run