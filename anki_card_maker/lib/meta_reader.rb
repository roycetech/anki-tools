
class MetaReader 

  def self.read(file)

    return_value = {}
    while line = file.gets
      line.rstrip!

      if line[0, 3] == '# @'
        key = line[/(?:@)(\w*)/, 1].downcase
        value = line[/(?:=)(\w*)/, 1].downcase
        return_value[key] = value
      end
      break if line[0, 1] != '' and line[0, 1] != '#';
    end
    file.rewind
    return_value
  end

end