module FileReader

  def self.read_as_list(filename)
    File.read('./data/' + filename).lines.collect { |line| line.chomp }
  end

end
