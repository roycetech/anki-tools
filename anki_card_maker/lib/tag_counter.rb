
class TagCounter


  attr_reader :tags_count


  def initialize    
    @tags_count = {}
  end


  # common_tag - used for ?
  def count_tags(file, common_tag = nil)
    SourceReader.new(file).each_card do |tags, front, back|            
      # tags.push(common_tag) if common_tag
      register_tags(tags)
      
      # tags.each do |tag|
      #   count = @return_value[tag] || 0
      #   count += 1
      #    @return_value[tag] = count
      # end

    end

    file.rewind
    @tags_count
  end

  def register_tags(tags)
    tags.each do |tag|
      count = @tags_count[tag] || 0
      count += 1
       @tags_count[tag] = count
    end
  end

end