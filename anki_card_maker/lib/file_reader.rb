module FileReader

  def self.read_as_list(filename)
    return File.read('./data/' + filename).lines.collect do |line|
      line.chomp
    end
  end

end
