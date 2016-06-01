
# Finds the latest modified file in a directory and its subdirectories.
class LatestFileFinder


  def initialize(root_path, file_mask = '*.txt')
    @root_path = root_path
    @file_mask = file_mask
    @last_modified_file = nil
    @last_modified_filedate = nil
  end


  def find
    recurse_find @root_path
    puts "Last modified date/time: #{@last_modified_filedate}"
    @last_modified_file
  end


  def recurse_find(path)
    Dir[File.join(path, @file_mask)].each do |filename|
      if @last_modified_file.nil? or File.mtime(filename) > @last_modified_filedate
        @last_modified_file = filename
        @last_modified_filedate = File.mtime(filename)
      end
    end

    dirs = list_dir(path)
    dirs.each do |dirname|
      recurse_find(File.join(path, dirname))
    end
  end

  def list_dir(path)
    dirs = Dir.entries(path).select do |entry| 
      File.directory? File.join(path, entry) and !(entry =='.' || entry == '..') 
    end
  end

  private :recurse_find


end

# path = '/Users/royce/Dropbox/Documents/Reviewer'
# puts LatestFileFinder.new(path).find
