
class TagCounter

  def initialize    
    @return_value = {}
  end


  def count_tags(file, common_tag = nil)
    SourceReader.new(file).each_card do |tags, front, back|      
      if common_tag
        tags.push(common_tag)
      end

      tags.each do |tag|
        count = ObjUtil.nvl( @return_value[tag], 0)
        count += 1
         @return_value[tag] = count
      end
    end

    file.rewind
    @return_value
  end

end