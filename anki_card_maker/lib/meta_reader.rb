

# Reads the meta data on top of the source file.  Will rewind file reading, 
# to make the pointer as if the file is freshly opened.
class MetaReader 

  def self.read(file)

    return_value = {}
    while line = file.gets
      line.rstrip!
      if line[0, 3] == '# @'
        key = line[/(?:@)(\w*)/, 1].downcase.to_sym
        value = line[/(?:=)(.*)/, 1]
        return_value[key] = value
      end
      break unless line[0, 1].empty? || line[0, 1] == '#';
    end
    file.rewind
    return_value
  end

end