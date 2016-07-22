
class TagCounter


  def self.count_tags(file)

    return_value = {}
    SourceReader.new(file).each_card do |tags, front, back|      
      tags.each do |tag|
        count = ObjUtil.nvl(return_value[tag], 0)
        count += 1
        return_value[tag] = count
      end
    end

    file.rewind
    return_value
  end

end